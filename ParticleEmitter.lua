
local Particles = require "Particle"

---@class ParticleEmitter
---@field particles Particles
local ParticleEmitter = {
    root_x = 0,
    root_y = 0,

    t_emit = 0
}

function ParticleEmitter:start(x, y)
    self.root_x = x
    self.root_y = y

    self.particles = construct(Particles)
    self.particles:start(0,0)
end

function ParticleEmitter:update()

    self.particles:update()

    if self.t_emit == 0 then

        self.particles:emit()
        self.particles:emit()

        self.t_emit = 2

    else
        self.t_emit = self.t_emit - 1
    end

end

function ParticleEmitter:draw()
    lg.push("all")
    lg.translate(self.root_x, self.root_y)
    self.particles:draw()
    lg.setColor(RED)
    lg.circle("fill", 0,0,1)
    lg.pop()

    lg.push("all")
    lg.translate(GAME_WIDTH-50, 20)
    lg.setColor(WHITE)
    lg.print(string.format("%d/%d", 
        self.particles:count_alive(),
        self.particles:count_slots()
    ))
    lg.pop()
end

return ParticleEmitter