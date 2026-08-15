
local vector = require "lib.hump.vector-light"

---@class Particles
local Particle = {}

local pAGE = 0
local pX = 1
local pY = 2
local pVX = 3
local pVY = 4
local pSTRIDE = 5

function Particle:start(root_x, root_y)
    self.root_x = root_x
    self.root_y = root_y
    self.alive = 0

    -- for x=0,TETRIS_PIECE_SIZE-1,2 do
    --     for y=0,TETRIS_PIECE_SIZE-1,2 do

    --         local vX,vY = vector.div(TETRIS_PIECE_SIZE,x,y)
    --         vX,vY = vector.sub(.51,.51,vX,vY)
    --         vX,vY = vector.normalize(vX,vY)
    --         vX,vY = vector.mul(love.math.random(.10,.15),vX,vY)

    --         table.insert(self, love.math.random(
    --             F_ANIM_LINECLEAR_DURATION-F_ANIM_LINECLEAR_PARTICLE_RANGE,
    --             F_ANIM_LINECLEAR_DURATION
    --         )) -- age
    --         table.insert(self, x) -- x
    --         table.insert(self, y) -- y
    --         table.insert(self, vX) -- vx
    --         table.insert(self, vY) -- vy
    --     end
    -- end

end

function Particle:emit()

    local index = 0

    -- Look for slot with a dead particle
    for i=1,#self,pSTRIDE do
        if self[i+pAGE] == 0 then
            index = i
            break
        end
    end

    -- If we didn't find an open slot, add a new slot
    if index == 0 then
        index = #self+1
        for i=1,pSTRIDE do
            table.insert(self, index+i-1, 0)
        end
    end

    -- Set up the particle in the chosen slot
    self[index+pAGE] = love.math.random(
        F_ANIM_LINECLEAR_DURATION-F_ANIM_LINECLEAR_PARTICLE_RANGE,
        F_ANIM_LINECLEAR_DURATION
    )

    local x = love.math.random(-2,1)*2 + .5
    local y = love.math.random(-2,1)*2 + .5

    local angle,len = vector.toPolar(x,y)

    local xn, yn = vector.fromPolar(random(angle-.5,angle+.5), len*.2)

    self[index+pX] = x
    self[index+pY] = y
    self[index+pVX] = xn
    self[index+pVY] = yn

end

function Particle:count_alive()
    return self.alive
end

function Particle:count_slots()
    return #self / pSTRIDE
end

function Particle:update()
    self.alive = 0
    for i=1,#self,pSTRIDE do
        if self[i+pAGE] > 0 then

            self[i+pAGE] = self[i+pAGE] - 1

            local drag = .955
            self[i+pVX] = self[i+pVX] * drag
            self[i+pVY] = self[i+pVY] * drag

            self[i+pX] = self[i+pX] + self[i+pVX]
            self[i+pY] = self[i+pY] + self[i+pVY]
            self.alive = self.alive + 1
        end
    end
end

function Particle:draw()

    lg.push("all")
    lg.translate(self.root_x, self.root_y)

    for i=1,#self,pSTRIDE do

        if self[i+pAGE] > 0 then

            local tint = (math.clamp(self[i+pAGE], 0, 15))/15

            local col = {
                WHITE[1], WHITE[2], WHITE[3], tint
            }

            lg.setColor(col)

            lg.rectangle("fill", self[i+pX], self[i+pY], 2, 2)
        end
    end
    lg.pop()

end

return Particle