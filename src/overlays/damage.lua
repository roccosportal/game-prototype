DamageOverlay = {}
DamageOverlay.__index = DamageOverlay


local ALPHA_DECREASING_SPEED = 100
local ALPHA_START = 200

function DamageOverlay.create()
  local self = setmetatable({}, DamageOverlay)
  
  self.isVisible = false
  self.duration = 0
  self.alpha = 0
  self.canvas = love.graphics.newCanvas()
  
  
  return self
end

function DamageOverlay:update(dt)
  if self.isVisible then
    self.alpha = self.alpha - dt * ALPHA_DECREASING_SPEED
    if self.alpha < 0 then
      self.isVisible = false
    end
  end
end

function DamageOverlay:show()
  self.isVisible = true
  self.alpha = ALPHA_START
end

function DamageOverlay:draw()
  if self.isVisible then
      self.canvas:clear(255, 0, 0, self.alpha)
      love.graphics.draw(self.canvas)
  end
end
