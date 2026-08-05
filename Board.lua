
Board = {}
function Board:new(o)
    o = o or {
        board={}
    }
    setmetatable(o, self)
    self.__index = self

    return o
end

function Board:empty()
    local t = self.board
    for tileX=1,TETRIS_BOARD_COUNT_W do
        if t[tileX] == nil then t[tileX] = {} end
        for tileY=1,TETRIS_BOARD_COUNT_H do
            t[tileX][tileY] = nil
        end
    end
end

function Board:copyFrom(otherboard)
    for x=1,TETRIS_BOARD_COUNT_W do
        if self.board[x] == nil then self.board[x] = {} end
        for y=1,TETRIS_BOARD_COUNT_H do
            self.board[x][y] = otherboard.board[x][y]
        end
    end
end

function Board:drawToSp(spBlocks)
    for tileX=1,TETRIS_BOARD_COUNT_W do
        for tileY=1,TETRIS_BOARD_COUNT_H do
            local tile = self.board[tileX][tileY]
            if tile ~= nil then
                spBlocks:setColor(self.board[tileX][tileY])
                spBlocks:add((tileX-1) * TETRIS_PIECE_SIZE, (tileY-1) * TETRIS_PIECE_SIZE)
            end
        end
    end
end

function Board:addPlayerPiece(state)

    local x, y = state.x, state.y

    local piece = PIECES[state.id]
    local bx, by = piece.bounds[1], piece.bounds[2]
    local blocks = piece.rotations[state.rot]

    for yo=1,by do
        for xo=1,bx do

            if bit.band(blocks[yo], bit.lshift(1, bx-xo)) ~= 0
                and math.isinrange(x+xo-1, 1, TETRIS_BOARD_COUNT_W)
                and math.isinrange(y+yo-1, 1, TETRIS_BOARD_COUNT_H) then
                self.board[x+xo-1][y+yo-1] = piece.colour
            end
        end
    end
end

function Board:isPieceValidSpot(state)
    local x, y = state.x, state.y

    local piece = PIECES[state.id]
    local bx, by = piece.bounds[1], piece.bounds[2]
    local blocks = piece.rotations[state.rot]

    for yo=1,by do
        for xo=1,bx do
            if bit.band(blocks[yo], bit.lshift(1, bx-xo)) ~= 0 then
                if math.isinrange(x+xo-1, 1, TETRIS_BOARD_COUNT_W)
                    and math.isinrange(y+yo-1, 1, TETRIS_BOARD_COUNT_H)
                    and self.board[x+xo-1][y+yo-1] == nil then
                        -- wow
                    else
                        -- placing pieces failed
                        return false
                    end
            end
        end
    end

    return true
end