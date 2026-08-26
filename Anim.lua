
local LineClearParticle = require "particles.LineClearParticle"
local HardDropParticle  = require "particles.HardDropParticle"

---@class AnimFlags
---@field midclearlines_col table
AnimFlags = {
    drawplayer = true,
    drawmidclearlines = true
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

---@class Anim_Harddrop: Anim
---@field particle HardDropParticle
Anim_Harddrop = {
    x = 0,
    y = 0,
    w = 0,
    finished = false
}
setmetatable(Anim_Harddrop, {__index=Anim})

function Anim_Harddrop:_start(flags, game)

    local piece = PIECES[self.state.id]
    if piece ~= nil then
        local rotation = piece.rotations[self.state.rot]

        local baseY = nil
        for iy=piece.bounds[2],1,-1 do
            if rotation[iy] ~= 0 then
                baseY = iy
                break
            end
        end

        local xL, xR = nil, nil
        if baseY ~= nil then
            for ix=1,piece.bounds[1] do
                if bit.band(rotation[baseY], bit.lshift(1, piece.bounds[1]-ix)) ~= 0 then
                    if xL == nil then xL = ix-1 end
                    xR = ix-1
                end
            end
        end

        local x = self.state.x +((xR-xL)*.5)+(xL)+(.5)
        local y = self.state.y+baseY
        local w = (xR-xL+1)

        self.particle = construct(HardDropParticle)
        self.particle:start(
            TETRIS_BOARD_X + ((x-1) * TETRIS_PIECE_SIZE),
            TETRIS_BOARD_Y + ((y-1) * TETRIS_PIECE_SIZE),
            {w=TETRIS_PIECE_SIZE*w*.5}
        )

    end
end

function Anim_Harddrop:_tick(flags, t, game)
    self.particle:update()

    return t > 30
end

function Anim_Harddrop:_draw(game)
    self.particle:draw()
end

function Anim_Harddrop:_finish(flags, game)

end

---@class Anim_Lineclear: Anim
---@field particles LineClearParticle[]
---@field start_callback function | nil
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
            local col = game.board:get(x, y)
            local particle = construct(LineClearParticle)
            particle:start(
                TETRIS_BOARD_X + (TETRIS_PIECE_SIZE * (x-1+.5)),
                TETRIS_BOARD_Y + (TETRIS_PIECE_SIZE * (y-1+.5)),
                {col=col}
            )
            table.insert(self.particles, particle)
        end
    end

end

---@param flags AnimFlags
---@param game Game
function Anim_Lineclear:_finish(flags, game)
    flags.drawplayer = true
    flags.drawmidclearlines = true
end

---@param flags AnimFlags
---@param game Game
---@return boolean Done
function Anim_Lineclear:_tick(flags, t, game)
    if t == F_ANIM_LINECLEAR_END_B then
        return true
    end

    if t == F_ANIM_LINECLEAR_START then
        flags.drawmidclearlines = false
        flags.drawplayer = true
        if self.start_callback ~= nil then self.start_callback() end
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