local push = require "lib.push"
local Timer = require "lib.hump.timer"

game = nil

function love.load()
    require "constants"
    require "utils"
    require "images"
    require "Game"

    lw.setTitle("Tetris")
    lg.setDefaultFilter("nearest", "nearest", 0)
    lg.setLineStyle("rough")

    local push_opts = {
        fullscreen = false,
        resizable = true,
        pixelperfect = true
    }

    local displayIndex = 1
    local initialWindowRatio = .9

    local desktopW, desktopH = lw.getDesktopDimensions(displayIndex)
    local windowWidth, windowHeight = desktopW*initialWindowRatio, desktopH*initialWindowRatio

    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, push_opts);
    push:setBorderColor(BLACK)

    lw.setPosition(desktopW / 2 - windowWidth / 2, desktopH / 2 - windowHeight / 2, displayIndex)

    Default_font = lg.newFont("fonts/NESCyrillic.ttf", 16)

    game = construct(Game)
    game:init()

    Timer.every(1/TICKRATE, fixedTick)

end

function love.resize(w, h)
    push:resize(w, h)
end

repeat_keys = {}

function love.keypressed(key)

    if REPEAT_KEYS[key] then
        repeat_keys[key] = 0
    end

    game:keypressed(key)
end

function fixedTick()

    for key in pairs(repeat_keys) do
        repeat_keys[key] = repeat_keys[key] + 1

        local hold = repeat_keys[key] - F_REPEAT_DELAY
        if hold >= 0 and hold % F_REPEAT_RATE == 0 then

            if repeat_keys[REPEAT_KEYS_CLASHES[key]] == nil then
                game:keypressed(key)
            end
        end
    end

    game:tick()
end

function love.keyreleased(key)

    repeat_keys[key] = nil

end

function love.update(dt)
    Timer.update(dt)
    game:tick()
end

function love.draw()
    push:start()

    lg.setBackgroundColor(0,0,0,1)
    lg.setFont(Default_font)

    game:draw()

    local o = 100
    for k in pairs(repeat_keys) do
        lg.print(string.format("%s %d", k, repeat_keys[k]), 10, o)

        o = o + 10
    end

    push:finish()
end