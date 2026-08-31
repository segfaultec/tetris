local easing = require "lib.easing"

---@class LevelMeter
local LevelMeter = {
    t = 0,
    start = 0,
    current = 0,
    target = 0,
    fill_t = 0
}

function LevelMeter:init(init_fill)
    if init_fill < 0.01 then init_fill = -.2 end

    self.start, self.current, self.target = init_fill, init_fill, init_fill
end

FILL_ANIM_TIME = 90

function LevelMeter:setFill(new_fill)
    if new_fill < 0.01 then new_fill = -.2 end

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

    lg.push("all")

    local WIDTH = TETRIS_BOARD_W+EDGEWIDTH_X+EDGEWIDTH_X
    local HEIGHT = TETRIS_BOARD_H+EDGEWIDTH_Y

    local X_START = TETRIS_BOARD_X - EDGEWIDTH_X
    local Y_START = TETRIS_BOARD_Y

    local Y_FILL = TETRIS_BOARD_Y + (TETRIS_BOARD_H * (1-self.current))

    lg.setScissor(X_START, Y_START, WIDTH, HEIGHT)

    local cols = {}

    for i=1,PIECES_MAX do
        local col = table.shallow_copy(PIECES[i].colour)
        local tint = .8
        col[1] = col[1] * tint
        col[2] = col[2] * tint
        col[3] = col[3] * tint
        table.insert(cols, col)
    end

    local a = 1
    local b = 1

    local wave = easing.outQuart(self.fill_t, 3.5, 3.5-1.7, FILL_ANIM_TIME)

    for x=X_START-20,X_START+WIDTH+10,2 do

        local offset = sin((self.t+(x*4)) * 0.02)*1.7
        b = a

        for y=Y_FILL,Y_START+HEIGHT+10,2 do
            local col = cols[b+1]

            lg.setColor(col)

            lg.rectangle("fill",x,y+offset,2,2)

            b = (b + 1) % #cols
        end
        a = (a + 1) % #cols
    end

    lg.pop()

end

return LevelMeter