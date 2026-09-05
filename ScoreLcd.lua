
local ON = 1
local FLASH = 2

local Events = {
    single = {
        clear = ON,
        clear_s = ON,
        clear_dot = ON
    },
    double = {
        clear = ON,
        clear_d = ON,
        clear_dot = ON
    },
    triple = {
        clear = ON,
        clear_t = ON,
        clear_dot = ON
    },
    tetris = {
        clear = FLASH,
        tet_l = ON,
        tet_c = ON,
        tet_r = ON,
        tet_b = ON,
        tetris_t = FLASH,
        tetris_e = FLASH,
        tetris_t2 = FLASH,
        tetris_r = FLASH,
        tetris_i = FLASH,
        tetris_s = FLASH
    },
    backtoback = {
        lcd_b2b = FLASH
    }
}

---@class ScoreLcd
---@field lamps table
---@field events table
local ScoreLcd = {
    t=0,

    comboShowZero = 0,
    combo = 0,
    dead = false
}

function ScoreLcd:init()
    self.lamps = {}
    self.events = {}
end

function ScoreLcd:runevent(event, duration)

    local event = Events[event]
    if event == nil then return end

    local event_inst = {duration=duration, event=event}

    self.events[event] = event_inst

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


---@param game Game
function ScoreLcd:tick(game)
    self.t = self.t + 1

    if self.combo ~= game.combo and new_combo == 0 then
        self.comboShowZero = 16
    end

    self.combo = math.clamp(game.combo, 0, 99)
    self.dead = game.gameover

    self.lamps = {}

    local showZero = self.comboShowZero > 0 and self.comboShowZero % 2 == 0
    if self.combo > 0 or showZero then
        local digit10 = floor(self.combo / 10)
        local digit1 = floor(self.combo % 10)

        self:setDigitFlags("combo1", digit10)
        self:setDigitFlags("combo2", digit1)
    end

    for eventk,inst in pairs(self.events) do
        if inst.duration > 0 then
            for lampk,value in pairs(inst.event) do
                if lampk ~= "duration" then

                    local on = false

                    if value == ON then
                        on = true
                    elseif value == FLASH then
                        on = self.t % 4 >= 2
                    end

                    if on then
                        self.lamps[lampk] = true
                    end
                end
            end

            inst.duration = inst.duration - 1
        else
            self.events[eventk] = nil
        end
    end

    if self.dead then
        self.lamps["skull"] = true
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
            if qtScoreLcd[lamp] ~= nil then
                self.drawLcd(qtScoreLcd[lamp])
            else
                print(lamp)
            end
        end
    end
    
end

return ScoreLcd