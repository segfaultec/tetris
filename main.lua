local push = require "lib.push"
local Timer = require "lib.hump.timer"

game = nil

function love.load()
    require "constants"
    require "utils"
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

    game = Game:new()
    game:init()

    game2 = Game:new()
    game2:init()
    game2.state.id = 5

    Timer.every(1/TICKRATE, function() game:tick() end)

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.update(dt)
    Timer.update(dt)
    game:tick()
end

function love.draw()
    push:start()

    lg.setBackgroundColor(0,0,0,1)
    lg.setFont(Default_font)

    lg.push("all") -- Start board

    lg.setColor(GRAY_DARK)
    lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)

    lg.setColor(GRAY)
    lg.rectangle("fill", TETRIS_BOARD_X, TETRIS_BOARD_Y, TETRIS_BOARD_W, TETRIS_BOARD_H)

    lg.setColor(BLACK)
    lg.rectangle("line", TETRIS_BOARD_X, TETRIS_BOARD_Y, TETRIS_BOARD_W+1, TETRIS_BOARD_H+1)

    lg.pop() -- End board

    lg.push("all") -- Start blocks
    
    lg.translate(TETRIS_BOARD_X, TETRIS_BOARD_Y)

    game:draw()

    lg.pop() -- End blocks

    lg.push() -- Start debug draw
    lg.setColor(WHITE)
    lg.print(string.format("%d %d", game.state.id, game.state.rot),10,10)
    lg.pop() -- End debug draw

    push:finish()
end