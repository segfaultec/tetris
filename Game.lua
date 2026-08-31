
require "Board"
require "RandomBag"
require "Anim"
local LevelMeter = require "LevelMeter"

local drawPiece = require "drawPiece"
local Scoreboard = require "Scoreboard"

---@class Game
---@field board Board
---@field bag RandomBag
---@field blocking_anim Anim | nil
---@field free_anims Anim[]
---@field animflags AnimFlags
---@field midclearlines number[] | nil
---@field scoreboard Scoreboard
---@field levelmeter LevelMeter
local Game = {
    cGravity = 30,
    cLockdelay = F_LOCKDELAY,
    cLockMoveLimit = LOCKMOVELIMIT,

    state = {
        x = 4,
        y = 4,
        id = 3,
        rot = 1,
    },

    hold = 0,
    canHold = true,

    debugPause = false,

    score = 0,
    lines = 0,
    startlevel = START_LEVEL,
    level = START_LEVEL,

    gameover = false
}

function Game:construct(o)
    setmetatable(o.state, {__index = self.state})

    o.board = construct(Board)
    o.board:empty()

    o.bag = construct(RandomBag)
    o.animflags = construct(AnimFlags)

    o.free_anims = {}

    o.scoreboard = construct(Scoreboard)
    o.levelmeter = construct(LevelMeter)

    o.level = o.startlevel
end

function Game:init()
    self:resetPlayer(self.bag:consume())

    self.score = 0
    self.scoreboard:init(self.score)

    self.levelmeter:init(0)
end

function Game:tick()

    if self.debugPause then return end
    if self.gameover then return end

    if self.blocking_anim == nil then

        -- No animation: regular game tick

        self:gravity()
    else

        -- Play the animation
        if self.blocking_anim:tick(self.animflags, self) then
            self.blocking_anim = nil
        end

    end

    for i=#self.free_anims,1,-1 do
        if self.free_anims[i]:tick(self.animflags, self) then
            table.remove(self.free_anims, i)
        end
    end

    self.scoreboard:tick()
    self.levelmeter:tick()

end

function Game:resetPlayer(newpid)
    self.state.x = 4
    self.state.y = 0
    self.state.id = newpid
    self.state.rot = 1

    if not self.board:isPieceValidSpot(self.state) then
        self.gameover = true
    end
end

function Game:getHarddropState()
    local oldstate = table.shallow_copy(self.state)
    local newstate = table.shallow_copy(self.state)
    while true do
        newstate.y = newstate.y + 1

        if self:tryMovePiece(oldstate, newstate) then
            oldstate.y = newstate.y
        else
            return oldstate
        end
    end
end

function Game:harddrop()
    local harddropstate = self:getHarddropState()

    if harddropstate.y > self.state.y then
        local anim = construct(Anim_Harddrop, {state = table.shallow_copy(harddropstate)})
        table.insert(self.free_anims, anim)
    end

    self.state = harddropstate

    self:placePiece()
end

function Game:placePiece()
    self.board:addPlayerPiece(self.state, 1)
    self:resetPlayer(self.bag:consume())

    self.canHold = true

    local clears = self.board:checkLineClears()
    if #clears > 0 then
        self.midclearlines = clears
        local anim = construct(Anim_Lineclear)
        anim.start_callback = function ()
            if self.midclearlines then
                self.board:clearLines(self.midclearlines)
            end
            self.midclearlines = nil
        end
        table.insert(self.free_anims, anim)

        self:addScore(BASE_LINE_SCORES[#clears])
        self:addClearedLines(#clears)
    end

end

function Game:addClearedLines(line_count)
    self.lines = self.lines + line_count
    if self.lines >= LEVEL_CLEAR_LINES then
        self.level = self.level + 1
        self.lines = 0
    end
    self.levelmeter:setFill(self.lines / LEVEL_CLEAR_LINES)
end

function Game:addScore(score)
    self.score = self.score + score
    self.scoreboard:setScore(self.score)
end

function Game:gravity()
    local newstate = table.shallow_copy(self.state)
    newstate.y = self.state.y + 1

    local grav = LV_GRAV[self.level]
    if grav == nil then grav = 1 end

    if self:tryMovePiece(self.state, newstate) then

        self.cLockdelay = F_LOCKDELAY
        
        if (self.cGravity == 0) then
            self.cGravity = grav

            -- Apply movedown
            self.state = newstate
        else
            self.cGravity = self.cGravity - 1
        end
    else
        self.cGravity = grav

        if (self.cLockdelay == 0) then
            self.cLockdelay = F_LOCKDELAY

            self:placePiece()
        else
            self.cLockdelay = self.cLockdelay - 1
        end
    end
end

flip = false

function Game:keypressed(key)

    local newstate = nil

    if key == "q" then
        newstate = table.shallow_copy(self.state)
        newstate.rot = math.wrap(self.state.rot - 1, 1, ROT_MAX)
    elseif key == "e" then
        newstate = table.shallow_copy(self.state)
        newstate.rot = math.wrap(self.state.rot + 1, 1, ROT_MAX)
    elseif key == "a" then
        newstate = table.shallow_copy(self.state)
        newstate.x = self.state.x - 1
    elseif key == "d" then
        newstate = table.shallow_copy(self.state)
        newstate.x = self.state.x + 1
    elseif key == "w" then
        self:harddrop()
    elseif key == "s" then
        newstate = table.shallow_copy(self.state)
        newstate.y = self.state.y + 1
        --self.cLockdelay = 0
    elseif self.canHold and key == "space" then

        local oldhold = self.hold
        self.hold = self.state.id
        if oldhold > 0 then
            self:resetPlayer(oldhold)
        else
            self:resetPlayer(self.bag:consume())
        end

        self.canHold = false

        return
    elseif key == "p" then
        self.debugPause = not self.debugPause
    elseif key == "o" then
        self.level = self.level + 1
        flip = not flip
    end

    if newstate ~= nil and self:tryMovePiece(self.state, newstate) then
        self.cLockdelay = F_LOCKDELAY
        self.state = newstate
    end
end

function Game:tryMovePiece(old_state, inout_new_state)

    if self.board:isPieceValidSpot(inout_new_state) then
        -- yippie!
        return true
    end

    if (old_state.rot == inout_new_state.rot) then
        -- Can only wall kick if we're rotating
        return false
    end

    local kick_list
    if inout_new_state.id == 1 then
        kick_list = KICKS_I
    else 
        kick_list = KICKS_JLSTZ
    end

    local rotstr = KICK_NOTATION[old_state.rot]..KICK_NOTATION[inout_new_state.rot]
    local tests = kick_list[rotstr]
    -- deliberate crash on test not found

    for _,test in ipairs(tests) do
        -- Y axis should be negated (should fix later)
        local x,y = test[1], -test[2]

        -- Try kick offset
        inout_new_state.x = inout_new_state.x + x
        inout_new_state.y = inout_new_state.y + y

        if self.board:isPieceValidSpot(inout_new_state) then
            return true
        end

        -- Failed, restore state and try next test
        inout_new_state.x = inout_new_state.x - x
        inout_new_state.y = inout_new_state.y - y
    end

    -- None of the kicks worked
    return false
end

sps = {}
function initSp(sp, img)
    if sps[sp] == nil then
        sps[sp] = lg.newSpriteBatch(img)
    else
        sps[sp]:clear()
    end

    return sps[sp]
end

local drawPieceBox = require "drawPieceBox"

function Game:draw()

    lg.push("all") -- Start bg
    lg.setColor(GRAY_DARK)
    lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    lg.pop() -- End bg

    lg.push("all") -- Draw level meters
    self.levelmeter:draw()
    lg.setColor(BLACK)
    partrect(TETRIS_BOARD_X - EDGEWIDTH_X, TETRIS_BOARD_Y, EDGEWIDTH_X, TETRIS_BOARD_H+1,{down=true})
    partrect(TETRIS_BOARD_X + TETRIS_BOARD_W+1, TETRIS_BOARD_Y, EDGEWIDTH_X, TETRIS_BOARD_H+1,{down=true})
    lg.pop()

    lg.push("all") -- Start board
    lg.setColor(GRAY)
    lg.rectangle("fill", TETRIS_BOARD_X, TETRIS_BOARD_Y, TETRIS_BOARD_W, TETRIS_BOARD_H)
    lg.pop() -- End board

    lg.push("all") -- Start board
    lg.translate(TETRIS_BOARD_X, TETRIS_BOARD_Y)

    if self.animflags.drawplayer and not self.gameover then

        lg.push("transform") -- Start harddrop
        local harddrop = self:getHarddropState()
        lg.translate((harddrop.x-1) * TETRIS_PIECE_SIZE, (harddrop.y-1) * TETRIS_PIECE_SIZE)
        local playerClip = nil
        if harddrop.y == 0 then
            playerClip = {u=2}
        end
        drawPiece(harddrop.id, harddrop.rot, initSp("harddrop", blockImg), .5, playerClip)
        lg.pop() -- End harddrop

        lg.push("transform") -- Start player
        lg.translate((self.state.x-1) * TETRIS_PIECE_SIZE, (self.state.y-1) * TETRIS_PIECE_SIZE)
        local playerClip = nil
        if self.state.y == 0 then
            playerClip = {u=2}
        end
        drawPiece(self.state.id, self.state.rot, initSp("player", blockImg), 1, playerClip)
        lg.pop() -- End player
    end

    -- todo make better
    local drawBoard = construct(Board)
    drawBoard:copyFrom(self.board)

    if self.midclearlines and not self.animflags.drawmidclearlines then
        drawBoard:fillLines(self.midclearlines, nil)
    end

    drawBoard:drawOutline()

    local spBoard = initSp("board", blockImg);

    drawBoard:drawToSp(spBoard)

    lg.draw(spBoard)

    lg.pop() -- End board

    lg.push("all") -- Start next&hold
    lg.translate(10,10)
    drawPieceBox(self.bag:peek(), "NEXT", initSp("next", blockImg), 1)
    lg.translate(33,0)
    local tint = 1
    if not self.canHold then tint = .5 end
    drawPieceBox(self.hold, "HOLD", initSp("hold", blockImg), tint)
    lg.pop() -- End next&hold

    lg.push("all") -- Start scoreboard
    lg.translate(TETRIS_BOARD_X-EDGEWIDTH_X, TETRIS_BOARD_Y + TETRIS_BOARD_H)
    self.scoreboard:draw()
    lg.pop() -- End scoreboard

    lg.push("all") -- Start board border

    lg.setColor(BLACK)
    lg.rectangle("line", TETRIS_BOARD_X, TETRIS_BOARD_Y, TETRIS_BOARD_W+1, TETRIS_BOARD_H+1)

    lg.pop()

    if self.blocking_anim then self.blocking_anim:draw(self) end
    for i=1,#self.free_anims do
        self.free_anims[i]:draw(self)
    end

    lg.push() -- Start debug draw
    lg.setColor(WHITE)
    lg.translate(170,10)
    -- lg.print(string.format("id:%d r:%d", self.state.id, self.state.rot),0,0)
    -- lg.print(string.format("g:%d, l:%d", self.cGravity, self.cLockdelay), 0, 10)
    -- lg.print(string.format("bag:%d", #self.bag), 0, 20)
    -- if self.blocking_anim then
    -- lg.print(string.format("anim:%s", self.blocking_anim._t), 0, 30)
    -- end
    lg.print(string.format("lv:%d\nln:%d/%d", self.level, self.lines, LEVEL_CLEAR_LINES))
    lg.pop() -- End debug draw

    if self.gameover then
        lg.push("all")
        local text = "game over :("
        local width = lg.getFont():getWidth(text)
        local x = TETRIS_BOARD_X + ((TETRIS_BOARD_W - width) / 2)
        local y = TETRIS_BOARD_Y + (TETRIS_BOARD_H / 2)

        lg.setColor(BLACK)
        lg.print(text, x+1, y+1)
        lg.setColor(WHITE)
        lg.print(text, x, y)

        lg.pop()
    end

end

return Game