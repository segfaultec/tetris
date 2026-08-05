local function drawPieceBox(pid, title, sp)

    local boxsize = 5

    lg.setColor(WHITE)
    lg.print(title, 0, 0)
    lg.translate(0, 13)

    lg.setColor(GRAY)
    lg.rectangle("fill", 0, 0, boxsize*TETRIS_PIECE_SIZE, boxsize*TETRIS_PIECE_SIZE)
    lg.setColor(BLACK)
    lg.rectangle("line", 0, 0, boxsize*TETRIS_PIECE_SIZE+1, boxsize*TETRIS_PIECE_SIZE+1)

    lg.setColor(WHITE)

    local nextpiece = PIECES[pid]
    if nextpiece ~= nil then

        -- Calculate actual piece min bounds
        local boundx, boundy = 0,0
        for iy=1,nextpiece.bounds[2] do
            for ix=1,nextpiece.bounds[1] do
                if bit.band(nextpiece.rotations[1][iy], bit.lshift(1, nextpiece.bounds[1]-ix)) ~= 0 then
                    if boundx<ix then boundx=ix end
                    if boundy<iy then boundy=iy end
                end
            end
        end

        -- Draw the piece
        local orix, oriy = (boxsize/2-boundx/2)*TETRIS_PIECE_SIZE, (boxsize/2-boundy/2)*TETRIS_PIECE_SIZE
        for offy=1,boundy do
            for offx=1,boundx do
                if bit.band(nextpiece.rotations[1][offy], bit.lshift(1, nextpiece.bounds[1]-offx)) ~= 0 then
                    sp:setColor(nextpiece.colour)
                    sp:add(orix+((offx-1) * TETRIS_PIECE_SIZE), oriy+((offy-1) * TETRIS_PIECE_SIZE))
                end
            end
        end
        lg.draw(sp)
    end
end

return drawPieceBox