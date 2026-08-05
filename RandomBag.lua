RandomBag = {}

function RandomBag:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o:_regenerate()

    return o
end

function RandomBag:get()
    if #self == 0 then self:_regenerate() end
    return table.remove(self, #self)
end

function RandomBag:_regenerate()
    for i=1,PIECES_MAX do
        self[i] = i
    end

    for i=PIECES_MAX,2,-1 do
        local j = love.math.random(i)
        self[i], self[j] = self[j], self[i]
    end
end