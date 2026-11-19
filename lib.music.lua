-- Recovered code lib.music.lu + fix after decompilation
-- Lua 5.1.5
-- Day R Survival v694

local music = main.class:new('music')
local helper = {}

music.playlist = main.class:new('playlist')
music.server = {table = {}}

function music.initAll(self)
    self:init({id = 'history', pathFile = 'music/history.mp3'})
    self:init({id = 'fate', pathFile = 'music/fate.mp3'})
    self:init({id = 'endless', pathFile = 'music/endless.mp3'})
    self:init({id = 'tavern', addressFile = 'music/tavern.mp3'})
    self:init({id = 'halloween', addressFile = 'music/halloween.mp3'})
    self:init({id = 'battle', addressFile = 'music/battle.mp3'})
    self:init({id = 'camp', addressFile = 'music/camp.mp3'})
    self:init({id = 'travel', addressFile = 'music/travel.mp3'})
    self:init({id = 'fable', addressFile = 'music/fable.mp3'})
    self:init({id = 'forest', addressFile = 'music/forest.mp3'})
    self:init({id = 'opening', addressFile = 'music/opening.mp3'})
    self:init({id = 'travel_new', addressFile = 'music/travel_new.mp3'})
    self:init({id = 'new_year', addressFile = 'music/new_year.mp3'})
    self:init({id = 'xmas', addressFile = 'music/xmas.mp3'})
    self:init({id = 'xmas_night', addressFile = 'music/xmas_night.mp3'})
    for i = 1, 8 do
        audio.reserveChannels(i)
    end
    audio.setMaxVolume(0.9, {channel = 1})
    self.playlist:initAll()
end

function music.init(self, params)
    if params.addressFile then
        params.pathFile = params.addressFile
    end
    self:_init(params)
end

function music.preload(self, obj)
    if not obj.file and obj.addressFile then
        obj.file = audio.loadStream(obj.pathFile, system.CachesDirectory)
    elseif not obj.file and obj.pathFile then
        obj.file = audio.loadStream(obj.pathFile)
    end
end

function music.server.check(self, obj)
    local result = false
    for i = 1, #self.table do
        local item = self.table[i]
        if obj.addressFile == item.addressFile then
            result = true
            break
        end
    end
    return result
end

function music.server.add(self, obj)
    if not self:check(obj) then
        table.insert(self.table, obj)
    end
    if #self.table > 0 and not self.isLoading then
        self:load()
    end
end

function music.server.load(self)
    self.isLoading = true
    local obj = self.table[1]
    table.remove(self.table, 1)
    local listener = function(event)
        self.isLoading = false
        if #self.table > 0 then
            self:load()
        end
    end
    network.download(
        REMOTE_RESOURCES_PATH .. obj.addressFile,
        'GET',
        listener,
        obj.pathFile,
        system.CachesDirectory
    )
end

function music.verifyAll(self)
    local list = self.table
    for _, obj in pairs(list) do
        if not obj.file and obj.addressFile
            and not main.file:check(obj.pathFile, system.CachesDirectory) then
            self.server:add(obj)
        end
    end
end

function music.playlist.checkAccess(self, params)
    local result = false
    local obj = params.obj or self:get(params.id)
    for i = 1, #obj.musicList do
        local music_id = obj.musicList[i]
        local music_obj = music:get(music_id)
        if music_obj.file or music:checkAccess({id = music_id}) then
            result = true
            break
        end
    end
    return result
end

function music.playlist.initAll(self)
    self:init({
        id = 'default',
        musicList = {
            'history',
            'fate',
            'travel',
            'camp',
            'endless',
            'fable',
            'forest',
            'opening',
            'travel_new'
        }
    })
    self:init({id = 'battle', musicList = {'battle'}})
    self:init({id = 'halloween', musicList = {'halloween'}})
    self:init({id = 'new_year', musicList = {'new_year', 'xmas', 'xmas_night'}})
    self:init({id = 'tavern', musicList = {'tavern'}})
end

function music.getCurrentId(self)
    return self.musicId
end

function music.getCurrentPlaylist(self)
    local playlist_id = 'default'
    local area = main.cache:get('area')
    if main.battle:get('enemy')
        and music.playlist:checkAccess({id = 'battle'}) then
        playlist_id = 'battle'
    elseif area and area.isPortal
        and music.playlist:checkAccess({id = 'tavern'}) then
        playlist_id = 'tavern'
    elseif main.halloween:checkShadow()
        and music.playlist:checkAccess({id = 'halloween'}) then
        playlist_id = 'halloween'
    elseif (main.interface:getObj('new_year')
            or main.interface:getObj('bar_npc'))
        and music.playlist:checkAccess({id = 'halloween'}) then
        playlist_id = 'new_year'
    end
    return self.playlist:get(playlist_id)
end

function music.checkAccess(self, params)
    local result = true
    local obj = params.obj or self:get(params.id)
    if obj.addressFile and not obj.file
        and not main.file:check(obj.addressFile, system.CachesDirectory) then
        result = false
    end
    return result
end

function music.run(self, params)
    local obj = params.obj or self:get(params.id)
    local channel = 1
    if not obj or main.setting:get('music') == 0
        or main.cache:get('isAudioStop') then
        return
    end
    if not obj.file then
        self:preload(obj)
    end
    self.isComplete = false
    local is_change = false
    if audio.isChannelPlaying(channel)
        and self:getCurrentId() ~= obj.id then
        is_change = true
    end
    if is_change then
        audio.rewind({channel = channel})
        audio.stop(channel)
    end
    audio.setVolume(1, {channel = channel})
    self.musicId = obj.id
    audio.play(obj.file, {
        channel = channel,
        loops = 0,
        fadein = 1500,
        onComplete = function()
            self.isComplete = true
        end
    })
end

function music.stop(self, params)
    params = params or {}
    local channel = 1
    local current_id = self:getCurrentId()
    local obj = self:get(current_id)
    self.musicId = nil
    self.isComplete = false
    if audio.isChannelPlaying(channel) then
        audio.rewind({channel = channel})
        audio.stop(channel)
        if obj and obj.file then
            audio.dispose(obj.file)
            obj.file = nil
        end
    end
end

function music.fadeOut(self, params)
    self.isStop = true
    local channel = 1
    audio.fadeOut({channel = channel, time = params.time})
    timer.performWithDelay(params.time + 30, function()
        self.isStop = false
        audio.rewind({channel = channel})
        audio.stop(channel)
        self.isComplete = true
    end)
end

function helper.getMusicNewId(music_list, exclude_id)
    local new_id
    local list = table.copy2(music_list)
    local index = exclude_id and table.indexOf(list, exclude_id)
    if index then
        table.remove(list, index)
    end
    local order = table.random2(#list)
    for i = 1, #order do
        local list_index = order[i]
        local music_id = list[list_index]
        if music:checkAccess({id = music_id}) then
            new_id = music_id
            break
        end
    end
    return new_id
end

function music.tick10(self)
    local playlist = self:getCurrentPlaylist()
    local music_list = playlist and table.copy2(playlist.musicList)
    local current_id = self:getCurrentId()
    if main.setting:get('music') == 0 then
        self:stop()
    elseif self.isComplete then
        local new_id = helper.getMusicNewId(music_list, current_id)
            or current_id
        if new_id then
            self:run({id = new_id})
        end
    elseif current_id and not table.indexOf(music_list, current_id)
        and not self.isStop then
        self:fadeOut({time = 2000})
    elseif not current_id and music_list then
        local new_id = helper.getMusicNewId(music_list)
        self:run({id = new_id})
    end
end

return music
