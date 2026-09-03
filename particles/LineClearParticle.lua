local Particle = require "particles.Particle"
local vector = require "lib.hump.vector-light"

---@class LineClearParticle : Particle
local LineClearParticle = {
    pX = Particle.pSTRIDE,
    pY = Particle.pSTRIDE+1,
    pVX = Particle.pSTRIDE+2,
    pVY = Particle.pSTRIDE+3,
    pCOLORSHIFT = Particle.pSTRIDE+4,
    pSTRIDE = Particle.pSTRIDE+5,

    col = nil
}
setmetatable(LineClearParticle, {__index = Particle})

function LineClearParticle:impl_startsystem(args)
    self.col = args.col
    for x=0,(TETRIS_PIECE_SIZE/2)-1,1 do
        for y=0,(TETRIS_PIECE_SIZE/2)-1,1 do

            local mid = (TETRIS_PIECE_SIZE-1) / 2

            self:emit({x = x*2 - mid, y = y*2 - mid})
        end
    end
end

function LineClearParticle:impl_start(index, args)
    local x, y = args.x, args.y
    self[index+self.pAGE] = 0
    self[index+self.pLIFETIME] = love.math.random(
        F_ANIM_LINECLEAR_END_A,
        F_ANIM_LINECLEAR_END_B
    )
    self[index+self.pCOLORSHIFT] = random(-.05,.2)

    local angle,len = vector.toPolar(x+random(-.05,.05),y+random(-.05,.05))
    local xn, yn = vector.fromPolar(random(angle-.5,angle+.5), len*.15)

    self[index+self.pX] = x
    self[index+self.pY] = y
    self[index+self.pVX] = xn
    self[index+self.pVY] = yn
end

function LineClearParticle:impl_update(index)
    if self[index+self.pAGE] > F_ANIM_LINECLEAR_START then
        local drag = .955
        self[index+self.pVX] = self[index+self.pVX] * drag
        self[index+self.pVY] = self[index+self.pVY] * drag

        self[index+self.pX] = self[index+self.pX] + self[index+self.pVX]
        self[index+self.pY] = self[index+self.pY] + self[index+self.pVY]
    end
end

function LineClearParticle:impl_draw(index)
    local tint
    if self[index+self.pAGE] < F_ANIM_LINECLEAR_START then
        tint = math.clamp(
        math.invlerp(0, F_ANIM_LINECLEAR_START, self[index+self.pAGE]),
        0, 1)
    else
        local remaining_age = self[index+self.pLIFETIME] - self[index+self.pAGE]
        tint = (math.clamp(remaining_age, 0, 15))/15
    end

    local colorshift = function (c)
        return math.clamp(c+self[index+self.pCOLORSHIFT], 0,1)
    end

    local col = {
        colorshift(self.col[1]),
        colorshift(self.col[2]),
        colorshift(self.col[3]),
        math.clamp(tint-.25,0,1)
    }

    lg.setColor(col)

    lg.rectangle("fill", self[index+self.pX], self[index+self.pY], 2, 2)
end

return LineClearParticle