Sound = {}
Sound.__index = Sound


Sound.STATE ={}
Sound.STATE.CREATION = 1
Sound.STATE.DYING = 2
Sound.STATE.DEAD = 3

local EXPANDING_SPEED = 500
local RADIUS = 80
local MAX_RADIUS = 130
local STARTING_RADIUS = 40
local STRENGTH_IMPACT = 0.2


function Sound.create(x,y, strength)
  local self = setmetatable({}, Sound)
  self.x = x
  self.y = y
  self.radius = STARTING_RADIUS
  self.creationTime = love.timer.getTime()
  self.state = Sound.STATE.CREATION
  self.alpha = 255
  self.strength = strength
  return self
end

function Sound:update(dt)
    if self.state == Sound.STATE.CREATION   then
      -- check if the current radius is smaller than the radius it could reach
      -- if the strength impact is to big, MAX_RADIUS will stop it
      if self.radius < RADIUS + self.strength * STRENGTH_IMPACT and self.radius < MAX_RADIUS then
        self.radius = self.radius +  (500 * dt)
        if self.radius > MAX_RADIUS then
            self.radius = MAX_RADIUS
        end
      end
      if (love.timer.getTime() - self.creationTime ) > 4 then
          self.state = Sound.STATE.DYING
      end
    elseif self.state == Sound.STATE.DYING then
      if self.alpha > 0 then
          self.alpha = self.alpha  - ((256 - self.alpha) * dt)
      else
          self.alpha = 0
          self.state = Sound.STATE.DEAD
      end
    end
end

function Sound:getAlpha()
  return self.alpha
end


function Sound:getX()
  return self.x
end

function Sound:getY()
  return self.y
end

function Sound:getRadius()
  return self.radius
end

function Sound:getState()
  return self.state
end

function Sound:getStrength()
  return self.strength
end


return Sound
