
---@class AnimFlags
---@field midclearlines_col table
AnimFlags = {
    drawplayer = true
}
function AnimFlags:construct(o)
    o.midclearlines_col = {1,1,1}
end

---@class Anim
---@field callback function | nil
local Anim = { _started = false, _finished = false, _t = 0 }

---@param flags AnimFlags
function Anim:tick(flags)

    if not self._started then
        self:_start(flags)
        self._started = true
    end

    if not self._finished then
        if self:_tick(flags, self._t) then
            self:_finish(flags)
            self._finished = true

            if self.callback then self.callback() end
        else 
            self._t = self._t + 1
        end
    end

    return self._finished
end

---@param flags AnimFlags
function Anim:_start(flags)

end

---@param flags AnimFlags
function Anim:_tick(flags, t)
    return true
end

---@param flags AnimFlags
function Anim:_finish(flags)

end

local F_ANIM_LINECLEAR_DURATION = TICKRATE*1

---@class Anim_Lineclear : Anim
Anim_Lineclear = {
    duration = 0
}
setmetatable(Anim_Lineclear, {__index=Anim})

function Anim_Lineclear:_start(flags)
    flags.drawplayer = false
end

---@return boolean Done
function Anim_Lineclear:_tick(flags, t)

    local x = math.abs(math.sin(t * 0.1))

    flags.midclearlines_col[1] = x
    flags.midclearlines_col[2] = x
    flags.midclearlines_col[3] = x

    if self.duration == F_ANIM_LINECLEAR_DURATION then
        return true
    end

    self.duration = self.duration + 1

    return false

end

function Anim_Lineclear:_finish(flags)
    flags.drawplayer = true
end