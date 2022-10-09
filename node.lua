gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

util.no_globals()

local on = 0

util.data_mapper{
    state = function(state)
        on = tonumber(state)    'comes in as string!!!
    end,
}

function node.render()
    pp(on)
    if on > 700 then
        gl.clear(0, 1, 0, 1) -- green
    else
        gl.clear(1, 0, 0, 1) -- red
    end
end
