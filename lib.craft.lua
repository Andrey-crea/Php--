-- Recovered code lib.craft.lu + fix after decompilation
-- Lua 5.1.5
-- Day R Survival v694
local craft = {}
local helper = {}
local state_list = {'hp', 'food', 'water', 'energy', 'radiation'}

function craft.getIterationMax(self, params)
    local item = main.itemlist:get(params.id or params.itemId)
    local event = params[1] or params.event
        or params.eventName and item and item.events[params.eventName]
    local area_id = main.cache:get('area', 'id')
    local info = params.pos and main.character:get('inventory', params.pos)
    if item and not info then
        if params.priority == 'droplist' then
            info = main.inventory.getDrop(item.id)
                or main.inventory.getItem(item.id)
        else
            info = main.inventory.getItem(item.id)
                or main.inventory.getDrop(item.id)
        end
    end
    local quantity = info and math2.cipherToNum(info[2], info[3])
    local depreciation = info and info[4][1] or 0
    local max_value = 1000
    local max_by_quantity
    if event.quantity and event.quantity < 0 and quantity then
        max_by_quantity = math.abs(math.floor(quantity / event.quantity))
    end
    local max_by_depreciation
    if event.depreciation and event.depreciation > 0 then
        max_by_depreciation = math.abs(
            math.ceil((100 - depreciation) / event.depreciation)
        )
    end
    local consume_list = {}
    local tool_list = {}
    if event.need then
        for i = 1, #event.need do
            local need = event.need[i]
            if need[3] then
                consume_list[#consume_list + 1] = need
            else
                tool_list[#tool_list + 1] = need
            end
        end
    end
    local max_by_consume
    for i = 1, #consume_list do
        local need = consume_list[i]
        local count = main.inventory:getItemTagCount({
            id = need[1],
            isAll = true,
            isConsume = true,
            priority = params.priority,
            onlyInventory = params.notDrop
        })
        local iteration_count = math.floor(count / need[2])
        max_by_consume = math.min(
            iteration_count,
            max_by_consume or iteration_count
        )
    end
    local max_by_tool
    for i = 1, #tool_list do
        local need = tool_list[i]
        local item_list = main.inventory:getItemTagList({
            id = need[1],
            isAll = true,
            priority = params.priority,
            onlyInventory = params.notDrop
        })
        local use_count = 0
        if item_list then
            for j = 1, #item_list do
                local tool = item_list[j]
                local tool_item = main.itemlist:get(tool.id)
                local tool_info = tool.pos
                    and main.character:get('inventory', tool.pos)
                    or main.inventory.getDrop(tool.id)
                local tool_quantity = math2.cipherToNum(
                    tool_info[2],
                    tool_info[3]
                )
                local tool_depreciation = tool_item.events.usedInCraft
                    and tool_item.events.usedInCraft.depreciation
                if tool_depreciation then
                    for k = 1, #tool_info[4] do
                        local value = tool_info[4][k]
                        use_count = use_count
                            + math.ceil((100 - value) / tool_depreciation)
                    end
                    local new_count = tool_quantity - #tool_info[4]
                    use_count = use_count
                        + new_count * math.ceil(100 / tool_depreciation)
                else
                    use_count = max_value
                end
            end
        end
        max_by_tool = math.min(max_by_tool or use_count, use_count)
    end
    local result = math.min(
        max_by_quantity or max_value,
        max_by_depreciation or max_value,
        max_by_consume or max_value,
        max_by_tool or max_value
    )
    return math.max(result, 1)
end

function helper.checkNeedArea(event, area)
    local is_ok = true
    local need_list = event.needArea or {}
    for i = 1, #need_list do
        local need = need_list[i]
        local value = main.class.get(area, need[1]) or false
        local is_invert = need.isInvert or false
        if type(need[1]) == 'table' then
            value = main.class.get(area, unpack(need[1])) or false
        elseif need[1] == 'isLoot' then
            value = not main.location:checkLooted(area)
        end
        if is_invert == math2.operateComparison(value, need[2], need[3]) then
            is_ok = false
        end
        if is_ok and need.isOr then
            break
        end
        if not is_ok and need.isOr and i ~= #need_list then
            is_ok = true
        end
        if not is_ok then
            break
        end
    end
    return is_ok
end

function helper.checkNeedBiome(event, biome, area)
    local is_ok = true
    if event.needBiome and biome
        and not table.eq2(event.needBiome, biome.id) then
        is_ok = false
    end
    if event.notBiome and biome and table.eq2(event.notBiome, biome.id) then
        is_ok = false
        if biome.id == BIOME_CITY and area
            and area.isCheckpoint and not area.isBaseNpc then
            is_ok = true
        end
    end
    return is_ok
end

function craft.check(self, params)
    local is_ok = true
    local error_text
    local item = main.itemlist:get(params.id)
    local event = params.event
        or params.eventName and item and item.events[params.eventName]
    local biome = main.cache:get('biome')
    local area = main.cache:get('area')
    local area_id = area and area.id
    if not event then
        print('check not event', params.eventName)
        return false
    end
    local mult = params.mult or 1
    local info = params.itemInfo
        or params.pos and main.character:get('inventory', params.pos)
    if item and not info then
        if params.priority == 'droplist' then
            info = main.inventory.getDrop(item.id)
                or main.inventory.getItem(item.id)
        else
            info = main.inventory.getItem(item.id)
                or main.inventory.getDrop(item.id)
        end
    end
    params.notDrop = params.notDrop or event.notDrop
    local quantity = info and math2.cipherToNum(info[2], info[3]) or 0
    local depreciation = info and info[4][1] or 0
    if item and item.isChargeItem and event.depreciation then
        if event.depreciation > 0 and depreciation >= 100 then
            is_ok = false
            error_text = strings.noCharge
        elseif event.depreciation < 0 and depreciation <= 0 then
            is_ok = false
            error_text = strings.fullCharge
        end
        if event.character and event.character.radiation
            and event.character.radiation < 0
            and main.character:get('radiation')
                + event.character.radiation < 0 then
            is_ok = false
            error_text = strings.events.need .. ': ' .. strings.radiation
                .. ' ' .. math.abs(event.character.radiation)
        end
    end
    if item and depreciation and event.needDepr
        and (depreciation < event.needDepr[1]
            or depreciation > event.needDepr[2]) then
        is_ok = false
    end
    if item and not item.isChargeItem and info and depreciation < 2 then
        local event_depreciation = event.depreciation or 0
        if event_depreciation < 0 then
            is_ok = false
            error_text = strings.console.notRepair
        end
    end
    if event.quantity
        and (not info or quantity + event.quantity * mult < 0) then
        is_ok = false
        error_text = strings.events.need .. ': ' .. item.name .. ' x'
            .. math.abs(event.quantity * mult - quantity)
    end
    if is_ok and event.needLevel then
        local level = main.level:getHeroValue('level') or 1
        if not math2.operateComparison(
            level,
            event.needLevel[1],
            event.needLevel[2]
        ) then
            is_ok = false
        end
    end
    if is_ok and (event.needBiome or event.notBiome)
        and not helper.checkNeedBiome(event, biome, area) then
        is_ok = false
        error_text = event.errorTextBiome or 'errorTextBiome'
    end
    if is_ok and event.needArea and not helper.checkNeedArea(event, area) then
        is_ok = false
    end
    if is_ok and event.isNeedShadow and not main.halloween:checkShadow() then
        is_ok = false
        error_text = strings.onlyInShadow
    end
    if event.isNeedPremium and not main.profile:getPremium() then
        is_ok = false
    end
    if event.needWear and item
        and (params.onlyDrop or not main.equipment:checkWear(item.id)) then
        is_ok = false
    end
    if params.eventName == 'eat' and event.character
        and not event.ignoreParam then
        local max_value = math.max(
            event.character.food or 0,
            event.character.water or 0
        )
        if max_value == event.character.food and max_value > 0
            and main.character:get('food')
                > main.calculate:get('foodMax') - 2 then
            is_ok = false
            error_text = strings.console.notHunger
        end
        if max_value == event.character.water and max_value > 0
            and main.character:get('water')
                > main.calculate:get('waterMax') - 2 then
            is_ok = false
            error_text = strings.console.notThirst
        end
        if event.character.energy
            and main.character:get('energy')
                + event.character.energy <= 1 then
            is_ok = false
            error_text = strings.warningList.exhaustion
        end
    end
    if event.useWeapon then
        local weapon_tag = event.useWeapon[1]
        if #main.equipment:getWeaponList({tag = weapon_tag}) == 0 then
            is_ok = false
        end
    end
    if is_ok and event.needLooted then
        for i = 1, #event.needLooted do
            local need = event.needLooted[i]
            local location = main.location:get(need[1])
            if not location or not main.location:checkLooted(location) then
                is_ok = false
                break
            end
        end
    end
    if is_ok and event.needState then
        for i = 1, #event.needState do
            local need = event.needState[i]
            local value
            if type(need[1]) == 'table' then
                value = main.character:get(unpack(need[1])) or 0
            else
                value = main.character:get(need[1]) or 0
            end
            if (need.isInvert or false)
                == math2.operateComparison(value, need[2], need[3]) then
                is_ok = false
            end
            if is_ok and need.isOr then
                break
            end
            if not is_ok and need.isOr and i ~= #event.needState then
                is_ok = true
            end
            if not is_ok then
                break
            end
        end
    end
    if is_ok and event.needCache then
        for i = 1, #event.needCache do
            local need = event.needCache[i]
            local value
            if type(need[1]) == 'table' then
                value = main.cache:get(unpack(need[1])) or 0
            else
                value = main.cache:get(need[1]) or 0
            end
            if (need.isInvert or false)
                == math2.operateComparison(value, need[2], need[3]) then
                is_ok = false
            end
            if is_ok and need.isOr then
                break
            end
            if not is_ok and need.isOr and i ~= #event.needCache then
                is_ok = true
            end
            if not is_ok then
                break
            end
        end
    end
    if is_ok and event.needWeather then
        local weather = main.weather:getCurrentObj()
        for i = 1, #event.needWeather do
            local need = event.needWeather[i]
            local is_invert = need.isInvert or false
            local is_match = weather
                and (need[1] == weather.id or weather.tagTable[need[1]])
                or false
            if is_invert == is_match then
                is_ok = false
                error_text = event.errorTextWeather
                break
            end
        end
    end
    if is_ok and event.needDisease then
        for i = 1, #event.needDisease do
            local need = event.needDisease[i]
            local disease_list = main.disease:getHaveList({tag = need[1]})
            if need.isInvert and #disease_list > 0
                or not need.isInvert and #disease_list < 1 then
                is_ok = false
            end
            if not is_ok then
                break
            end
        end
    end
    if is_ok and event.needAlly then
        for i = 1, #event.needAlly do
            local need = event.needAlly[i]
            local ally_obj = main.character:getObj('allyList', need[1])
            local ally = ally_obj and main.ally:get(ally_obj.id)
            local ally_level = ally_obj and ally:getLevel(ally_obj) or 0
            if not ally_obj and not need.isInvert
                or ally_obj and need.isInvert
                or need.level and ally_level < need.level then
                is_ok = false
                break
            end
        end
    end
    if is_ok and event.needPerk then
        for i = 1, #event.needPerk do
            local need = event.needPerk[i]
            local perk_id = need[1]
            local perk = main.character:get('perkTable', perk_id)
            if not perk and not need.isInvert or perk and need.isInvert then
                is_ok = false
                break
            end
        end
    end
    if is_ok and event.needQuestStep then
        for i = 1, #event.needQuestStep do
            local need = event.needQuestStep[i]
            local quest = main.quest:get(need[1])
            local step_obj = quest and quest:getStepObj(need[2])
            local is_step = step_obj
                and main.quest:checkStep({obj = quest, stepObj = step_obj})
                or false
            if is_step == (need.isInvert or false) then
                is_ok = false
                break
            end
        end
    end
    if is_ok and event.needQuestState then
        for i = 1, #event.needQuestState do
            local need = event.needQuestState[i]
            local quest_obj = main.character:getObj('questList', need[1])
            if (need.isInvert or false) == math2.operateComparison(
                quest_obj and quest_obj.stepId or 0,
                need[2],
                need[3]
            ) then
                is_ok = false
            end
            if is_ok and need.isOr then
                break
            end
            if not is_ok and need.isOr and i ~= #event.needQuestState then
                is_ok = true
            end
            if not is_ok then
                break
            end
        end
    end
    if is_ok and event.need then
        for i = 1, #event.need do
            local need = event.need[i]
            local limit = math.round(need[2] * (need[3] and mult or 1))
            local item_list, count = main.inventory:getItemTagList({
                id = need[1],
                limit = limit,
                isConsume = need[3],
                priority = params.priority,
                isChoose = need.isChoose,
                onlyInventory = need.notDrop or params.notDrop,
                isSpendPart = need.spendPart
            })
            local is_invert = need.isInvert or false
            if is_invert == (item_list and true or false) or limit <= 0 then
                is_ok = false
            end
            local tag_name = not is_ok and main.itemlist:getTagName(need[1])
            if not is_ok and need.isInvert then
                error_text = strings.havent .. ': ' .. tag_name
            elseif not is_ok then
                error_text = strings.events.need .. ': ' .. tag_name
                    .. ' x' .. (count or 0)
            end
            if not is_ok then
                break
            end
        end
    end
    if event.isInvert then
        is_ok = not is_ok
    end
    return is_ok, error_text
end

function helper.getGiveQuantity(event, give, mult)
    mult = mult or 1
    local item = main.itemlist:get(give[1])
    local min_value = give[2]
    local max_value = give[2]
    if type(give[2]) == 'table' then
        min_value = give[2][1]
        max_value = give[2][2]
    end
    local bonus = 1
    if event.isPerkEffect then
        bonus = bonus
            + main.calculate:getItemValueAll(item, 'craftItemQuantity')
    end
    min_value = math.round(min_value * mult * bonus)
    max_value = math.round(max_value * mult * bonus)
    return min_value, max_value
end

function helper.setItemQuantity(item, info, value)
    local quantity = math2.cipherToNum(info[2], info[3]) + value
    if quantity < 0 then
        quantity = 0
    end
    local cipher, key = math2.numToCipher(quantity)
    info[3] = key
    info[2] = cipher
    if item.singleDepreciation and value < 0 then
        local remove_count = math.min(math.abs(value), #info[4])
        for i = 1, remove_count do
            table.remove(info[4], 1)
        end
        info[4][1] = info[4][1] or 0
    end
end

function craft.run(self, params)
    params.mult = params.mult or 1
    local is_ok = true
    local item = main.itemlist:get(params.id)
    local event_name = params.eventName
    local event = params.event
        or params.eventName and item and item.events[params.eventName]
    local area_id = main.cache:get('area', 'id')
    if not event then
        return
    end
    local mult = params.mult
    local response = {need = {}, give = {}}
    params.toDrop = params.toDrop or event.toDrop
    local info = params.info
    if item and not info then
        if params.priority == 'droplist' then
            info = main.inventory.getDrop(item.id)
                or main.inventory.getItem(item.id)
        else
            info = main.inventory.getItem(item.id)
                or main.inventory.getDrop(item.id)
        end
    end
    is_ok = craft:check(params)
    local spend_list = {}
    if is_ok and event.need then
        for i = 1, #event.need do
            local need = event.need[i]
            local limit = math.round(need[2] * (need[3] and params.mult or 1))
            local item_list = main.inventory:getItemTagList({
                id = need[1],
                limit = limit,
                posInNeed = i,
                priority = params.priority,
                isConsume = need[3],
                isSpendPart = need.spendPart,
                onlyInventory = params.notDrop
            })
            if item_list then
                spend_list = table.combine2(spend_list, item_list)
            elseif not need.isInvert then
                is_ok = false
                break
            end
        end
    end
    local spend_count = 0
    local spend_depreciation = 0
    if is_ok and spend_list then
        for i = 1, #spend_list do
            local spend = spend_list[i]
            local spend_item = main.itemlist:get(spend.id)
            local spend_info = spend.pos
                and main.character:get('inventory', spend.pos)
                or area_id and main.inventory.getDrop(spend.id)
            local depreciation_list = spend_info and spend_info[4]
            local need = event.need and spend.posInNeed
                and event.need[spend.posInNeed]
            local used_in_craft = spend_item.events.usedInCraft
            if spend_info and spend.isConsume then
                if not need.notDepreciation then
                    spend_count = spend_count + spend.quantity
                    spend_depreciation = spend_depreciation
                        + spend_info[4][1] * spend.quantity
                end
                helper.setItemQuantity(spend_item, spend_info, -spend.quantity)
            elseif spend_info and not spend.isConsume then
                local depreciation = depreciation_list[1]
                if used_in_craft and used_in_craft.depreciation then
                    depreciation = depreciation
                        + used_in_craft.depreciation * params.mult
                        * (need.mult or 1)
                end
                if need and need.depreciation then
                    depreciation = depreciation
                        + need.depreciation * params.mult
                end
                if depreciation < 0 then
                    depreciation = 0
                end
                depreciation_list[1] = depreciation
            end
            if spend_info and spend.isConsume then
                response.need[#response.need + 1] = {spend.id, spend.quantity}
            end
        end
    end
    if is_ok and event.depreciation and info then
        local event_depreciation = craft:getEventDepreciation(
            item,
            event,
            event_name,
            mult,
            params.priority == 'droplist'
        )
        local depreciation = info[4][1] or 0
        local depreciation_old = depreciation
        depreciation = math.max(depreciation + event_depreciation, 0)
        depreciation = math.min(depreciation, 100)
        info[4][1] = depreciation
        if depreciation == 0 and #info[4] > 1 then
            table.remove(info[4], 1)
        end
        response.itemDepreciationOld = depreciation_old
        response.itemDepreciationNew = depreciation
    end
    if is_ok and event.quantity and info then
        local quantity = event.quantity * params.mult
        helper.setItemQuantity(item, info, quantity)
        response.need[#response.need + 1] = {item.id, math.abs(quantity)}
    end
    if is_ok and event.useWeapon and params.useWeapon then
        local weapon_id = params.useWeapon[1]
        local weapon_item = main.itemlist:get(weapon_id)
        local hero = main.battle.unit:newObjHero({id = 'hero'})
        local weapon = main.battle.weapon:newObj(
            {id = weapon_item.weaponId or weapon_item.id},
            hero
        )
        local is_use, use_response = weapon:use({notAp = true})
        if use_response then
            table.combine2(response.need, use_response.need)
            table.combine2(response.give, use_response.give)
        end
    end
    if is_ok and event.give then
        for i = 1, #event.give do
            local give = event.give[i]
            local give_item = main.itemlist:get(give[1])
            if not give.chance or math.random(1000) / 1000 <= give.chance then
                local depreciation = give[3]
                    or spend_count > 0 and spend_depreciation / spend_count
                    or 0
                local min_value, max_value = helper.getGiveQuantity(
                    event,
                    give,
                    params.mult
                )
                local quantity = math.random(min_value, max_value)
                if type(depreciation) == 'table' then
                    depreciation = math.random(
                        depreciation[1],
                        depreciation[2]
                    )
                elseif give[5] then
                    depreciation = math.random(give[3], give[5])
                end
                if give_item and quantity > 0 then
                    local add_params = {
                        id = give[1],
                        quantity = quantity,
                        depreciation = depreciation,
                        camp = true,
                        notCheck = true
                    }
                    if give_item.singleDepreciation and quantity > 1 then
                        local dep_count = math.min(quantity - 1, 5)
                        for j = 1, dep_count do
                            local value = give[3] or 0
                            if type(value) == 'table' then
                                value = math.random(value[1], value[2])
                            elseif give[5] then
                                value = math.random(value, give[5])
                            end
                            add_params.depList = add_params.depList or {}
                            add_params.depList[#add_params.depList + 1] =
                                value
                        end
                    end
                    if not give_item.notDrop
                        and not give_item.tagTable.quest_related
                        and (give_item.alwaysOnDrop
                            or params.priority == 'droplist'
                            or params.toDrop) then
                        main.inventory.putItemTo(add_params)
                    else
                        main.inventory.add(add_params)
                    end
                    response.give[#response.give + 1] = {
                        give[1],
                        quantity,
                        depreciation
                    }
                    if (event.itemExplosion or give.itemExplosion)
                        and (params.iterations or 1) == 1 then
                        main.animation:addItem({give[1], quantity})
                    elseif event.isGiveWarning
                        and (params.iterations or 1) == 1 then
                        local text = '+ ' .. give_item.name .. ' x' .. quantity
                        main.animation:run({
                            id = 'item_warning',
                            text = text,
                            isAdd = true
                        })
                    end
                end
            end
        end
    end
    if is_ok then
        if event.addAlly then
            for i = 1, #event.addAlly do
                local add_ally = event.addAlly[i]
                if main.ally:get(add_ally[1])
                    and main.ally:checkAdd({id = add_ally[1]}) then
                    main.ally:add({
                        id = add_ally[1],
                        level = add_ally[2],
                        hp = add_ally.hp,
                        food = add_ally.food
                    })
                end
            end
        end
        if event.setAlly then
            local ally = main.ally:get(event.setAlly.id)
            local ally_obj = ally and main.character:getObj('allyList', ally.id)
            if ally_obj then
                if event.setAlly.exp then
                    main.ally:addExp({obj = ally, expValue = event.setAlly.exp})
                end
                if event.setAlly.food then
                    ally_obj.food = ally_obj.food + event.setAlly.food
                    ally_obj.food = ally_obj.food > 100 and 100
                        or ally_obj.food < 0 and 0
                        or ally_obj.food
                end
                if event.setAlly.hp then
                    ally_obj.hp = ally_obj.hp + event.setAlly.hp
                    ally_obj.hp = ally_obj.hp > 100 and 100
                        or ally_obj.hp < 0 and 0
                        or ally_obj.hp
                end
            end
        end
        if event.character and not params.notCharacter then
            response.character = event.character
            main.character:changeStat({
                event = event,
                state = event.character,
                mult = params.mult
            })
        end
        if event.enemyGroup then
            main.battle:meetGroupEnemy({enemyGroup = event.enemyGroup})
        elseif event.enemy then
            main.battle:meet({enemyId = event.enemy})
        end
        if event.setState then
            for i = 1, #event.setState do
                local set_state = event.setState[i]
                local value = set_state[2]
                if type(set_state.get) == 'table' then
                    value = main.character:get(unpack(set_state.get)) or 0
                elseif set_state.get then
                    value = main.character:get(set_state.get) or 0
                end
                main.character:edit(set_state[1], value, set_state[3])
            end
        end
        if event.setCache then
            for i = 1, #event.setCache do
                local set_cache = event.setCache[i]
                local value = set_cache[2]
                if type(set_cache.get) == 'table' then
                    value = main.cache:get(unpack(set_cache.get)) or 0
                elseif set_cache.get then
                    value = main.cache:get(set_cache.get) or 0
                end
                main.cache:edit(set_cache[1], value, set_cache[3])
            end
        end
        if event.diseaseList then
            local index_list = table.random2(#event.diseaseList)
            local add_count = 0
            for i = 1, #index_list do
                local index = index_list[i]
                local disease_def = event.diseaseList[index]
                if disease_def[3]
                    or main.disease:checkAdd({id = disease_def[1]}) then
                    local chance = math.random(10000) / 10000
                    local disease = main.disease:get(disease_def[1])
                    if chance <= disease_def[2] then
                        add_count = add_count + 1
                        main.disease:add({
                            id = disease_def[1],
                            response = response
                        })
                        if event.diseaseList.explosion then
                            main.animation:addItem({
                                title = strings.geted_traumas,
                                text = disease.name
                            })
                        end
                    end
                end
                if event.diseaseList.limit
                    and add_count >= event.diseaseList.limit then
                    break
                end
            end
        end
        if event.setDisease then
            for i = 1, #event.setDisease do
                local set_disease = event.setDisease[i]
                local disease_obj = main.character:getObj(
                    'disease',
                    set_disease[1]
                )
                if disease_obj then
                    local value = disease_obj[set_disease[2]]
                    local operand = set_disease[3]
                    disease_obj[set_disease[2]] = math2.operate(
                        set_disease[4],
                        value,
                        operand
                    )
                end
            end
        end
        if event.setPeriodDay then
            for i = 1, #event.setPeriodDay do
                local period_day = event.setPeriodDay[i]
                main.character:setPeriodDay(period_day[1], period_day[2])
            end
        end
        if event.setQuestStep then
            for i = 1, #event.setQuestStep do
                local quest_step = event.setQuestStep[i]
                local quest_obj = main.character:getObj(
                    'questList',
                    quest_step[1]
                )
                local step_id = quest_obj and quest_obj.stepId or 0
                if step_id < quest_step[2] then
                    main.quest:addQuest({
                        id = quest_step[1],
                        stepId = quest_step[2],
                        notOpen = true
                    })
                end
            end
        end
        if event.chest then
            main.character:edit('count_package', 1, '+')
            if not main.character:get('defaultValue', 'package') then
                main.character:edit(
                    {'defaultValue', 'package'},
                    math.random(1000)
                )
            end
            local seed = main.character:get('defaultValue', 'package')
                + main.character:get('count_package')
            math.randomseed(seed)
            local chest = event.chest
            local start_index = math.random(#chest)
            local index = start_index
            local chest_list = {}
            repeat
                local chest_item = chest[index]
                if math.random(1000) / 1000 <= (chest_item.chance or 1) then
                    table.insert(chest_list, chest_item)
                end
                index = index + 1
                if index > #chest then
                    index = 1
                end
            until index == start_index or not chest[index]
                or (event.chest.limit or 1) == #chest_list
            for i = 1, #chest_list do
                local chest_item = chest_list[i]
                local chest_item_def = chest_item
                    and main.itemlist:get(chest_item[1])
                if chest_item_def then
                    local quantity = type(chest_item[2]) == 'table'
                        and math.random(chest_item[2][1], chest_item[2][2])
                        or chest_item[2]
                    local depreciation = type(chest_item[3]) == 'table'
                        and math.random(chest_item[3][1], chest_item[3][2])
                        or chest_item[3]
                    local add_params = {
                        id = chest_item_def.id,
                        quantity = quantity,
                        depreciation = depreciation,
                        camp = true,
                        notCheck = true
                    }
                    if not chest_item_def.notDrop
                        and not chest_item_def.tagTable.quest_related
                        and (chest_item_def.alwaysOnDrop
                            or params.priority == 'droplist'
                            or params.toDrop) then
                        main.inventory.putItemTo(add_params)
                    else
                        main.inventory.add(add_params)
                    end
                    response.give[#response.give + 1] = {
                        chest_item_def.id,
                        quantity,
                        depreciation
                    }
                    if event.itemExplosion or chest.itemExplosion then
                        main.animation:addItem({chest_item_def.id, quantity})
                    end
                end
            end
            math.randomseed(os.time())
        end
        if event.exp and (not event.expLimitLevel
            or main.level:getHeroValue('level') < event.expLimitLevel) then
            response.exp = main.level:getExp({event = event})
            main.level:addExp({event = event})
        end
        if event.addiction then
            main.disease:addictionIncrease({
                event.addiction[1],
                event.addiction[2],
                response = response
            })
        end
        if event.isEscapeFromArea then
            main.character:escapeFromArea()
        end
        if event.runRandomEvent and not params.notRandomEvent then
            main.randomEvent:run(event.runRandomEvent)
        end
        if event.addEventArea and not params.notRandomEvent then
            main.randomEvent:createEventArea({obj = event.addEventArea})
        end
        if event.giveItemsLoss then
            local items_loss = event.giveItemsLoss
            local loss_list = main.character:get('itemListLoss') or {}
            local limit = items_loss.limitCount
                or #loss_list * items_loss.limitPercent
                or 0
            limit = math.min(math.ceil(limit), #loss_list)
            for i = 1, limit do
                local loss = loss_list[i]
                local loss_item = main.itemlist:get(loss[1])
                if not loss_item.notDrop
                    and not loss_item.tagTable.quest_related then
                    main.inventory.putItemTo({id = loss[1], quantity = loss[2]})
                else
                    main.inventory.add({id = loss[1], quantity = loss[2]})
                end
            end
            for i = 1, limit do
                table.remove(loss_list, 1)
            end
        end
        if event.isRandomCookingRecipe then
            main.cooking:addRandomRecipe()
        end
        if event.action then
            event.action()
        end
        if event_name == 'cooking' or event_name == 'receipt' then
            main.dailyQuest:updateStepList({
                source = event_name,
                itemList = response.give
            })
        end
        params.response = response
        craft:other(params)
    end
    if not params.notCheck then
        main.inventory.checkAll(params)
    end
    return is_ok, response
end

function craft.other(self, params)
    local item = main.itemlist:get(params.id)
    local response = params.response
    local event_name = params.eventName
    local event = params.event
        or params.eventName and item and item.events[params.eventName]
    local area_id = main.cache:get('area', 'id')
    local key_list = {'need', 'give'}
    for i = 1, #key_list do
        local key = key_list[i]
        if key and event and event[key] then
            for j = 1, #event[key] do
                local entry = event[key][j]
                local entry_item = entry and main.itemlist:get(entry[1])
                if entry_item and entry_item.needUpdateCity and area_id then
                    main.cache:edit({'tableCampIcon', area_id}, nil)
                    main.map:update()
                    break
                end
            end
        end
    end
    if response.diseaseList and #response.diseaseList > 0
        and event and event.diseaseList then
        local message_disease
        local buff_list = {}
        for i = 1, #event.diseaseList do
            local disease_def = event.diseaseList[i]
            local disease = main.disease:get(disease_def[1])
            if disease_def.message
                and table.eq2(response.diseaseList, disease_def[1]) then
                message_disease = disease
                break
            elseif disease and disease.tagTable.buff then
                buff_list[#buff_list + 1] = disease
            end
        end
        if message_disease then
            main.interface:open({
                id = 'message',
                title = message_disease.name,
                text = message_disease.text
            })
        elseif #buff_list > 0 then
            for i = 1, #buff_list do
                local buff = buff_list[i]
                main.animation:run({
                    id = 'item_warning',
                    text = buff.name,
                    icon = buff.icon
                })
            end
        end
    end
    if event and event.stashMapId then
        local x, y = main.randomEvent:getStashXY({id = event.stashMapId})
        if x and y then
            main.interface:closeAll()
            main.map:moveArrow({x = x, y = y})
        else
            main.animation:run({id = 'warning', text = strings.uselessMap})
        end
    end
    if event and event.give then
        for i = 1, #event.give do
            local give = event.give[i]
            local give_item = main.itemlist:get(give[1])
            if give_item and give_item.events.readNote then
                main.craft:readNote({itemObj = give_item})
                break
            end
        end
    end
    if event and event.isNeedPremium and not main.profile:getPremium() then
        main.interface:open({
            id = 'premium_info',
            categoryId = 'stash',
            source = 'premium_chest'
        })
    end
    if event and event.give and event.give[1]
        and (event_name == 'receipt' or event_name == 'cooking') then
        local mult = params.mult
        main.analytics:runCraft(event_name, event, mult)
    elseif item and event and response and event.depreciation
        and event.depreciation < 0 and event_name == 'repair' then
        main.analytics:runRepair(item, event, response)
    end
end

function craft.broke(self, params)
    local item = main.itemlist:get(params.itemId or params.id)
    local info = params.info
        or params.pos and main.character:get('inventory', params.pos)
        or params.areaId and main.inventory.getDrop(params.id)
    if not item or not info then
        return
    end
    local quantity = math2.cipherToNum(info[2], info[3])
    local broke_count = 1
    if item.singleDepreciation then
        if info[4] then
            table.remove(info[4], 1)
        end
        info[4][1] = info[4][1] or 0
    else
        broke_count = quantity
    end
    quantity = quantity - broke_count
    local cipher, key = math2.numToCipher(quantity)
    info[3] = key
    info[2] = cipher
    local broke_event = item.events.broke or {}
    craft:run({
        event = broke_event,
        mult = broke_count,
        notCheck = true,
        priority = params.priority
    })
    local is_unwear = false
    if quantity < 1 and not params.areaId
        and main.equipment:checkWear(item.id) then
        is_unwear = true
        main.equipment:checkAll()
    end
    if is_unwear and item.tagTable.light then
        main.cache:edit('isBrokenLight', true)
        main.cache:edit('brokenLight', item)
    end
    if item.tagTable.transport then
        main.cache:edit('isStopMove', true)
        main.character:updateWorkload()
        main.character:updateSpeed()
    end
    if broke_event
        and not table.eq2(item.tagList, {'drink', 'quest_related', 'wolf'})
        and not params.notWarning then
        local text = (broke_event.name or strings.brokenItem) .. ': '
            .. item.name .. ' x' .. broke_count
        main.animation:run({id = 'item_warning', text = text})
    end
end

function craft.runAll(self, params)
    local area_id = main.cache:get('area', 'id')
    local event_name = params.eventName
    local run_params = {
        eventName = event_name,
        notCheck = true,
        priority = 'inventory',
        mult = params.mult,
        notCharacter = params.notCharacter
    }
    local pos_list = main.inventory:getEventItemList(event_name)
    if pos_list and not params.notInventory then
        for i = 1, #pos_list do
            local pos = pos_list[i]
            local info = pos and main.character:get('inventory', pos)
            run_params.id = (info and main.itemlist:get(info[1])).id
            run_params.info = info
            craft:run(run_params)
        end
    end
    local id_list = main.itemlist.event:get(event_name)
    if id_list and area_id and main.character:get('droplist', area_id)
        and not params.notDrop then
        run_params.onlyDrop = true
        run_params.priority = 'droplist'
        for i = 1, #id_list do
            local id = id_list[i]
            local info = main.inventory.getDrop(id)
            local item = main.itemlist:get(id)
            if info and item then
                run_params.id = item.id
                run_params.info = info
                craft:run(run_params)
            end
        end
    end
    if not params.notCheck then
        main.inventory.checkAll({notWarning = params.notWarning})
    end
end

function craft.getEventValueAll(self, params)
    local value = 0
    local event_name = params.eventName
    local area_id = main.cache:get('area', 'id')
    local check_params = {
        eventName = event_name,
        notCheck = true,
        priority = 'inventory'
    }
    local pos_list = main.inventory:getEventItemList(event_name)
    local slot_list = {}
    if pos_list and not params.notInventory then
        for i = 1, #pos_list do
            local pos = pos_list[i]
            local info = main.character:get('inventory', pos)
            local item = info and main.itemlist:get(info[1])
            local event = item and item.events[event_name]
            if item then
                check_params.id = item.id
                check_params.info = info
                if craft:check(check_params) then
                    if event.slot and params.max then
                        slot_list[event.slot] = math.max(
                            slot_list[event.slot] or 0,
                            event.value
                        )
                    elseif params.max then
                        value = math.max(value, event.value)
                    else
                        value = value + event.value
                    end
                end
            end
        end
    end
    local id_list = main.itemlist.event:get(event_name)
    if id_list and area_id and main.character:get('droplist', area_id)
        and not params.notDrop then
        check_params.priority = 'droplist'
        for i = 1, #id_list do
            local id = id_list[i]
            local info = main.inventory.getDrop(id)
            local item = main.itemlist:get(id)
            local event = item and item.events[event_name]
            if info and item then
                check_params.id = item.id
                check_params.info = info
                if craft:check(check_params) then
                    if event.slot and params.max then
                        slot_list[event.slot] = math.max(
                            slot_list[event.slot] or 0,
                            event.value
                        )
                    elseif params.max then
                        value = math.max(value, event.value)
                    else
                        value = value + event.value
                    end
                end
            end
        end
    end
    if table.count2(slot_list) > 0 then
        value = 0
        for slot, slot_value in pairs(slot_list) do
            value = value + slot_value
        end
    end
    if params.limit then
        value = math.min(value, params.limit)
    end
    return value
end

function craft.getValue(self, params)
    local value = 0
    local item = main.itemlist:get(params.id)
    local event = params.event
        or params.eventName and item and item.events[params.eventName]
    if craft:check({id = item.id, event = event, notDrop = params.notDrop}) then
        value = event.value
    end
    return value
end

function craft.getEventDepreciation(self, item, event, event_name, mult,
    is_drop)
    local depreciation = event.depreciation * mult
    if event_name == 'onehourpassed' and item.tagTable.fridge_related then
        local fridge_bonus = main.calculate:get('fridgeBonus')
        if is_drop then
            local fridge_bonus_drop = main.calculate:get('fridgeBonusDrop')
            if fridge_bonus_drop ~= 0 then
                fridge_bonus = math.max(fridge_bonus, fridge_bonus_drop)
            end
        end
        depreciation = depreciation / (1 + fridge_bonus)
    end
    if event.isPerkEffect then
        local durability = main.calculate:getItemValueAll(
            item,
            'craftItemDurability'
        )
        durability = math2.limit(durability, -1, 0.95)
        depreciation = depreciation * (1 - durability)
    end
    return depreciation
end

function craft.getCraftTime(self, params)
    local item = main.itemlist:get(params.id or params.itemId)
    local event_name = params.eventName
    local event = params[1] or params.event
        or event_name and item and item.events[event_name]
    local iterations = params.iterations or 1
    local time = (event and event.spendTime or 8) * 60
    if event_name and table.indexOf({'craft', 'craft1', 'craft2'}, event_name)
        or event and event.isCraft then
        time = time / (1 + main.calculate:getValueAll('craftDuration', 0))
    end
    if event and event.give and event.give[1][1] == 'fireplace' then
        local time_mult = 1 + main.calculate:getValueAll('lightFireTime', 0)
        time = time * time_mult
        print('> time_mult', time_mult)
    end
    local total_time = time * iterations
    if not params.ignoreSpeedMult then
        local speed_list = {
            {4, 0.8},
            {9, 0.7},
            {14, 0.5},
            {19, 0.4},
            {49, 0.3},
            {99, 0.2},
            {199, 0.1}
        }
        local speed_time = time * math.min(speed_list[1][1], iterations)
        for i = 1, #speed_list do
            local speed = speed_list[i]
            local speed_next = speed_list[i + 1]
            if iterations > speed[1] then
                local count = iterations - speed[1]
                if speed_next and iterations > speed_next[1] then
                    count = speed_next[1] - speed[1]
                end
                speed_time = speed_time + time * count * speed[2]
            else
                break
            end
        end
        total_time = speed_time
    end
    local iteration_time = math.round(total_time / iterations)
    if iterations > 1 and iteration_time < 100 then
        iteration_time = 100
        total_time = iteration_time * iterations
    end
    return total_time, iteration_time
end

function craft.getEventName(self, params)
    local item = main.itemlist:get(params.id or params.itemId)
    local event_name = params.eventName or params.eventId
    local event = params[1] or params.event
        or event_name and item and item.events[event_name]
        or {}
    local mult = (params.mult or 1) * (params.iterations or 1)
    local name = event.name
        or event_name and strings[event_name]
        or strings.events.create
    if event_name == 'item_drop' then
        name = strings.buttons.drop
    elseif event_name == 'item_pickup' then
        name = strings.buttons.pickup
    elseif event_name == 'item_wear' then
        name = table.eq2(item.tagList, {'transport', 'light'})
            and strings.buttons.use
            or strings.buttons.wear
    elseif event_name == 'item_takeoff' then
        name = strings.buttons.notWear
    elseif event_name == 'item_talk' then
        name = strings.events.talk
    elseif event_name == 'item_read' then
        local read_note = item.events.readNote
        name = read_note and read_note.name or strings.events.read
    elseif event_name == 'item_favorite' then
        name = strings.fasten
    end
    if name and event and event.depreciation then
        local percent = math.round(math.abs(event.depreciation * mult))
        if event_name == 'repair' then
            if event.depreciation < 0 then
                name = name .. ' +' .. percent .. '%'
            end
        elseif event_name == 'craft' then
            if event.depreciation > 0 then
                name = name .. ' +' .. percent .. '%'
            end
        end
    end
    return name
end

function craft.getData(self, params)
    local item = main.itemlist:get(params.id or params.itemId)
    local event = params[1] or params.event
        or params.eventName and item and item.events[params.eventName]
        or {}
    local area_id = main.cache:get('area', 'id')
    local mult = (params.mult or 1) * (params.iterations or 1)
    local give_list = {}
    local need_list = {}
    local tool_list = {}
    if event.quantity and item then
        local count = main.inventory:getItemTagCount({
            id = item.id,
            isAll = true
        })
        local quantity = math.abs(event.quantity) * mult
    end
    if event.need then
        for i = 1, #event.need do
            local need = event.need[i]
            local limit = need[2] * mult
            local count = main.inventory:getItemTagCount({
                id = need[1],
                isAll = true
            })
            if need[3] then
                need_list[#need_list + 1] = {
                    need[1],
                    limit,
                    need[3],
                    countAll = count,
                    isInvert = need.isInvert
                }
            else
                tool_list[#tool_list + 1] = {
                    need[1],
                    need[2],
                    countAll = count,
                    isView = need.isView,
                    isInvert = need.isInvert
                }
            end
        end
    end
    if event.isRandomItem then
        local random_item = main.itemlist:get('random_item')
        give_list[1] = {random_item.id, mult, isGive = true}
    elseif event.give then
        for i = 1, #event.give do
            local give = table.copy2(event.give[i])
            local min_value, max_value = helper.getGiveQuantity(
                event,
                give,
                mult
            )
            if give.chance then
                give[2] = {0, max_value}
            elseif min_value == max_value then
                give[2] = min_value
            else
                give[2] = {min_value, max_value}
            end
            give.isGive = true
            give_list[#give_list + 1] = give
        end
    end
    local item_give = table.copy2(give_list and give_list[1])
    local need_all = table.combine2({}, need_list, tool_list)
    local description = item_give and main.itemlist:getDescription({
        id = item_give[1],
        notInfo = true,
        notWeight = true,
        notDescription = params.notDescription
    })
    local stat_list = {}
    if event.character then
        for i = 1, #state_list do
            local state = state_list[i]
            local state_value = event.character[state]
            if state_value then
                stat_list[#stat_list + 1] = {state, state_value}
            end
        end
    end
    local data = {
        need = need_list,
        needTool = tool_list,
        give = give_list,
        itemGive = item_give,
        mult = mult,
        needAll = need_all,
        stateList = stat_list,
        character = event.character
    }
    if event.groupId then
        data.list = main.receipt:getGroupList(event.groupId)
    end
    data.name = event.name
    if description then
        data.name = description.name
        data.text = description.text
    end
    if event.exp and (not event.expLimitLevel
        or main.level:getHeroValue('level') < event.expLimitLevel) then
        data.exp = main.level:getExp({event = event}) * mult
        data.expText = strings.events.exp .. ': +' .. data.exp
        if main.level.boost:check() then
            data.expText = data.expText .. ' (200%)'
        end
    end
    if event.level then
        data.warning = strings.needLevel .. ':'
    end
    data.eventName = self:getEventName(params)
    data.iterationMax = self:getIterationMax({event})
    data.diseaseList = {}
    if event.diseaseList then
        for i = 1, #event.diseaseList do
            local disease_def = event.diseaseList[i]
            local disease = main.disease:get(disease_def[1])
            local disease_data = table.copy2(disease_def)
            local chance = disease_def[2]
            if main.calculate:checkImmunityDisease(disease.id) then
                chance = 0
            end
            disease_data.text = disease.name .. ' '
                .. (disease_def.showChance
                    and math.round(chance * 100) .. '%'
                    or '')
            data.diseaseList[#data.diseaseList + 1] = disease_data
        end
    end
    if event.addiction then
        local addiction = main.disease:getAddictionObj(event.addiction[1])
        local disease = addiction and main.disease:get(addiction[2])
        local disease_obj = disease
            and main.character:getObj('disease', disease.id)
        local limit = addiction and addiction.limit
        local addiction_value = main.disease:getAddictionValue(
            event.addiction[1]
        ) or 0
        addiction_value = addiction_value + event.addiction[2]
        local chance = 0
        if disease_obj then
            chance = 1
        elseif disease and limit and addiction_value >= limit[1] then
            chance = addiction.chance
                + (addiction_value - limit[1]) / (limit[2] - limit[1])
            chance = math.min(chance, 1)
        end
        if main.calculate:checkImmunityDisease(disease.id) then
            chance = 0
        end
        if chance > 0 then
            data.diseaseList[#data.diseaseList + 1] = {
                disease.id,
                chance,
                text = disease.name .. ' ' .. math.round(chance * 100) .. '%'
            }
        end
    end
    if #need_all > 0 then
        local text_list = {}
        for i = 1, #need_all do
            local need = need_all[i]
            local count = main.inventory:getItemTagCount({
                id = need[1],
                limit = need[2],
                isAll = true,
                onlyInventory = event.notDrop
            })
            local tag_name = main.itemlist:getTagName(need[1])
            local mark = count < need[2] and ' ✗' or '✓'
            text_list[#text_list + 1] = mark .. ' ' .. tag_name .. ' '
                .. count .. '/' .. need[2]
        end
        data.needText = table.concat(text_list, '\n')
    end
    if give_list and #give_list > 0 then
        local text_list = {}
        for i = 1, #give_list do
            local give = give_list[i]
            local give_name = main.itemlist:get(give[1], 'name') or give[1]
            local give_count = type(give[2]) == 'table' and give[2][1]
                or give[2]
            text_list[#text_list + 1] = ' - ' .. give_name .. ' x'
                .. give_count
        end
        data.giveText = table.concat(text_list, '\n')
    end
    data.isMult = event.count and true or false
    data.needLevel = event.level
    data.pointReceipt = event.getCost and event:getCost()
    data.craftTime = self:getCraftTime(params)
    return data
end

function craft.getDataResponse(self, params)
    local data = {}
    local response = params.response
    if response.exp then
        data.expText = ' - ' .. strings.events.exp .. ': +' .. response.exp
    end
    if response.character and not params.notStates then
        local text_list = {}
        for i = 1, #state_list do
            local state = state_list[i]
            local state_value = response.character[state]
            if state_value then
                text_list[#text_list + 1] = ' - ' .. (strings[state] or state)
                    .. ': ' .. converter.numberToSign(state_value)
            end
        end
        data.stateText = table.concat(text_list, '\n')
    end
    if response.need and #response.need > 0 and not params.notStates then
        local text_list = {}
        for i = 1, #response.need do
            local need = response.need[i]
            local need_item = main.itemlist:get(need[1])
            local quantity = need[2]
            text_list[#text_list + 1] = ' - ' .. need_item.name .. ' x'
                .. quantity
        end
        data.needText = strings.spend .. ':\n' .. table.concat(text_list, '\n')
    end
    if response.give and #response.give > 0 and not params.notItems then
        local text_list = {}
        for i = 1, #response.give do
            local give = response.give[i]
            local give_item = main.itemlist:get(give[1])
            local quantity = give[2]
            text_list[#text_list + 1] = ' - ' .. give_item.name .. ' x'
                .. quantity
        end
        data.giveText = strings.geted .. '\n' .. table.concat(text_list, '\n')
    end
    if response.diseaseList and #response.diseaseList > 0
        and not params.notDiseases then
        local text_list = {}
        for i = 1, #response.diseaseList do
            local disease = main.disease:get(response.diseaseList[i])
            if disease then
                text_list[#text_list + 1] = ' - ' .. disease.name
            end
        end
        data.diseaseText = strings.disease .. ':\n'
            .. table.concat(text_list, '\n')
    end
    local text_list = {}
    text_list[#text_list + 1] = data.expText
    text_list[#text_list + 1] = data.needText
    text_list[#text_list + 1] = data.stateText
    text_list[#text_list + 1] = data.diseaseText
    text_list[#text_list + 1] = data.giveText
    if #text_list > 0 then
        data.text = table.concat(text_list, '\n')
    end
    return data
end

function craft.readNote(self, params)
    local item = params.itemObj
        or main.itemlist:get(params.id or params.itemId)
    local read_note = item.events and item.events.readNote
    if read_note and read_note.showImage then
        main.interface:open({
            id = 'quest_image',
            event = read_note,
            actionClose = function()
                main.craft:run({event = read_note})
                main.quest:verifyQuestAll()
            end
        })
    elseif item.readText then
        main.interface:open({
            id = 'message',
            title = item.name,
            text = item.readText,
            actionConfirm = function()
                main.craft:run({event = read_note})
                main.quest:verifyQuestAll()
            end
        })
    end
end

function craft.lightFire(self)
    local wood = main.itemlist:get('wood')
    local wood_need = main.config.game:get('woodForFire') or 5
    local wood_count = main.inventory.getItemCount(wood.id) or 0
    local wood_drop_count = main.inventory.getDropCount(wood.id) or 0
    wood_count = wood_count + wood_drop_count
    if wood_need > wood_count then
        local text = strings.events.need .. ': ' .. wood.name .. ' x'
            .. wood_need - wood_count
        main.animation:run({id = 'warning', text = text})
        return
    end
    local fire_depreciation = 0
    if main.inventory.getDrop('fireplace') then
        local event = {
            spendTime = 10,
            need = {{'wood', wood_need, true}},
            give = {{'fireplace', 1, fire_depreciation}}
        }
        event.name = strings.events.kindle
        main.craftMaster:start({event = event})
    else
        local source_list = main.inventory:getItemTagList({
            id = 'fire_source',
            onlyInventory = true,
            isAll = true
        }) or {}
        local event_list = {}
        for i = 1, #source_list do
            local source = source_list[i]
            local event = main.itemlist:get(source.id, 'events', 'craft')
            if event then
                event = table.copy3(event)
                event.give[1][3] = fire_depreciation
                event_list[#event_list + 1] = event
            end
        end
        event_list[#event_list + 1] = {
            name = strings.events.kindle,
            notBiome = {4},
            spendTime = 180,
            sound = 'firestarter',
            errorTextBiome = strings.notLoc.fire,
            errorTextWeather = strings.errorRain,
            needWeather = {{'rain_tag', isInvert = true}},
            need = {{'wood', wood_need, true}},
            give = {{'fireplace', 1, fire_depreciation}}
        }
        table.sort(event_list, function(a, b)
            return (a.spendTime or 8) > (b.spendTime or 8)
        end)
        main.interface:open({id = 'light_fire', eventList = event_list})
    end
end

function craft.fishing(self, tool_id, bait_id)
    local bait = main.itemlist:get(bait_id)
    if not tool_id or not bait then
        return
    end
    local fresh_fish = main.itemlist:get('fresh_fish')
    local caviar = main.itemlist:get('caviar')
    local date = main.calculate:get('date')
    local fish_chance = 0.5
    local caviar_chance = 0.05
    if tool_id == 'fishing_rod3' then
        fish_chance = 1
        caviar_chance = 0.1
    elseif date.hour > 4 and date.hour <= 7 then
        fish_chance = 1
    elseif date.hour > 7 and date.hour <= 12 then
        fish_chance = 0.5
    elseif date.hour > 12 and date.hour <= 17 then
        fish_chance = 0.25
    elseif date.hour > 17 and date.hour <= 21 then
        fish_chance = 1
    else
        fish_chance = 0.25
    end
    local fish_count = bait.fishCounter or 1
    local random_value = math.random(1000) / 1000
    local event = {
        name = strings.events.fishing,
        spendTime = 30,
        itemExplosion = true,
        need = {{bait_id, 1, true}, {tool_id, 1}}
    }
    if caviar_chance >= random_value then
        local bonus = 1
            + main.calculate:getItemValueAll(fresh_fish, 'findItemQuantity')
        local caviar_count = math.round(2 * bonus)
        event.give = {{caviar.id, {1, caviar_count}, 0}}
    elseif fish_chance >= random_value then
        local bonus = 1
            + main.calculate:getItemValueAll(fresh_fish, 'findItemQuantity')
        fish_count = math.round(fish_count * bonus)
        event.give = {{fresh_fish.id, {1, fish_count}, 0}}
    else
        function event.action()
            main.interface:open({
                id = 'message',
                title = strings.unluck,
                text = strings.fishing_fail
            })
        end
    end
    main.craftMaster:start({event = event})
end

return craft
