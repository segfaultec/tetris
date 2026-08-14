
---@class Board
Board = {}

function Board:empty()
    for y=1,TETRIS_BOARD_COUNT_H do
        self:emptyLine(y)
    end
end

function Board:emptyLine(y)
    if self[y] == nil then self[y] = {} end
    for x=1,TETRIS_BOARD_COUNT_W do
        self[y][x] = nil
    end
end

function Board:copyFrom(otherboard)
    for y=1,TETRIS_BOARD_COUNT_H do
        if self[y] == nil then self[y] = {} end
        for x=1,TETRIS_BOARD_COUNT_W do
            self[y][x] = otherboard.board[y][x]
        end
    end
end

function Board:drawToSp(spBlocks)
    for tileX=1,TETRIS_BOARD_COUNT_W do
        for tileY=1,TETRIS_BOARD_COUNT_H do
            local tile = self[tileY][tileX]
            if tile ~= nil then
                spBlocks:setColor(self[tileY][tileX])
                spBlocks:add((tileX-1) * TETRIS_PIECE_SIZE, (tileY-1) * TETRIS_PIECE_SIZE)
            end
        end
    end
end

function Board:drawOutline()

    lg.push("all")
    lg.setColor(WHITE)

    -- horizontal borders
    for tileX=1,TETRIS_BOARD_COUNT_W do
        for tileY=1,TETRIS_BOARD_COUNT_H do
            if self[tileY][tileX] ~= nil then
                lg.rectangle("fill",
                    ((tileX-1) * TETRIS_PIECE_SIZE) - 1,
                    ((tileY-1) * TETRIS_PIECE_SIZE) - 1,
                    (TETRIS_PIECE_SIZE) + 2,
                    (TETRIS_PIECE_SIZE) + 2
                )
            end
        end
    end

    lg.pop()

end

function Board:addPlayerPiece(state, tint)

    local x, y = state.x, state.y

    local piece = PIECES[state.id]
    local bx, by = piece.bounds[1], piece.bounds[2]
    local blocks = piece.rotations[state.rot]

    local colour = table.shallow_copy(piece.colour)
    for i=1,#colour do
        colour[i] = colour[i] * tint
    end

    for yo=1,by do
        for xo=1,bx do
            if bit.band(blocks[yo], bit.lshift(1, bx-xo)) ~= 0
                and math.isinrange(x+xo-1, 1, TETRIS_BOARD_COUNT_W)
                and math.isinrange(y+yo-1, 1, TETRIS_BOARD_COUNT_H) then
                self[y+yo-1][x+xo-1] = colour
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
                    and self[y+yo-1][x+xo-1] == nil then
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

function Board:isLineEmpty(y)
    for x=1,TETRIS_BOARD_COUNT_W do
        if self[y][x] ~= nil then
            return false
        end
    end
    return true
end

function Board:clearLines(ys)

    for i=1,#ys do
        self:emptyLine(ys[i])
    end

    local emptyCount = 0
    for y=TETRIS_BOARD_COUNT_H, 2, -1 do
        if self:isLineEmpty(y) then
            emptyCount = emptyCount + 1
        else
            if emptyCount > 0 then
                self[y], self[y+emptyCount] = self[y+emptyCount], self[y]
            end
        end
    end

end

function Board:checkLineClears()

    local clears = {}
    for y=1,TETRIS_BOARD_COUNT_H do
        
        local clear = true
        for x=1,TETRIS_BOARD_COUNT_W do
            if self[y][x] == nil then
                clear = false
                break
            end
        end

        if clear then table.insert(clears, y) end

    end

    return clears
end