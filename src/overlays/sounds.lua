require("src/overlays/sound")

sounds = {}
sounds.list = {}

function sounds.init()
    sounds.canvas = love.graphics.newCanvas()
end


function sounds.collision(contact, a, b)
    local x,y = contact:getPositions()
    local aX,aY = a:getBody():getLinearVelocity()
    local bX,bY = b:getBody():getLinearVelocity()

    local strength = math.abs(aX) + math.abs(aY) + math.abs(bX) + math.abs(bY)
    if strength > 200 then
      sounds.new(x,y,strength)
    end
end

function sounds.new(x,y, strength)
    sounds.list[#sounds.list+1] = Sound.create(x,y, strength)
end

function sounds.update(dt)
  local destroy_list = {}

  for i,sound in pairs(sounds.list) do
      sound:update(dt)
      if sound:getState() == Sound.STATE.DEAD then
          destroy_list[i] = sound
      end
  end

  for i,sound in pairs(destroy_list) do
      sounds.list[i]=nil
  end

end

function sounds.draw()
  game.camera:set()
  -- draw white over layer and only make certain areas visible
  love.graphics.setCanvas(sounds.canvas)
  sounds.canvas:clear(255,255, 255, 255)
  love.graphics.setBlendMode("subtractive")
  for _,sound in pairs(sounds.list) do
      love.graphics.setColor(255, 255, 255, sound:getAlpha())
      love.graphics.circle("fill", sound:getX(), sound:getY(), sound:getRadius(), 200)
  end
  game.camera:unset()
  
  -- reset everything
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setCanvas()
  love.graphics.setBlendMode('alpha')
  
  love.graphics.draw(sounds.canvas)
end

return sounds
