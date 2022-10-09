gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

util.no_globals()

local on = 0

util.data_mapper{
    state = function(state)
        on = state
    end,
}

function node.render()
    pp(on)
    if (on > 700) then
        pp("green")
        gl.clear(0, 1, 0, 1) -- green
    else
        pp("red")
        gl.clear(1, 0, 0, 1) -- red
    end
end
