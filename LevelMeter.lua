local easing = require "lib.easing"

---@class LevelMeter
---@field cols_queue table
---@field cols_active table
local LevelMeter = {
    t = 0,
    start = 0,
    current = 0,
    target = 0,
    fill_t = 0
}

function LevelMeter:init(init_fill)
    --if init_fill < 0.01 then init_fill = -.2 end

    self.start, self.current, self.target = init_fill, init_fill, init_fill
    self.cols_queue = {}
    self.cols_active = {}
end

function LevelMeter:queueColours(cols)
    self.cols_queue = {}
    for i=1,#cols do
        table.insert(self.cols_queue, cols[i])
    end
end

FILL_ANIM_TIME = 90

function LevelMeter:setFill(new_fill)
    --if new_fill < 0.01 then new_fill = -.1 end

    self.start = self.current
    self.target = new_fill
    self.fill_t = 0
end

function LevelMeter:tick()
    self.t = self.t + 1

    if self.fill_t < FILL_ANIM_TIME then
        self.current = easing.outQuart(self.fill_t, self.start, self.target - self.start, FILL_ANIM_TIME)
        self.fill_t = self.fill_t + 1
    else
        self.current = self.target
    end

end

function LevelMeter:draw()

    local rng = love.math.newRandomGenerator()

    lg.push("all")

    local WIDTH = TETRIS_BOARD_W+EDGEWIDTH_X+EDGEWIDTH_X
    local HEIGHT = TETRIS_BOARD_H+EDGEWIDTH_Y+3

    local X_START = TETRIS_BOARD_X - EDGEWIDTH_X
    local Y_START = TETRIS_BOARD_Y + TETRIS_BOARD_H + 13

    local Y_FILL = Y_START - (HEIGHT * (self.current)) + 1

    lg.setScissor(X_START, TETRIS_BOARD_Y, WIDTH, HEIGHT)

    local col_index = 1

    for y=Y_START,Y_FILL,-2 do
        for x=X_START,X_START+WIDTH-1,2 do
        
            local offset = sin((self.t+(x*4)) * 0.02)*1.7

            while col_index > #self.cols_active and #self.cols_queue > 0 do
                local col = table.shallow_copy(self.cols_queue[love.math.random(#self.cols_queue)])
                local TINT = random(.6,.9)
                col[1] = col[1] * TINT
                col[2] = col[2] * TINT
                col[3] = col[3] * TINT
                table.insert(self.cols_active, col)
            end

            local col = nil
            if col_index <= #self.cols_active then
                -- Reverse index so oldest cols are at the top
                col = self.cols_active[#self.cols_active-col_index+1]
            else
                col = WHITE
            end
            lg.setColor(col)

            lg.rectangle("fill",x,y+offset,2,2)

            col_index = col_index + 1
        end
    end

    while #self.cols_active > col_index do
        self.cols_active[#self.cols_active] = nil
    end

    lg.pop()

    lg.print(#self.cols_active, 50, 50)

end

return LevelMeter