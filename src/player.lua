Player = {}
Player.__index = Player

local RADIUS = 14
local RESITUTION = 0.4
local MASS = 4
local JUMP_DECREASE = 800
local JUMP_SPEED = 400
local SIDE_SPEED = 350
local MAX_SIDE_SPEED = 180
local JUMP_REACTION = 100

function Player.create(x,y, world)
  local self = setmetatable({}, Player)
  self.groundFixture = nil
  self.onGround = true
  self.isJumping = false
  self.jumpReactionTimer = 0
  -- the starting position marks the center of the ball
  -- we need to translate the position to the upper right corner
  x = x - RADIUS
  y = y - RADIUS
  
  self.savePoint = {x = x, y = y}
  self.body = love.physics.newBody(world, x, y, "dynamic") 
  self.shape = love.physics.newCircleShape(RADIUS) 
  self.fixture = love.physics.newFixture(self.body, self.shape, MASS)
  self.fixture:setRestitution(RESITUTION) 
  self.fixture:setUserData("player")
  self.moveToSavePoint = false
  
  
  local function beginContact(fixture, contact)
      for _, area in pairs(game.map.killAreas) do
        if area.fixture == fixture then
            self:kill()
            return nil
        end
      end 
      
      local x,y = contact:getNormal()
      if y < -0.6 and y > -1.2 then
        self.groundFixture = fixture
        self.onGround = true
        self.isJumping = false
      end
    
      -- forward collision to sound visualisations
      game.soundVisualisations.collision(contact, self.fixture, fixture)
  end

  local function endContact(fixture, contact)
      if self.groundFixture == fixture then
        self.groundFixture = nil
        self.onGround = false
        self.jumpReactionTimer = JUMP_REACTION
      end
  end
  
  game.contactEventManager:register(self.fixture, beginContact, endContact)
  return self
end

function Player:update(dt)
  -- move the player only in the update method, because the body might be locked elsewhere
  if self.moveToSavePoint then
    self.body:setX(self.savePoint.x)
    self.body:setY(self.savePoint.y)
    self.body:setLinearVelocity(0,0)
    self.body:setAngularVelocity(0)
    game.map:resetObjectForSavePoint(self.savePoint.id)
    self.moveToSavePoint = false
  end
  
  self.jumpReactionTimer = self.jumpReactionTimer - 1000 * dt
  
  local x, y = self.body:getLinearVelocity( )
  
  if love.keyboard.isDown("up") then
    if(self.onGround == true or self.jumpReactionTimer > 0) then
      self.jumpReactionTimer = 0
      self.onGround = false
      self.isJumping = true
      self.body:setLinearVelocity( x, -JUMP_SPEED)
      y = -JUMP_SPEED
    end
    
  elseif love.keyboard.isDown("down") then
      self.body:applyForce(0, 1000)
  end

  if love.keyboard.isDown("right") then
    --logline(x)
    if x < 0 then
      self.body:setLinearVelocity(0, y) 
      self.body:setAngularVelocity(0)
    else
      self.body:applyForce(SIDE_SPEED, 0)
    end
    

    if x > MAX_SIDE_SPEED then
      self.body:setLinearVelocity(MAX_SIDE_SPEED, y)
    end
  elseif love.keyboard.isDown("left") then
    if x > 0 then
      
      self.body:setLinearVelocity(0, y)
      self.body:setAngularVelocity(0)
    else
      self.body:applyForce(-SIDE_SPEED, 0)  
    end
    
    
    if x < -MAX_SIDE_SPEED then
      self.body:setLinearVelocity(-MAX_SIDE_SPEED, y)
    end
  end

  --logline(self.body:getLinearVelocity( ))



  if not love.keyboard.isDown("up") and self.isJumping == true and y < 0 then
    -- decrease jump speed
    self.body:applyForce(0, JUMP_DECREASE)
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

function Player:setSavePoint(x, y, id)
    self.savePoint = {x = x, y = y, id = id}
end

function Player:kill()
    game.overlays.damage:show()
    
    -- move the player only in the update method, because the body might be locked elsewhere
    self.moveToSavePoint = true

end
