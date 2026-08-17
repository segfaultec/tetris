
local vector = require "lib.hump.vector-light"

---@class Particles
local Particle = {}

local pAGE = 0
local pX = 1
local pY = 2
local pVX = 3
local pVY = 4
local pLIFETIME = 5
local pCOLORSHIFT = 6
local pSTRIDE = 7

function Particle:start(root_x, root_y, col)
    self.root_x = root_x
    self.root_y = root_y
    self.col = col
    self.alive = 0

    for x=0,(TETRIS_PIECE_SIZE/2)-1,1 do
        for y=0,(TETRIS_PIECE_SIZE/2)-1,1 do

            local mid = (TETRIS_PIECE_SIZE-1) / 2

            self:emit(x*2 - mid, y*2 - mid)
        end
    end

end

function Particle:emit(x, y)

    local index = 0

    -- Look for slot with a dead particle
    for i=1,#self,pSTRIDE do
        if self[i+pAGE] == -1 then
            index = i
            break
        end
    end

    -- If we didn't find an open slot, add a new slot
    if index == 0 then
        index = #self+1
        for i=0,pSTRIDE-1 do
            table.insert(self, index+i, 0)
        end
    end

    -- Set up the particle in the chosen slot

    self[index+pAGE] = 0
    self[index+pLIFETIME] = love.math.random(
        F_ANIM_LINECLEAR_END_A,
        F_ANIM_LINECLEAR_END_B
    )
    self[index+pCOLORSHIFT] = random(-.05,.2)

    local angle,len = vector.toPolar(x+random(-.05,.05),y+random(-.05,.05))
    local xn, yn = vector.fromPolar(random(angle-.5,angle+.5), len*.15)

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
        if self[i+pAGE] >= 0 then

            self[i+pAGE] = self[i+pAGE] + 1

            if self[i+pAGE] > F_ANIM_LINECLEAR_START then
                local drag = .955
                self[i+pVX] = self[i+pVX] * drag
                self[i+pVY] = self[i+pVY] * drag

                self[i+pX] = self[i+pX] + self[i+pVX]
                self[i+pY] = self[i+pY] + self[i+pVY]
            end

            self.alive = self.alive + 1

            if self[i+pAGE] >= self[i+pLIFETIME] then
                self[i+pAGE] = -1
            end
        end
    end
end

function Particle:draw()

    lg.push("all")
    lg.translate(self.root_x, self.root_y)

    for i=1,#self,pSTRIDE do

        if self[i+pAGE] >= 0 then

            local tint
            if self[i+pAGE] < F_ANIM_LINECLEAR_START then
                tint = math.clamp(
                math.invlerp(0, F_ANIM_LINECLEAR_START, self[i+pAGE]),
                0, 1)
            else
                local remaining_age = self[i+pLIFETIME] - self[i+pAGE]
                tint = (math.clamp(remaining_age, 0, 15))/15
            end

            local colorshift = function (c)
                return math.clamp(c+self[i+pCOLORSHIFT], 0,1)
            end

            local col = {
                colorshift(self.col[1]),
                colorshift(self.col[2]),
                colorshift(self.col[3]),
                tint
            }

            lg.setColor(col)

            lg.rectangle("fill", self[i+pX], self[i+pY], 2, 2)
        end
    end
    lg.pop()

end

return Particle