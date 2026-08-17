--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
local particles = {x=0, y=0}

local image1 = LG.newImage("img/particles/circle.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 166)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("ellipse", 3.1704390048981, 3.1704390048981, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(0.2932057082653)
ps:setInsertMode("top")
ps:setLinearAcceleration(-0.032361656427383, 0, 0, 0)
ps:setLinearDamping(2.2507119178772, 2.1657872200012)
ps:setOffset(50, 50)
ps:setParticleLifetime(0.69001418352127, 0.69999998807907)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(true)
ps:setRotation(-0.42019671201706, 1.0636978149414)
ps:setSizes(0.01699691452086)
ps:setSizeVariation(0)
ps:setSpeed(45.060367584229, 23.934679031372)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(6.2831854820251)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=166, blendMode="add", shader=nil, texturePath="circle.png", texturePreset="circle", shaderPath="", shaderFilename="", x=0, y=0})

return particles
