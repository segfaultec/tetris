
local vector = require "lib.hump.vector-light"

---@class Particles
Particles = {}

local pAGE = 0
local pX = 1
local pY = 2
local pVX = 3
local pVY = 4
local pSTRIDE = 5

function Particles:start(root_x, root_y)
    self.root_x = root_x
    self.root_y = root_y

    for x=0,TETRIS_PIECE_SIZE-1,2 do
        for y=0,TETRIS_PIECE_SIZE-1,2 do

            local vX,vY = vector.div(TETRIS_PIECE_SIZE,x,y)
            vX,vY = vector.sub(.51,.51,vX,vY)
            vX,vY = vector.normalize(vX,vY)
            vX,vY = vector.mul(love.math.random(.10,.15),vX,vY)

            table.insert(self, love.math.random(
                F_ANIM_LINECLEAR_DURATION-F_ANIM_LINECLEAR_PARTICLE_RANGE,
                F_ANIM_LINECLEAR_DURATION
            )) -- age
            table.insert(self, x) -- x
            table.insert(self, y) -- y
            table.insert(self, vX) -- vx
            table.insert(self, vY) -- vy
        end
    end

end

function Particles:update()
    for i=1,#self,pSTRIDE do
        if self[i+pAGE] > 0 then
            self[i+pAGE] = self[i+pAGE] - 1
            self[i+pX] = self[i+pX] + self[i+pVX]
            self[i+pY] = self[i+pY] + self[i+pVY]
        end
    end
end

function Particles:draw()

    lg.push("all")
    lg.translate(self.root_x, self.root_y)

    for i=1,#self,pSTRIDE do

        if self[i] > 0 then

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