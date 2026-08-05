RandomBag = {}

function RandomBag:new()
    local o = {}
    setmetatable(o, {__index = RandomBag})
    return o
end

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

    for i=PIECES_MAX,2,-1 do
        local j = love.math.random(i)
        self[i], self[j] = self[j], self[i]
    end

    str = ""
    for i=1,PIECES_MAX do
        str = str..self[i]
    end
    print(str)
end