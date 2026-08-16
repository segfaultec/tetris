
local Particle = require "Particle"

---@class AnimFlags
---@field midclearlines_col table
AnimFlags = {
    drawplayer = true
}
function AnimFlags:construct(o)
    
end

---@class Anim
---@field callback function | nil
local Anim = { _started = false, _finished = false, _t = 0 }

---@param flags AnimFlags
---@param game Game
function Anim:tick(flags, game)

    if not self._started then
        self:_start(flags, game)
        self._started = true
    end

    if not self._finished then
        if self:_tick(flags, self._t, game) then
            self:_finish(flags, game)
            self._finished = true

            if self.callback then self.callback() end
        else 
            self._t = self._t + 1
        end
    end

    return self._finished
end

function Anim:draw(game)
    if self._started then
        self:_draw(game)
    end
end

function Anim:_start(flags, game) end
function Anim:_tick(flags, t, game) return true end
function Anim:_finish(flags, game) end
function Anim:_draw(game) end

local F_ANIM_LINECLEAR_DURATION = TICKRATE*1

---@class Anim_Lineclear: Anim
---@field particles Particles[]
Anim_Lineclear = {
    
}
setmetatable(Anim_Lineclear, {__index=Anim})

---@param flags AnimFlags
---@param game Game
function Anim_Lineclear:_start(flags, game)
    flags.drawplayer = false

    self.particles = {}
    for i=1,#game.midclearlines do
        local y = game.midclearlines[i]

        for x=1,TETRIS_BOARD_COUNT_W do
            local particle = construct(Particle)
            particle:start(
                TETRIS_BOARD_X + (TETRIS_PIECE_SIZE * (x-1+.5)),
                TETRIS_BOARD_Y + (TETRIS_PIECE_SIZE * (y-1+.5))
            )
            table.insert(self.particles, particle)
        end
    end

end

---@param flags AnimFlags
---@param game Game
function Anim_Lineclear:_finish(flags, game)
    flags.drawplayer = true
end

---@param flags AnimFlags
---@param game Game
---@return boolean Done
function Anim_Lineclear:_tick(flags, t, game)
    if t == F_ANIM_LINECLEAR_END_B then
        return true
    end

    for i=1,#self.particles do
        self.particles[i]:update()
    end

    return false

end

---@param game Game
function Anim_Lineclear:_draw(game)

    for i=1,#self.particles do
        self.particles[i]:draw()
    end

end