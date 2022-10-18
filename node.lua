gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

-- util.no_globals()

local on = 0
local active = false
local video_one
local video_two

local playlist, video

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
    print("new playlist")
    pp(playlist)

    video_one = resource.open_file(playlist[1].asset_name)
    video_two = resource.open_file(playlist[2].asset_name)

    if video and video:state() == "paused" then
        video:dispose()
        video = nil
    end
end)

function node.render()
    gl.clear(0, 0, 0, 1)

    if not video then
        video = resource.load_video{
            file = video_one:copy(),
            paused = true,
            audio = true,
            raw = true,
        }
        video:start()
    end
    
    pp(video:state())

    if video then
        local state, w, h = video:state()
        if state == "loaded" then
            local x1, y1, x2, y2 = util.scale_into(NATIVE_WIDTH, NATIVE_HEIGHT, w, h)
            video:place(x1, y1, x2, y2):layer(2)
        elseif state == "finished" or state == "error" then
            video:dispose()
            video = nil
        end
    end
end
