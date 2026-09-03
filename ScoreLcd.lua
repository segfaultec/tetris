
---@class ScoreLcd
---@field lamps table
local ScoreLcd = {
    t=0,

    comboShowZero = 0,
    combo = 0
}

function ScoreLcd:init()
    self.lamps = {}
end

function ScoreLcd:setDigitFlags(prefix, digit)

    local flags = {}

    function loadFromStr(str)
        for i=1,string.len(str) do
            flags[tonumber(string.sub(str, i, i))] = true
        end
    end

    if digit == 0 then
        loadFromStr("123567")
    elseif digit == 1 then
        loadFromStr("36")
    elseif digit == 2 then
        loadFromStr("13457")
    elseif digit == 3 then
        loadFromStr("13467")
    elseif digit == 4 then
        loadFromStr("2346")
    elseif digit == 5 then
        loadFromStr("12467")
    elseif digit == 6 then
        loadFromStr("124567")
    elseif digit == 7 then
        loadFromStr("136")
    elseif digit == 8 then
        loadFromStr("1234567")
    elseif digit == 9 then
        loadFromStr("123467")
    end

    for i=1,7 do
        self.lamps[prefix..i] = flags[i]
    end

end

function ScoreLcd:setCombo(new_combo)

    if self.combo ~= new_combo and new_combo == 0 then
        self.comboShowZero = 16
    end

    self.combo = math.clamp(new_combo, 0, 99)

end

function ScoreLcd:tick()
    self.t = self.t + 1

    local showZero = self.comboShowZero > 0 and self.comboShowZero % 2 == 0

    if self.combo == 0 and not showZero then
        self:setDigitFlags("combo1", nil)
        self:setDigitFlags("combo2", nil)
    else
        local digit10 = floor(self.combo / 10)
        local digit1 = floor(self.combo % 10)

        self:setDigitFlags("combo1", digit10)
        self:setDigitFlags("combo2", digit1)
    end

    if self.comboShowZero > 0 then
        self.comboShowZero = self.comboShowZero - 1
    end
end

function ScoreLcd.drawLcd(quadData, x, y)
    if x == nil then x = 0 end
    if y == nil then y = 0 end

    x = x + quadData.position.x
    y = y + quadData.position.y

    lg.draw(iScoreLcd, quadData.quad, x, y)
end

function ScoreLcd:draw()

    self.drawLcd(qtScoreLcd.lcd_base)
    self.drawLcd(qtScoreLcd.lcd_burn)
    self.drawLcd(qtScoreLcd.border)

    for lamp,value in pairs(self.lamps) do
        if value then
            self.drawLcd(qtScoreLcd[lamp])
        end
    end
    
end

return ScoreLcd