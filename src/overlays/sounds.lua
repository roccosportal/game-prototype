require("src/overlays/sound")

local self = {}
self.list = {}

function self.init()
    self.canvas = love.graphics.newCanvas()
end


function self.collision(contact, a, b)
    local x,y = contact:getPositions()
    local aX,aY = a:getBody():getLinearVelocity()
    local bX,bY = b:getBody():getLinearVelocity()

    local strength = math.abs(aX) + math.abs(aY) + math.abs(bX) + math.abs(bY)
    if strength > 200 then
      self.new(x,y,strength)
    end
end

function self.new(x,y, strength)
    self.list[#self.list+1] = Sound.create(x,y, strength)
end

function self.update(dt)
  local destroy_list = {}

  for i,sound in pairs(self.list) do
      sound:update(dt)
      if sound:getState() == Sound.STATE.DEAD then
          destroy_list[i] = sound
      end
  end

  for i,sound in pairs(destroy_list) do
      self.list[i]=nil
  end

end

function self.draw()
  game.camera:set()
  -- draw white over layer and only make certain areas visible
  love.graphics.setCanvas(self.canvas)
  self.canvas:clear(255,255, 255, 255)
  love.graphics.setBlendMode("subtractive")
  for _,sound in pairs(self.list) do
      love.graphics.setColor(255, 255, 255, sound:getAlpha())
      love.graphics.circle("fill", sound:getX(), sound:getY(), sound:getRadius(), 200)
  end
  game.camera:unset()
  
  -- reset everything
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setCanvas()
  love.graphics.setBlendMode('alpha')
  
  love.graphics.draw(self.canvas)
end

return self
