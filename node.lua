gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

util.no_globals()

local on = 0

local video_one
local video_two

util.data_mapper{
    state = function(state)
        on = tonumber(state) -- comes in as string!!!
    end,
}

util.json_watch("config.json", function(config)
    if video_one then
        video_one:dispose()
    end
    if video_two then
        video_two:dispose()
    end

    video_one = resource.load_video{
        file = config.video1.asset_name,
        looped = true,
    }
    video_two = resource.load_video{
        file = config.video2.asset_name,
        looped = true,
    }
end)

function node.render()
    pp(on)
    if on > 700 then
        video_one:draw(0, 0, WIDTH, HEIGHT)
        -- gl.clear(0, 1, 0, 1) -- green
    else
        video_two:draw(0, 0, WIDTH, HEIGHT)
        -- gl.clear(1, 0, 0, 1) -- red
    end
end
