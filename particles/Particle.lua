---@class Particle
local Particle = {
    pAGE = 0,
    pLIFETIME = 1,

    pSTRIDE = 2,

    root_x = 0,
    root_y = 0,
    alive = 0
}

function Particle:start(root_x, root_y, args)
    self.root_x, self.root_y = root_x, root_y
    self.alive = 0

    self:impl_startsystem(args)
end

function Particle:update()
    self.alive = 0
    for i=1,#self,self.pSTRIDE do
        if self[i+self.pAGE] >= 0 then

            self[i+self.pAGE] = self[i+self.pAGE] + 1

            self.alive = self.alive + 1

            self:impl_update(i)

            if self[i+self.pAGE] >= self[i+self.pLIFETIME] then
                self[i+self.pAGE] = -1
            end
        end
    end
end

function Particle:emit(...)
    local index = 0

    -- Look for slot with a dead particle
    for i=1,#self,self.pSTRIDE do
        if self[i+self.pAGE] == -1 then
            index = i
            break
        end
    end

    -- If we didn't find an open slot, add a new slot
    if index == 0 then
        index = #self+1
        for i=0,self.pSTRIDE-1 do
            table.insert(self, index+i, 0)
        end
    end

    -- Set up the particle in the chosen slot

    self[index+self.pAGE] = 0
    self[index+self.pLIFETIME] = 60 -- placeholder lifetime, should be overridden by child

    self:impl_start(index, ...)
end

function Particle:draw()
    lg.push("transform")
    lg.translate(self.root_x, self.root_y)
    for i=1,#self,self.pSTRIDE do
        if self[i+self.pAGE] >= 0 then
            self:impl_draw(i)
        end
    end
    lg.pop()
end

function Particle:count_alive()
    return self.alive
end

function Particle:count_slots()
    return #self / self.pSTRIDE
end

function Particle:impl_startsystem(args) end
function Particle:impl_start(index, args) end
function Particle:impl_update(index) end
function Particle:impl_draw(index) end

return Particle