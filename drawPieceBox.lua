local function drawPieceBox(pid, title, sp, tint)

    local boxsize = 5

    lg.push("all")

    lg.setColor(WHITE)
    lg.print(title, 0, 0)
    lg.translate(0, 13)

    lg.setColor(GRAY)
    lg.rectangle("fill", 0, 0, boxsize*TETRIS_PIECE_SIZE, boxsize*TETRIS_PIECE_SIZE)
    lg.setColor(BLACK)
    lg.rectangle("line", 0, 0, boxsize*TETRIS_PIECE_SIZE+1, boxsize*TETRIS_PIECE_SIZE+1)

    lg.setColor(WHITE)

    local piece = PIECES[pid]
    if piece ~= nil then

        -- Calculate actual piece min bounds
        local boundx, boundy = 0,0
        for iy=1,piece.bounds[2] do
            for ix=1,piece.bounds[1] do
                if bit.band(piece.rotations[1][iy], bit.lshift(1, piece.bounds[1]-ix)) ~= 0 then
                    if boundx<ix then boundx=ix end
                    if boundy<iy then boundy=iy end
                end
            end
        end

        local colour = table.shallow_copy(piece.colour)
        for i=1,#colour do
            colour[i] = colour[i] * tint
        end

        -- Draw the piece
        local orix, oriy = (boxsize/2-boundx/2)*TETRIS_PIECE_SIZE, (boxsize/2-boundy/2)*TETRIS_PIECE_SIZE
        for offy=1,boundy do
            for offx=1,boundx do
                if bit.band(piece.rotations[1][offy], bit.lshift(1, piece.bounds[1]-offx)) ~= 0 then
                    sp:setColor(colour)
                    sp:add(orix+((offx-1) * TETRIS_PIECE_SIZE), oriy+((offy-1) * TETRIS_PIECE_SIZE))
                end
            end
        end
        lg.draw(sp)
    end

    lg.pop()
end

return drawPieceBox