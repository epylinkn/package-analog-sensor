gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

-- util.no_globals()

local on = 0

local playlist, video, current_video_idx

util.data_mapper{
    state = function(state)
        on = tonumber(state) -- comes in as string!!!
    end,
}

util.json_watch("config.json", function(config)
    playlist = {}

    pp(config)
    for _, item in ipairs(config.playlist) do
        if item.duration > 0 then
            local format = item.file.metadata and item.file.metadata.format
            local duration = item.duration
            playlist[#playlist+1] = {
                duration = duration,
                format = format,
                asset_name = item.file.asset_name,
                type = item.file.type,
            }
        end
    end
    current_video_idx = 0
    print("new playlist")
    pp(playlist)
end)

function loop_intro()
    if video then
        video:dispose()
    end
    video = resource.load_video{
        file = playlist[1].asset_name,
        audio = true,
        looped = true,
    }
end

function play_once()
    if video then
        video:dispose()
    end
    video = resource.load_video{
        file = playlist[2].asset_name,
        audio = true,
        looped = false,
    }
end

function node.render()
    pp(on)
    pp(video)
    if not video or not video:next() then
        loop_intro()
    end

    if on > 700 then
        play_once()
    end

    video:draw(0, 0, WIDTH, HEIGHT)
end
