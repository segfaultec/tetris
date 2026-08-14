
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
---@field flags AnimFlags | nil
local Anim = {flags = nil}

function Anim:new(o)
    o = o or {}
    setmetatable(o, {__index = self})
    return o
end

function Anim:init(flags)
    self.flags = flags
    self:_start(self.flags)
end

function Anim:tick()
    if self:_tick(self.flags) then
        self:_finish(self.flags)
        return true
    end
    return false
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

local F_ANIM_LINECLEAR_DURATION = 30

---@class Anim_Lineclear : Anim
Anim_Lineclear = {
    duration = 0
}
setmetatable(Anim_Lineclear, {__index=Anim})

function Anim_Lineclear:new(o)
    o = o or {}
    setmetatable(o, {__index = self})
    return o
end

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