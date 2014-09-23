Player = {}
Player.__index = Player

local RADIUS = 20

function Player.create(x,y, world)
  local self = setmetatable({}, Player)
  self.groundFixture = nil
  self.onGround = true
  
  -- the starting position marks the center of the ball
  -- we need to translate the position to the upper right corner
  x = x - RADIUS
  y = y - RADIUS
  
  self.body = love.physics.newBody(world, x, y, "dynamic") 
  self.shape = love.physics.newCircleShape(RADIUS) 
  self.fixture = love.physics.newFixture(self.body, self.shape, 1)
  self.fixture:setRestitution(0.4) 
  self.fixture:setUserData("player")
  
  local function beginContact(fixture, contact)
      local x,y = contact:getNormal()
      if y < -0.8 and y > -1.2 then
        self.groundFixture = fixture
        self.onGround = true
      end
      
      -- check if player hit a kill area
      for _, area in pairs(game.map.killAreas) do
        if fixture == area.fixture then
          logline("You are dead!")
        end 
      end
  end

  local function endContact(fixture, contact)
      if self.groundFixture == fixture then
        self.groundFixture = nil
        self.onGround = false
      end
  end
  
  game.contactEventManager:register(self.fixture, beginContact, endContact)
  return self
end

function Player:update(dt)
  local x, y = self.body:getLinearVelocity( )
  if love.keyboard.isDown("right") then
    if x < 200 then
      self.body:applyForce(200, 0)
    end

  elseif love.keyboard.isDown("left") then
    if x > -400 then
      self.body:applyForce(-200, 0)
    end
  end
  if love.keyboard.isDown("up") then
    if self.onGround and y > -400 then
      self.body:setLinearVelocity( x, -400)
    end
  elseif love.keyboard.isDown("down") then
      self.body:applyForce(0, 1000)
  end
end

function Player:getX()
  return self.body:getX()
end

function Player:getY()
  return self.body:getY()
end

function Player:getCenter()
    return self:getX() - RADIUS, self:getY() - RADIUS
end



function Player:draw()
    love.graphics.setColor(193, 47, 14) 
    love.graphics.circle("fill", self:getX(), self:getY(), RADIUS)
end
