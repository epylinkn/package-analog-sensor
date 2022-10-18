gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

util.no_globals()

local on = 0

local playlist, video, current_video_idx

util.data_mapper{
    state = function(state)
        on = tonumber(state) -- comes in as string!!!
    end,
}

util.json_watch("config.json", function(config)
    playlist = {}

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
    pp(playlisit)
end)

function loop_intro()
    if video then
        video:dispose()
    end
    video = util.videoplayer(playlist[1], {loop=true})
end

function play_once()
    if video then
        video:dispose()
    end
    video = util.videoplayer(playlist[2], {loop=false})
end

function node.render()
    pp(on)

    if not video or not video:next() then
        loop_intro()
    end

    if on > 700 then
        play_once()
    end

    util.draw_correct(video, 0, 0, WIDTH, HEIGHT)
end
