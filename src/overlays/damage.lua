local self = {}

local ALPHA_DECREASING_SPEED = 100
local ALPHA_START = 200

function self.init()
  self.isVisible = false
  self.duration = 0
  self.alpha = 0
  self.canvas = love.graphics.newCanvas()
end

function self.update(dt)
  if self.isVisible then
    self.alpha = self.alpha - dt * ALPHA_DECREASING_SPEED
    if self.alpha < 0 then
      self.isVisible = false
    end
  end
end

function self.show()
  self.isVisible = true
  self.alpha = ALPHA_START
end

function self.draw()
  if self.isVisible then
      self.canvas:clear(255, 0, 0, self.alpha)
      love.graphics.draw(self.canvas)
  end
end

return self
