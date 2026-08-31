

---@class Scoreboard
local Scoreboard = {
    start = 0,
    target = 0,
    current = 0,
    t = 0
}

local ANIM_TIME = 30
local WIDTH = TETRIS_BOARD_W+1+EDGEWIDTH_X+EDGEWIDTH_X
local CHAR_WIDTH = 8

function Scoreboard:init(total)
    self.start, self.target, self.current = total, total, total
end

function Scoreboard:setScore(total)
    self.start = self.current
    self.target = total
    self.t = 0
end

function Scoreboard:tick()
    if self.t < ANIM_TIME then
        -- Add a bit of jitter, breaks up cases where
        -- numbers go up in even-looking steps (5, 10, etc.)
        local t = (self.t / ANIM_TIME) + random(0,.05)
        self.current = floor(math.lerp(self.start, self.target, t))
        self.t = self.t + 1
    else
        self.current = self.target
    end
end

function Scoreboard:draw()
    lg.push("all")

    lg.setColor(BLACK)
    partrect(0, 1, WIDTH, EDGEWIDTH_Y,{up=true})

    local text = string.format("%d", self.current)
    local textwidth = CHAR_WIDTH*string.len(text)

    local xpos = WIDTH / 2 - textwidth / 2

    for i=1,string.len(text) do
        local char = string.sub(text, i,i)
        local offset = CHAR_WIDTH*(i-1)
        if char == "1" then offset = offset + 1 end
        lg.setColor(BLACK)
        lg.print(char, xpos + offset+1, 0)
        lg.setColor(WHITE)
        lg.print(char, xpos + offset, -1)
    end
    lg.pop()
end

return Scoreboard