local ParticleEmitter = require "ParticleEmitter"

---@class ParticleTest
---@field emitters ParticleEmitter[]
local ParticleTest = {

}

function ParticleTest:init()
    self.emitters = {}

    local particle = construct(ParticleEmitter)
    particle:start(50,50)
    table.insert(self.emitters, particle)

end

function ParticleTest:tick()

    for i=1,#self.emitters do
        self.emitters[i]:update()
    end

end

function ParticleTest:draw()
    lg.push("all")
    lg.setColor(GRAY_DARK)
    lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    lg.pop()

    lg.push("all")
    for i=1,#self.emitters do
        self.emitters[i]:draw()
    end
    lg.pop()
end

function ParticleTest:keypressed(key)

end

return ParticleTest