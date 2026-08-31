---@class RandomBag
RandomBag = {}

function RandomBag:consume()
    if #self == 0 then self:_regenerate() end
    return table.remove(self)
end

function RandomBag:peek()
    if #self == 0 then self:_regenerate() end
    return self[#self]
end

function RandomBag:_regenerate()
    for i=1,PIECES_MAX do
        self[i] = i
    end

    table.shuffle(self)

    -- str = ""
    -- for i=1,PIECES_MAX do
    --     str = str..self[i]
    -- end
    -- print(str)
end