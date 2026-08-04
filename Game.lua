
require "Board"

Game = {
    board = nil,
    spBlocks = nil,

    countMoveDown = 0,

    state = {
        x = 4,
        y = 4,
        id = 3,
        rot = 1
    }
}

function Game:new(o)
    o = o or {}
    o.state = o.state or {}

    setmetatable(o, {__index = Game})
    setmetatable(o.state, {__index = Game.state})

    self.board = Board:new()
    self.board:empty()

    return o
end

function Game:init()
    local blockImg = lg.newImage("img/block6x6.png")
    self.spBlocks = lg.newSpriteBatch(blockImg)
end

function Game:tick()
    


end

function Game:keypressed(key)
    local newstate = table.shallow_copy_obj(self.state)
    if key == "q" then
        newstate.rot = math.wrap(self.state.rot - 1, 1, ROT_MAX)
    elseif key == "e" then
        newstate.rot = math.wrap(self.state.rot + 1, 1, ROT_MAX)
    elseif key == "r" then
        newstate.id = math.wrap(self.state.id - 1, 1, PIECES_MAX)
    elseif key == "t" then
        newstate.id = math.wrap(self.state.id + 1, 1, PIECES_MAX)
    elseif key == "a" then
        newstate.x = self.state.x - 1
    elseif key == "d" then
        newstate.x = self.state.x + 1
    elseif key == "w" then
        newstate.y = self.state.y - 1
    elseif key == "s" then
        newstate.y = self.state.y + 1
    end

    if self:tryMovePiece(self.state, newstate) then
        self.state = newstate
    end

    if key == "space" then
        self.board:addPlayerPiece(self.state)
        self.state.y = 3
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

    local drawBoard = Board:new()
    drawBoard:copyFrom(self.board)
    drawBoard:addPlayerPiece(self.state)

    drawBoard:draw(self.spBlocks)
end