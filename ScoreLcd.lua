
---@class ScoreLcd
local ScoreLcd = {}

function ScoreLcd:init()

end

function ScoreLcd:tick()

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
    
end

return ScoreLcd