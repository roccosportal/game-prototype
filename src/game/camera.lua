-- http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
local camera = {}
local CameraShake = require("src/game/CameraShake")
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:init()
  camera.shake =  CameraShake:new(camera)
end

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

-- updates the camera and move it to the position where it should be
function camera:update(dt, x, y)
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()
  -- 
  local step = 100 * dt
  if self.x > x  then 
    if self.x - step > x then
      self.x = math.floor(self.x - step)
    else
      self.x = x
    end
  elseif self.x < x  then 
    if self.x + step < x then
      self.x = math.floor(self.x + step)
    else
      self.x = x
    end
  end
  
  if self.y > y  then 
    if self.y - step > y then
      self.y = math.floor(self.y - step)
    else
      self.y = y
    end
  elseif self.y < y  then 
    if self.y + step < y then
      self.y = math.floor(self.y + step)
    else
      self.y = y
    end
  end
  
  local border = 100
  if self.x + ww / 2 - border < x  then
      self.x = math.floor(x - ww / 2 + border)
  elseif self.x - ww / 2 + border > x then
      self.x = math.floor(x + ww / 2 - border)
  end
  
  if self.y + wh / 2 - border < y  then
      self.y = math.floor(y - wh / 2 + border)
  elseif self.y - wh / 2 + border > y then
      self.y = math.floor(y + wh / 2 - border)
  end
  
  camera.shake:update(dt)
end

function camera:setCenter(x,y)
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()
  local cx = math.floor(x - (ww / 2))
  local cy = math.floor(y - (wh / 2))
  self:setPosition(cx, cy)
end

return camera
