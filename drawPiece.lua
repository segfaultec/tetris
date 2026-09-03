local function drawPiece(pid, rot, sp, tint, cliprect)

    local clipU, clipL, clipR, clipD = nil,nil,nil,nil
    if cliprect ~= nil then
        clipU, clipL, clipR, clipD = cliprect.u,cliprect.l,cliprect.r,cliprect.d
    end

    local function isInClipRect(x,y)
        if clipL ~= nil and x < clipL then return false end
        if clipR ~= nil and x > clipR then return false end
        if clipU ~= nil and y < clipU then return false end
        if clipD ~= nil and y > clipD then return false end
        return true
    end

    local piece = PIECES[pid]
    if piece == nil then return end

    local colour = table.shallow_copy(piece.colour)
    colour[4] = tint

    -- Draw the piece
    for offy=1,piece.bounds[2] do
        for offx=1,piece.bounds[1] do
            if bit.band(piece.rotations[rot][offy], bit.lshift(1, piece.bounds[1]-offx)) ~= 0
                and isInClipRect(offx, offy) then
                sp:setColor(colour)
                sp:add(((offx-1) * TETRIS_PIECE_SIZE), ((offy-1) * TETRIS_PIECE_SIZE))
            end
        end
    end
    lg.draw(sp)

end

return drawPiece