SoundVisualisation = {}
SoundVisualisation.__index = SoundVisualisation


local STATE ={}
STATE.CREATION = 1
STATE.DYING = 2
STATE.DEAD = 3

local EXPANDING_SPEED = 500
local RADIUS = 80
local MAX_RADIUS = 130
local STARTING_RADIUS = 40
local STRENGTH_IMPACT = 0.2


function SoundVisualisation.create(x,y, strength)
  local self = setmetatable({}, SoundVisualisation)
  self.x = x
  self.y = y
  self.radius = STARTING_RADIUS
  self.creationTime = love.timer.getTime()
  self.state = STATE.CREATION
  self.alpha = 255
  self.strength = strength
  return self
end

function SoundVisualisation:update(dt)
    if self.state == STATE.CREATION   then
      -- check if the current radius is smaller than the radius it could reach
      -- if the strength impact is to big, MAX_RADIUS will stop it
      if self.radius < RADIUS + self.strength * STRENGTH_IMPACT and self.radius < MAX_RADIUS then
        self.radius = self.radius +  (500 * dt)
        if self.radius > MAX_RADIUS then
            self.radius = MAX_RADIUS
        end
      end
      if (love.timer.getTime() - self.creationTime ) > 4 then
          self.state = STATE.DYING
      end
    elseif self.state == STATE.DYING then
      if self.alpha > 0 then
          self.alpha = self.alpha  - ((256 - self.alpha) * dt)
      else
          self.alpha = 0
          self.state = STATE.DEAD
      end
    end
end

function SoundVisualisation:getAlpha()
  return self.alpha
end


function SoundVisualisation:getX()
  return self.x
end

function SoundVisualisation:getY()
  return self.y
end

function SoundVisualisation:getRadius()
  return self.radius
end

function SoundVisualisation:getState()
  return self.state
end

function SoundVisualisation:getStrength()
  return self.strength
end



game.soundVisualisations = {}
game.soundVisualisations.list = {}


function game.soundVisualisations.new(x,y, strength)
    -- table.insert(game.soundVisualisations.list, SoundVisualisation.create(x,y))
     -- logline( "Adding number " .. #game.soundVisualisations.list+1)
    game.soundVisualisations.list[#game.soundVisualisations.list+1] = SoundVisualisation.create(x,y, strength)

end

function game.soundVisualisations.update(dt)
  -- if #game.soundVisualisations > 20 then
  --     logline ("clearing sounds")
  --     for k,v in pairs(game.soundVisualisations.list) do game.soundVisualisations.list[k]=nil end
  -- end

  local destroy_list = {}

  for i,soundVisualisation in pairs(game.soundVisualisations.list) do
      soundVisualisation:update(dt)
      if soundVisualisation:getState() == STATE.DEAD then
          destroy_list[i] = soundVisualisation
      end
  end

  for i,soundVisualisation in pairs(destroy_list) do
      game.soundVisualisations.list[i]=nil
      -- logline( "Destroying number " .. i)
  end

end
