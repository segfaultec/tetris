
require "Board"
require "RandomBag"

Game = {
    board = nil,
    spBlocks = nil,

    cGravity = F_GRAVITYDELAY,
    cLockdelay = F_LOCKDELAY,
    cLockMoveLimit = LOCKMOVELIMIT,

    state = {
        x = 4,
        y = 4,
        id = 3,
        rot = 1
    },

    bag = nil
}

local Game_meta = {__index = Game}
local Game_state_meta = {__index = Game.state}

function Game:new(o)
    o = o or {}
    o.state = o.state or {}

    setmetatable(o, Game_meta)
    setmetatable(o.state, Game_state_meta)

    self.board = Board:new()
    self.board:empty()

    self.bag = RandomBag:new()

    return o
end

function Game:init()
    local blockImg = lg.newImage("img/block6x6.png")
    self.spBlocks = lg.newSpriteBatch(blockImg)

    self:resetPlayer()
end

function Game:tick()
    
    self:gravity()

end

function Game:resetPlayer()
    self.state.x = 3
    self.state.y = 0
    self.state.id = self.bag:get()
    self.state.rot = 1
end

function Game:harddrop()
    local oldstate = table.shallow_copy(self.state)
    local newstate = table.shallow_copy(self.state)
    while true do
        newstate.y = newstate.y + 1

        if self:tryMovePiece(oldstate, newstate) then
            oldstate.y = newstate.y
        else
            self.board:addPlayerPiece(oldstate)
            self:resetPlayer()
            break
        end

    end
end

function Game:gravity()
    local newstate = table.shallow_copy(self.state)
    newstate.y = self.state.y + 1

    if self:tryMovePiece(self.state, newstate) then

        self.cLockdelay = F_LOCKDELAY

        self.cGravity = self.cGravity - 1
        if (self.cGravity == 0) then
            self.cGravity = F_MOVEDOWN

            -- Apply movedown
            self.state = newstate
        end
    else
        self.cGravity = F_GRAVITYDELAY

        self.cLockdelay = self.cLockdelay - 1
        if (self.cLockdelay == 0) then
            self.cLockdelay = F_LOCKDELAY

            self.board:addPlayerPiece(self.state)
            self:resetPlayer()
            
        end
    end
end

function Game:keypressed(key)

    local newstate = nil

    if key == "q" then
        newstate = table.shallow_copy(self.state)
        newstate.rot = math.wrap(self.state.rot - 1, 1, ROT_MAX)
    elseif key == "e" then
        newstate = table.shallow_copy(self.state)
        newstate.rot = math.wrap(self.state.rot + 1, 1, ROT_MAX)
    elseif key == "r" then
        newstate = table.shallow_copy(self.state)
        newstate.id = math.wrap(self.state.id - 1, 1, PIECES_MAX)
    elseif key == "t" then
        newstate = table.shallow_copy(self.state)
        newstate.id = math.wrap(self.state.id + 1, 1, PIECES_MAX)
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
    end

    if newstate ~= nil and self:tryMovePiece(self.state, newstate) then
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

function Game:draw()

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
    
    local drawBoard = Board:new()
    drawBoard:copyFrom(self.board)
    drawBoard:addPlayerPiece(self.state)

    self.spBlocks:clear()
    drawBoard:drawToSp(self.spBlocks)
    lg.draw(self.spBlocks)

    lg.pop()

    lg.push() -- Start debug draw
    lg.setColor(WHITE)
    lg.print(string.format("id:%d r:%d", self.state.id, self.state.rot),10,10)
    lg.print(string.format("g:%d, l:%d", self.cGravity, self.cLockdelay), 10, 20)
    lg.pop() -- End debug draw

end