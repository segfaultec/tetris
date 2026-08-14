
---@class AnimFlags
AnimFlags = {
    drawplayer = true
}

function AnimFlags:new(o)
    o = o or {}
    setmetatable(o, {__index = self})
    return o
end

---@class Anim
---@field callback function | nil
local Anim = { _started = false, _finished = false }

function Anim:tick(flags)

    if not self._started then
        self:_start(flags)
        self._started = true
    end

    if not self._finished then
        if self:_tick(flags) then
            self:_finish(flags)
            self._finished = true

            if self.callback then self.callback() end
        end
    end

    return self._finished
end

---@param flags AnimFlags
function Anim:_start(flags)

end

---@param flags AnimFlags
function Anim:_tick(flags)
    return true
end

---@param flags AnimFlags
function Anim:_finish(flags)

end

local F_ANIM_LINECLEAR_DURATION = 60*5

---@class Anim_Lineclear : Anim
Anim_Lineclear = {
    duration = 0
}
setmetatable(Anim_Lineclear, {__index=Anim})

function Anim_Lineclear:_start(flags)
    flags.drawplayer = false
end

---@return boolean Done
function Anim_Lineclear:_tick(flags)

    self.duration = self.duration + 1

    if self.duration == F_ANIM_LINECLEAR_DURATION then
        return true
    end

    return false

end

function Anim_Lineclear:_finish(flags)
    flags.drawplayer = true
end