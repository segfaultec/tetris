local Particles = require "Particle"
local lineClearPs = require "particles.LineClearExplo"

---@class ParticleTest
---@field systems table[]
---@field anims Particles[]
local ParticleTest = {

}

function ParticleTest:init()
    
    self.systems = {lineClearPs}
    self.anims = {}

    local particle = construct(Particles)
    particle:start(0,0,WHITE)
    table.insert(self.anims, particle)

    for _, system in ipairs(self.systems) do
        for _, data in ipairs(system) do
            data.system:reset()
            data.system:start()
            data.system:setPosition(system.x+data.x,system.y+data.y)
            for i=1,data.kickStartSteps do
                data.system:update(data.kickStartDt)
            end
            data.system:emit(data.emitAtStart)
        end
    end

end

function ParticleTest:tick()

    for i=1,#self.anims do
        self.anims[i]:update()
    end

    for _, system in ipairs(self.systems) do
        for _, data in ipairs(system) do
            data.system:update(1/TICKRATE)
        end
    end

end

function ParticleTest:draw()
    lg.push("all")
    lg.setColor(GRAY_DARK)
    lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    lg.pop()

    lg.push("all")
    lg.translate(50,50)
    for i=1,#self.anims do
        self.anims[i]:draw()
        lg.setColor(RED)
        lg.circle("fill",0,0,1)
        lg.translate(50, 0)
    end
    lg.pop()

    lg.push("all")
    lg.translate(50,100)
    for _, system in ipairs(self.systems) do
        for _, data in ipairs(system) do
		    lg.setBlendMode(data.blendMode)
            lg.setShader(data.shader)
		    lg.draw(data.system, 0, 0)
	    end
        lg.setColor(RED)
        lg.circle("fill",0,0,1)
        lg.translate(50, 0)
    end
    lg.pop()
end

function ParticleTest:keypressed(key)

end

return ParticleTest