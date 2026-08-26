local Particle = require "particles.Particle"

---@class HardDropParticle : Particle
local HardDropParticle = {
    pX = Particle.pSTRIDE,
    pY = Particle.pSTRIDE+1,
    pVX = Particle.pSTRIDE+2,
    pVY = Particle.pSTRIDE+3,
    pSTRIDE = Particle.pSTRIDE+4
}
setmetatable(HardDropParticle, {__index = Particle})


local COUNT = 3

function HardDropParticle:impl_startsystem(args)
    local w = args.w

    for i=1,COUNT do
        self:emit({x=-w})
        self:emit({x=w})
    end
end

function HardDropParticle:impl_start(index, args)
    local x = args.x
    self[index+self.pAGE] = 0
    self[index+self.pLIFETIME] = love.math.random(20, 30)

    self[index+self.pX] = x
    self[index+self.pY] = 0
    self[index+self.pVX] = math.sign(x)*random(.2,.4)
    self[index+self.pVY] = -random(.2,.4)
end

function HardDropParticle:impl_update(index)
    local drag = .955
    local gravity = 1/TICKRATE*1.3

    self[index+self.pVX] = self[index+self.pVX] * drag
    self[index+self.pVY] = (self[index+self.pVY]+gravity) * drag

    self[index+self.pX] = self[index+self.pX] + self[index+self.pVX]
    self[index+self.pY] = self[index+self.pY] + self[index+self.pVY]

    if self[index+self.pY] > 0 then
        self[index+self.pAGE] = -1
    end
end

function HardDropParticle:impl_draw(index)
    lg.push("all")
    lg.setColor(1,1,1,.5)
    lg.rectangle("fill",
        self[index+self.pX]-1,
        self[index+self.pY]-1,
        2,2)
    lg.pop()
end

return HardDropParticle