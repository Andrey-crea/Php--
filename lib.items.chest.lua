-- Recovered code lib.items.chest.lu + fix after decompilation
-- Lua 5.1.5
-- Day R Survival v694
local item_list = {}

-- Содержимое новогоднего подарка снеговика
local snowman_chest = {
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 1},
    {'mandarin', 3},
    {'mandarin', 3},
    {'mandarin', 3},
    {'mandarin', 5},
    {'mandarin', 5},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 1},
    {'olivier', 3},
    {'olivier', 3},
    {'olivier', 3},
    {'olivier', 3},
    {'olivier', 5},
    {'olivier', 5},
    {'candy_apple', 1},
    {'pie', 1},
    {'shawarma', 1},
    {'fish_pie', 1},
    {'bread', 1},
    {'apple', 1},
    {'potato', 10},
    {'jam', 1},
    {'condensed_milk', 1},
    {'honey', 1},
    {'pumpkin', 1},
    {'vodka', 1},
    {'champagne', 1},
    {'wine', 1},
    {'apple_brandy', 1},
    {'pm_ammo', 10},
    {'nagant_ammo', 10},
    {'tt_ammo', 10},
    {'ak74_ammo', 10},
    {'mosin_ammo', 10},
    {'flash_grenade', 1},
    {'f_1', 1},
    {'axe', 1},
    {'breakage', 1},
    {'shovel', 1},
    {'hacksaw', 1},
    {'instruments_kit', 1},
    {'pan', 1},
    {'lighter', 1},
    {'fishing_rod2', 1},
    {'cigar', 1},
    {'sigaretes', 10},
    {'bint', 10},
    {'medicine1', 1},
    {'medicine3', 1},
    {'medicine4', 1},
    {'medicine6', 1},
    {'medicine7', 1},
    {'medicine8', 1},
    {'medicine9', 1},
    {'batteryaaa', 1},
    {'tanning_solution', 3},
    {'soap', 3},
    {'capsule', 10},
    {'cement', 1},
    {'tape', 10},
    {'rubber_part', 1},
    {'cable', 1},
    {'sulfuric_acid', 1},
    {'electrodes', 1},
    {'gunpowder', 300},
    {'string', 10},
    {'provoloka', 10},
    {'nail', 10},
    {'paper', 10},
    {'rags2', 5},
    {'rope', 3},
    {'coal', 10},
    {'gasmask_filter', 1},
    {'gas', 5000},
    {'diesel', 10000}
}

-- Новогодний подарок снеговика
item_list[#item_list + 1] = {
    id = 'snowman_gift',
    name = strings.christmas_gift.name,
    imageFile = 'gift4',
    tagList = {'fire_related', 'not_package'},
    events = {
        craft = {
            name = strings.events.open,
            spendTime = 10,
            itemExplosion = true,
            isRandomItem = true,
            need = {{'snowman_gift', 1, true}},
            chest = snowman_chest
        }
    }
}

-- Новогодний подарок 2020
item_list[#item_list + 1] = {
    id = 'gift2020',
    name = strings.christmas_gift.name,
    imageFile = 'gift5',
    tagList = {'fire_related', 'not_package'},
    events = {
        craft = {
            name = strings.events.open,
            spendTime = 10,
            itemExplosion = true,
            isRandomItem = true,
            need = {{'gift2020', 1, true}},
            needState = {{'isOpenGift2020', 0}},
            setState = {{'isOpenGift2020', true}},
            diseaseList = {{'christmas_mood', 1}},
            give = {
                {'fishing_rod3', 1, 0},
                {'medicine1000', 1, 0},
                {'repair_kit_weapon', 10, 0},
                {'repair_kit_transport', 10, 0},
                {'cigar', 10, 0},
                {'mysterious_map', 1, 0}
            },
            action = function()
                main.animation:addItem({
                    title = strings.effect2,
                    text = strings.diseases.christmas_mood.name
                })
            end
        }
    }
}

-- Содержимое почтовой посылки
local post_package_chest = {
    itemExplosion = true,
    {'trapie', {10, 15}},
    {'condensed_milk', {2, 3}},
    {'marinated_vegetable', {1, 3}},
    {'crumbs', {10, 15}},
    {'wine', {1, 2}, chance = 0.3},
    {'vodka', {1, 2}, chance = 0.3},
    {'string', {20, 30}, chance = 0.6},
    {'ordinary_clothes', 1},
    {'rags2', {1, 2}},
    {'sigaretes', {10, 20}, chance = 0.4},
    {'schoolbook', {2, 4}},
    {'paper', {20, 30}},
    {'pan', 1},
    {'fishing_rod2', 1, chance = 0.3},
    {'lighter', 1, chance = 0.3}
}

-- Почтовая посылка
item_list[#item_list + 1] = {
    id = 'post_package',
    tagList = {'fire_related'},
    weight = 1000,
    events = {
        craft = {
            name = strings.events.open,
            spendTime = 10,
            need = {{'post_package', 1, true}},
            chest = post_package_chest,
            itemExplosion = true,
            isRandomItem = true
        }
    }
}

-- Содержимое заколоченного ящика
local closed_crate_chest = {
    itemExplosion = true,
    {'scrap_metal', {25, 50}},
    {'chainsaw', 1, chance = 0.25},
    {'trapie', {25, 50}},
    {'rags2', {5, 10}},
    {'wine', {1, 2}, chance = 0.5},
    {'vodka', {1, 3}},
    {'string', {30, 70}},
    {'auto_part', {3, 5}},
    {'moto_part', {3, 5}},
    {'bicycle_part', {3, 5}},
    {'cartridge_d4', {10, 20}},
    {'sulfur', {250, 500}},
    {'saltpeter', {250, 500}},
    {'rope', {3, 5}},
    {'nail', {30, 60}},
    {'soap', {1, 3}},
    {'sulfuric_acid', {1, 2}},
    {'tape', {10, 20}},
    {'tire', {2, 4}},
    {'salt', {15, 25}},
    {'sugar', {15, 25}},
    {'porridge_can', {3, 5}},
    {'beef_can', {3, 5}},
    {'instruments_kit', 1},
    {'instruments_kit_rust', 1},
    {'pan_rust', 1},
    {'pan', 1}
}

-- Заколоченный ящик
item_list[#item_list + 1] = {
    id = 'closed_crate',
    tagList = {'fire_related'},
    weight = 5000,
    events = {
        craft = {
            name = strings.events.open,
            spendTime = 20,
            need = {{'closed_crate', 1, true}, {'opener', 1}},
            give = {{'wood', 2, 0}, {'nail', {1, 10}, 0}},
            chest = closed_crate_chest,
            isRandomItem = true
        }
    }
}

-- Оружие из оружейного ящика по уровням героя
local weapon_list = {
    {
        level = 26,
        {'pps', 1},
        {'pps_broken', 1},
        {'tt_ammo', 30}
    },
    {
        level = 30,
        {'tt', 1},
        {'tt_broken', 1},
        {'ppsh', 1},
        {'ppsh_broken', 1}
    },
    {
        level = 43,
        {'mosin', 1},
        {'mosin_broken', 1},
        {'mosin_ammo', 30},
        {'aks74u', 1},
        {'aks74u_broken', 1},
        {'ak74_ammo', 30},
        {'f_1', 3}
    },
    {
        level = 53,
        {'f_1', 3},
        {'svt', 1},
        {'svt_broken', 1},
        {'rpk74', 1},
        {'rpk74_broken', 1},
        {'ak74_single', 1},
        {'ak74_broken', 1}
    },
    {
        level = 69,
        {'svd', 1},
        {'svd_broken', 1},
        {'dp', 1},
        {'dp_broken', 1}
    },
    {
        level = 81,
        {'pk', 1},
        {'pk_broken', 1},
        {'rpg7', 1},
        {'rpg7_ammo', 5}
    }
}

local function openWeaponCrate()
    local hero_level = main.level:getHeroValue('level') or 1
    local weapon_level = main.character:get('weaponLevel') or 26
    local max_level = math.max(hero_level, weapon_level)
    local list_index = 1
    for i = 1, #weapon_list do
        if max_level >= weapon_list[i].level then
            list_index = i or list_index
        end
    end
    main.character:edit('count_package', 1, '+')
    if not main.character:get('defaultValue', 'package') then
        main.character:edit({'defaultValue', 'package'}, math.random(1000))
    end
    local seed = main.character:get('defaultValue', 'package')
        + main.character:get('count_package')
    math.randomseed(seed)
    local level_list = list_index > 1
        and weapon_list[math.random(list_index)]
        or weapon_list[list_index]
    local weapon = level_list[math.random(#level_list)]
    main.inventory.add({id = weapon[1], quantity = weapon[2]})
    main.animation:addItem({weapon[1], weapon[2]})
    math.randomseed(os.time())
end

-- Оружейный ящик
item_list[#item_list + 1] = {
    id = 'weapon_crate',
    tagList = {'fire_related'},
    weight = 10000,
    events = {
        craft = {
            name = strings.events.open,
            spendTime = 20,
            need = {{'weapon_crate', 1, true}, {'opener', 1}},
            give = {{'wood', {3, 5}, 0}, {'nail', {1, 10}, 0}},
            giveString = strings.random_item,
            action = openWeaponCrate,
            isRandomItem = true
        }
    }
}

-- Индивидуальный рацион питания (ИРП)
item_list[#item_list + 1] = {
    id = 'irp',
    tagList = {'fire_related'},
    weight = 1500,
    events = {
        craft = {
            name = strings.events.open,
            spendTime = 10,
            need = {{'irp', 1, true}},
            give = {
                {'beef_can', 1, 0},
                {'porridge_can', 2, 0},
                {'crumbs', 3, 0},
                {'tea', 1, 0},
                {'sugar', 14, 0}
            }
        }
    }
}

-- Бустеры опыта на 1, 3 и 7 дней
local boost_days = {1, 3, 7}
for i = 1, #boost_days do
    item_list[#item_list + 1] = {
        id = 'xp_boost_' .. boost_days[i],
        singleDepreciation = true,
        tagList = {'fire_related', 'not_package'},
        imageFile = 'xp_boost_' .. boost_days[i],
        events = {}
    }
end

-- Пыльная книга
item_list[#item_list + 1] = {
    id = 'dusty_book',
    tagList = {'fire_related'},
    imageFile = 'book',
    weight = 1000,
    events = {
        eat = {
            name = strings.events.read,
            spendTime = 180,
            exp = 50,
            character = {energy = -25},
            quantity = -1
        }
    }
}

-- Кулинарный рецепт
item_list[#item_list + 1] = {
    id = 'cooking_recipe',
    tagList = {'fire_related', 'not_package'},
    imageFile = 'book_cookery',
    weight = 1000,
    events = {
        eat = {
            name = strings.events.read,
            spendTime = 30,
            exp = 25,
            character = {energy = -25},
            quantity = -1,
            isRandomCookingRecipe = true
        }
    }
}

-- Телевизор с рекламой
item_list[#item_list + 1] = {
    id = 'ad_tv',
    tagList = {'fire_related', 'decay_6m'},
    alwaysOnDrop = true,
    events = {
        craft = {
            name = strings.events.watchAD,
            spendTime = 1,
            action = function()
                main.ad.show()
            end
        }
    }
}

-- Содержимое премиум-тайников (номера 1-21, номера 5 нет)
local premium_list = {
    [13] = {
        {'champagne', 1, 0},
        {'respirator', 1, 0},
        {'bag1', 1, 0},
        {'tea', 1, 0},
        {'coffee', 1, 0},
        {'bottled_water', 5, 0},
        {'dryMeat', 5, 0},
        {'fire_matches', 5, 0},
        {'tape', 10, 0},
        {'string', 10, 0}
    },
    [2] = {
        {'wine', 1, 0},
        {'cigar', 1, 0},
        {'beef_can', 1, 0},
        {'potion_radiation', 1, 0},
        {'pm_ammo', 10, 0}
    },
    [1] = {
        {'apple_brandy', 1, 0},
        {'dusty_book', 1, 0},
        {'gasmask_filter', 1, 0},
        {'marinated_vegetable', 1, 0},
        {'cocktail_molotov', 1, 0}
    },
    [3] = {
        {'pepsicola', 5, 0},
        {'breakage', 1, 0},
        {'jam', 1, 0},
        {'alcohol', 1, 0},
        {'gunpowder', 300, 0}
    },
    [4] = {
        {'moonshine', 1, 0},
        {'condensed_milk', 1, 0},
        {'medicine3', 1, 0},
        {'string', 30, 0},
        {'tt_ammo', 10, 0}
    },
    [7] = {
        {'champagne', 1, 0},
        {'medicine7', 1, 0},
        {'medicine3', 1, 0},
        {'hacksaw', 1, 0},
        {'gas', 5000, 0}
    },
    [6] = {
        {'vodka', 1, 0},
        {'bottled_water', 10, 0},
        {'stewed_meat', 1, 0},
        {'tt', 1, 0},
        {'tt_ammo', 10, 0}
    },
    [8] = {
        {'whiskey', 1, 0},
        {'cigar', 1, 0},
        {'stewed_meat', 1, 0},
        {'mauser', 1, 0},
        {'tt_ammo', 10, 0}
    },
    [9] = {
        {'moonshine', 1, 0},
        {'potato', 50, 0},
        {'cable', 5, 0},
        {'batteryaaa', 3, 0},
        {'ak74_ammo', 10, 0}
    },
    [10] = {
        {'moonshine', 1, 0},
        {'sulfuric_acid', 5, 0},
        {'rubber_part', 5, 0},
        {'oil', 1000, 0},
        {'gas', 10000, 0}
    },
    [11] = {
        {'apple_brandy', 1, 0},
        {'honey', 1, 0},
        {'medicine8', 1, 0},
        {'cigar', 1, 0},
        {'mosin_ammo', 10, 0}
    },
    [12] = {
        {'vodka', 1, 0},
        {'beef_can', 5, 0},
        {'f_1', 1, 0},
        {'military_armor', 1, 0},
        {'tt_ammo', 10, 0}
    },
    [14] = {
        {'vodka', 1, 0},
        {'beef_can', 10, 0},
        {'sigaretes', 10, 0},
        {'diesel', 50000, 0},
        {'mosin_ammo', 20, 0}
    },
    [15] = {
        {'whiskey', 1, 0},
        {'dryMeat', 20, 0},
        {'ak74_ammo', 25, 0},
        {'steel', 500, 0},
        {'gas', 50000, 0}
    },
    [16] = {
        {'vodka', 1, 0},
        {'jam', 1, 0},
        {'batteryaaa', 3, 0},
        {'gunpowder', 500, 0},
        {'medicine9', 1, 0}
    },
    [17] = {
        {'moonshine', 1, 0},
        {'pilaf', 1, 0},
        {'ak74_ammo', 30, 0},
        {'tea', 5, 0},
        {'batteryaaa', 3, 0}
    },
    [18] = {
        {'wine', 1, 0},
        {'shashlik', 3, 0},
        {'cigar', 1, 0},
        {'ak74_ammo', 10, 0},
        {'medicine8', 1, 0}
    },
    [19] = {
        {'whiskey_XL', 1, 0},
        {'marinated_vegetable', 5, 0},
        {'sigaretes', 10, 0},
        {'diesel', 50000, 0},
        {'steel', 500, 0}
    },
    [20] = {
        {'moonshine', 1, 0},
        {'smoked_salo', 10, 0},
        {'potion_energy', 1, 0},
        {'diesel', 50000, 0},
        {'gasmask4', 1, 0}
    },
    [21] = {
        {'wine', 1, 0},
        {'flour', 10, 0},
        {'coffee', 1, 0},
        {'batteryaaa', 3, 0},
        {'diesel', 50000, 0}
    }
}

-- Премиум-тайники premium_chest1 ... premium_chest21
for i = 1, 21 do
    if premium_list[i] then
        item_list[#item_list + 1] = {
            id = 'premium_chest' .. i,
            template = 'premium_chest',
            events = {craft = {isNeedPremium = true, give = premium_list[i]}}
        }
    end
end

-- Премиум-письмо
item_list[#item_list + 1] = {
    id = 'premium_letter',
    isPremuimChestList = true,
    tagList = {'fire_related', 'quest_related'},
    name = strings.premium_letter.name,
    description = strings.premium_letter.description,
    events = {
        craft = {
            spendTime = 0,
            name = strings.premiumBonuses,
            action = function()
                main.interface:open('premium_info')
            end
        },
        craft2 = {
            spendTime = 0,
            name = strings.premium_chest,
            action = function()
                local x, y = main.location:getNearPremiumStashXY()
                if x and y then
                    main.interface:closeAll()
                    main.map:moveArrow({x = x, y = y})
                end
            end
        }
    }
}

-- Премиум-стартовый набор
item_list[#item_list + 1] = {
    id = 'premium_starter_set',
    tagList = {'fire_related', 'not_package'},
    name = strings.premium_title_list[3],
    description = strings.premium_text_list[4],
    imageFile = 'premium_chest',
    events = {
        craft = {
            spendTime = 0,
            name = strings.events.open,
            quantity = -1,
            itemExplosion = true,
            give = {
                {'ozk', 1, 0},
                {'haversack', 1, 0},
                {'breakage', 1, 0},
                {'pm', 1, 0},
                {'pm_ammo', 20, 0},
                {'lighter', 1, 0}
            }
        }
    }
}

-- Клетка с вороном
item_list[#item_list + 1] = {
    id = 'raven_cage',
    tagList = {'fire_related', 'not_package'},
    events = {
        craft = {
            spendTime = 0,
            quantity = -1,
            name = strings.events.open,
            isNeedPremium = true,
            premiumCategoryId = 'raven',
            addAlly = {{'raven', 1}},
            action = function()
                main.interface:closeAll()
                main.interface:open('ally')
            end
        }
    }
}

return item_list
