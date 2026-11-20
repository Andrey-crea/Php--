-- Recovered code lib.sound.lu + fix after decompilation
-- Lua 5.1.5
-- Day R Survival v694

local sound = main.class:new('sound')

sound.channelList = {}

function sound.preload(self, obj)
    if obj.path and not obj.file then
        obj.file = audio.loadSound(obj.path)
    end
end

function sound.init(self, params)
    if ANDROID and not TEST_BUILD then
        params.path = 'sound/android/' .. params.path .. '.ogg'
    else
        params.path = 'sound/ios/' .. params.path .. '.mp3'
    end
    self:_init(params)
end

function sound.initAll(self)
    self:init({id = 'rain', path = 'weather/rain'})
    self:init({id = 'heavy_rain', path = 'weather/heavy_rain'})
    self:init({id = 'blizzard', path = 'weather/blizzard'})
    self:init({id = 'dust', path = 'weather/dust'})
    self:init({id = 'radiation', path = 'bg/radiation'})
    self:init({id = 'city', path = 'bg/city'})
    self:init({id = 'swamp', path = 'bg/swamp'})
    self:init({id = 'forest', path = 'bg/forest'})
    self:init({id = 'mountain', path = 'bg/mountain'})
    self:init({id = 'fireplace', path = 'bg/fireplace'})
    self:init({id = 'walk_wasteland', path = 'move/walk_wasteland'})
    self:init({id = 'walk_city', path = 'move/walk_city'})
    self:init({id = 'walk_forest', path = 'move/walk_forest'})
    self:init({id = 'walk_water', path = 'move/walk_water'})
    self:init({id = 'bike', path = 'move/bike'})
    self:init({id = 'moto', path = 'move/moto'})
    self:init({id = 'auto', path = 'move/auto'})
    self:init({id = 'truck', path = 'move/truck'})
    self:init({id = 'bardak', path = 'move/bardak'})
    self:init({id = 't72_move', path = 'move/t72'})
    self:init({id = 'mi24_move', path = 'move/mi24'})
    self:init({id = 'belaz', path = 'move/belaz'})
    self:init({id = 'search', path = 'craft/search'})
    self:init({id = 'search_outside', path = 'craft/search_outside'})
    self:init({id = 'carbuild', path = 'craft/carbuild'})
    self:init({id = 'hacksaws', path = 'craft/hacksaws'})
    self:init({id = 'build', path = 'craft/build'})
    self:init({id = 'chemistry', path = 'craft/chemistry'})
    self:init({id = 'clotch', path = 'craft/clotch'})
    self:init({id = 'cookery', path = 'craft/cookery'})
    self:init({id = 'blacksmith', path = 'craft/blacksmith'})
    self:init({id = 'craft', path = 'craft/craft'})
    self:init({id = 'firewood', path = 'craft/firewood'})
    self:init({id = 'firestarter', path = 'craft/firestarter'})
    self:init({id = 'tablets', path = 'craft/tablets'})
    self:init({id = 'shovel', path = 'craft/shovel'})
    self:init({id = 'axe', path = 'craft/axe'})
    self:init({id = 'fist', path = 'craft/fist'})
    self:init({id = 'crowbar', path = 'craft/crowbar'})
    self:init({id = 'canister', path = 'craft/canister'})
    self:init({id = 'meat', path = 'craft/meat'})
    self:init({id = 'pockets', path = 'craft/pockets'})
    self:init({id = 'drink', path = 'craft/drink'})
    self:init({id = 'food', path = 'craft/food'})
    self:init({id = 'tear_out', path = 'craft/tear_out'})
    self:init({id = 'bad_food', path = 'craft/bad_food'})
    self:init({id = 'fail_repair', path = 'craft/fail_repair'})
    self:init({id = 'notes', path = 'craft/notes'})
    self:init({id = 'loot_take', path = 'craft/loot_take'})
    self:init({id = 'knife', path = 'weapon/knife'})
    self:init({id = 'assault_rifle', path = 'weapon/assault_rifle'})
    self:init({id = 'bite', path = 'weapon/bite'})
    self:init({id = 'claws', path = 'weapon/claws'})
    self:init({id = 'crossbow', path = 'weapon/crossbow'})
    self:init({id = 'craftgun', path = 'weapon/craftgun'})
    self:init({id = 'explosion', path = 'weapon/explosion'})
    self:init({id = 'grenade_throw', path = 'weapon/grenade_throw'})
    self:init({id = 'pistol', path = 'weapon/pistol'})
    self:init({id = 'revolver', path = 'weapon/revolver'})
    self:init({id = 'rifle', path = 'weapon/rifle'})
    self:init({id = 'rocket', path = 'weapon/rocket'})
    self:init({id = 'submachine_gun', path = 'weapon/submachine_gun'})
    self:init({id = 'toxic_attack', path = 'weapon/toxic_attack'})
    self:init({id = 'molotov', path = 'weapon/molotov'})
    self:init({id = 'shotgun', path = 'weapon/shotgun'})
    self:init({id = 'flamethrow', path = 'weapon/flamethrow'})
    self:init({id = 'fireball_fly', path = 'weapon/fireball_fly'})
    self:init({id = 'fireball_explosion', path = 'weapon/fireball_explosion'})
    self:init({id = 'lightning', path = 'weapon/lightning'})
    self:init({id = 'spell', path = 'weapon/spell'})
    self:init({id = 'spell_heal', path = 'weapon/spell_heal'})
    self:init({id = 'firework', path = 'weapon/firework'})
    self:init({id = 'firework_fly', path = 'weapon/firework_fly'})
    self:init({id = 'confetti', path = 'weapon/confetti'})
    self:init({id = 'axe_fly', path = 'weapon/axe_fly'})
    self:init({id = 'wolf_howl', path = 'weapon/wolf_howl'})
    self:init({id = 'miss', path = 'weapon/grenade_throw'})
    self:init({id = 'impact_body_1', path = 'weapon/impact_body_1'})
    self:init({id = 'impact_body_2', path = 'weapon/impact_body_2'})
    self:init({id = 'impact_body_3', path = 'weapon/impact_body_3'})
    self:init({id = 'battle_move', path = 'weapon/move'})
    self:init({id = 'meet_rat', path = 'meet_enemy/rat'})
    self:init({id = 'meet_wolf', path = 'meet_enemy/wolf'})
    self:init({id = 'meet_lynx', path = 'meet_enemy/lynx'})
    self:init({id = 'meet_1attack', path = 'meet_enemy/1attack'})
    self:init({id = 'meet_5attack', path = 'meet_enemy/5attack'})
    self:init({id = 'meet_bear', path = 'meet_enemy/bear'})
    self:init({id = 'meet_bee', path = 'meet_enemy/bee'})
    self:init({id = 'meet_boar', path = 'meet_enemy/boar'})
    self:init({id = 'meet_eagle', path = 'meet_enemy/eagle'})
    self:init({id = 'meet_queen', path = 'meet_enemy/queen'})
    self:init({id = 'meet_humans', path = 'meet_enemy/humans'})
    self:init({id = 'meet_monsters', path = 'meet_enemy/monsters'})
    self:init({id = 'meet_snake', path = 'meet_enemy/snake'})
    self:init({id = 'button_backpack', path = 'buttons/backpack'})
    self:init({id = 'button_menu', path = 'buttons/button_menu'})
    self:init({id = 'button_click', path = 'buttons/click'})
    self:init({id = 'button_coin', path = 'buttons/coin'})
    self:init({id = 'button_diary', path = 'buttons/diary'})
    self:init({id = 'button_interface', path = 'buttons/interface'})
    self:init({id = 'drop_all', path = 'buttons/drop_all'})
    self:init({id = 'take_all', path = 'buttons/take_all'})
    self:init({id = 'drop_1', path = 'buttons/drop_1'})
    self:init({id = 'take_1', path = 'buttons/take_1'})
    self:init({id = 'take_off', path = 'buttons/take_off'})
    self:init({id = 'put_on', path = 'buttons/put_on'})
    self:init({id = 'get_xp', path = 'misc/get_xp'})
    self:init({id = 'win_battle', path = 'misc/win_battle'})
    self:init({id = 'lost_battle ', path = 'misc/lost_battle '})
    self:init({id = 'toy', path = 'misc/toy'})
    self:init({id = 'toy_prize', path = 'misc/toyprize'})
    self:init({id = 'level_up', path = 'misc/lvl'})
    self:init({id = 'gift', path = 'misc/gift'})
    audio.setMaxVolume(0.9, {channel = 2})
    audio.setMaxVolume(0.8, {channel = 5})
end

function sound.getChannel(self, channel)
    return self.channelList and channel and self.channelList[channel]
end

function sound.getBgSound(self, area, biome)
    return biome and biome.sound
end

function sound.getFireplaceSound(self, area, biome)
    local fireplace = area and main.inventory.getDrop('fireplace')
    return fireplace and 'fireplace'
end

function sound.getMoveSound(self, area, biome)
    local sound_id
    if main.cache:get('go') or main.cache:get('isLastStep') then
        local transport = main.equipment:getObj('transport')
        if transport then
            sound_id = transport.sound_move
        elseif biome and biome.soundWalk then
            sound_id = biome.soundWalk
        end
    end
    return sound_id
end

function sound.getRadSound(self, area, biome)
    local sound_id
    local radiation = main.character:get('radiation') or 0
    local resist = main.calculate:get('radiationResist')
    local area_radiation = main.cache:get('radiation') or 0
    local volume = nil
    if area_radiation - resist > 0 then
        local ars_list = main.hard:getValue('arsList')
        local ars = ars_list and ars_list[1]
        if ars and radiation >= ars[2] - 25 then
            sound_id = 'radiation'
            if radiation >= ars[2] - 10 then
                volume = 1
            elseif radiation >= ars[2] - 15 then
                volume = 0.7
            elseif radiation >= ars[2] - 20 then
                volume = 0.5
            else
                volume = 0.2
            end
        end
    end
    return sound_id, volume
end

function sound.getWeatherSound(self)
    local weather = main.weather:getCurrentObj()
    return weather and weather.sound
end

function sound.getRunSoundList(self, area, biome)
    local list = {}
    local move_sound, fireplace_sound, bg_sound
    local rad_sound, rad_volume, weather_sound
    if main.setting:get('sound') == 1 and not main.game:checkPause() then
        move_sound = self:getMoveSound(area, biome)
        fireplace_sound = self:getFireplaceSound(area, biome)
        bg_sound = self:getBgSound(area, biome)
        rad_sound, rad_volume = self:getRadSound(area, biome)
        weather_sound = self:getWeatherSound()
    end
    list[#list + 1] = {2, move_sound}
    list[#list + 1] = {3, fireplace_sound}
    list[#list + 1] = {4, bg_sound}
    list[#list + 1] = {5, rad_sound, rad_volume}
    list[#list + 1] = {6, weather_sound}
    return list
end

function sound.run(self, params)
    local obj = params.obj or self:get(params.id)
    if not obj or main.setting:get('sound') == 0
        or main.cache:get('isAudioStop') then
        return
    end
    if not obj.file then
        self:preload(obj)
    end
    local duration = params.duration
    local volume = params.volume or 1
    local channel = params.channel or obj.channel
    local is_change = false
    if channel and audio.isChannelPlaying(channel)
        and self:getChannel(channel) ~= obj.id then
        is_change = true
    end
    if is_change then
        audio.stop(channel)
    end
    if params.durationMax and obj.file
        and audio.getDuration(obj.file) > params.durationMax then
        duration = params.durationMax
    end
    channel = audio.play(obj.file, {
        channel = channel,
        loops = params.loops,
        fadein = params.fadein,
        duration = duration,
        onComplete = function()
            audio.setVolume(volume, {channel = channel})
        end
    })
    self.channelList[channel] = obj.id
end

function sound.stop(self, params)
    local channel = params.channel
    local time = params.time
    local sound_id = self:getChannel(channel)
    local volume = params.volume or 1
    self.channelList[channel] = nil
    if time then
        audio.fadeOut({channel = channel, time = time})
        timer.performWithDelay(time + 50, function()
            audio.setVolume(volume, {channel = channel})
        end)
    else
        audio.stop(channel)
        audio.setVolume(volume, {channel = channel})
    end
end

function sound.tick(self)
    if main.cache:get('isAudioStop') then
        return
    end
    local area = main.cache:get('area')
    local biome = main.cache:get('biome')
    local list = self:getRunSoundList(area, biome)
    for i = 1, #list do
        local item = list[i]
        local channel = item[1]
        local sound_id = item[2]
        if item[3] and item[3] ~= audio.getVolume({channel = channel}) then
            audio.setVolume(item[3], {channel = channel})
        end
        if self:getChannel(channel) ~= sound_id then
            self:stop({
                channel = channel,
                time = not sound_id and 500,
                volume = item[3]
            })
            if sound_id then
                self:run({
                    id = sound_id,
                    channel = channel,
                    fadein = 500,
                    loops = -1,
                    volume = item[3]
                })
            end
        end
    end
end

function sound.audioClearAll(self)
    for _, obj in pairs(self.table) do
        if obj.file then
            audio.dispose(obj.file)
            obj.file = nil
        end
    end
    for _, obj in pairs(main.music.table) do
        if obj.file then
            audio.dispose(obj.file)
            obj.file = nil
        end
    end
end

function sound.stopAll(self)
    for i = 2, 16 do
        local sound_id = self:getChannel(i)
        if sound_id then
            self:stop({channel = i})
        end
    end
end

function sound.audioStopAll(self)
    for i = 1, audio.totalChannels do
        if audio.isChannelActive(i) then
            audio.stop(i)
        end
    end
end

return sound
