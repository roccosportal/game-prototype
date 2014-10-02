self = {}

local class = require('lib/middleclass/middleclass')
local KillArea = require("src/game/objects/KillArea")
local SavePoint = require("src/game/objects/SavePoint")
local Object = class.Object


local RADIUS = 14
local RESITUTION = 0.4
local MASS = 4
local JUMP_DECREASE = 800
local JUMP_SPEED = 400
local SIDE_SPEED = 350
local MAX_SIDE_SPEED = 180
local JUMP_REACTION = 100

function self.init(startPoint, world)
  
  self.groundFixture = nil
  self.onGround = true
  self.isJumping = false
  self.jumpReactionTimer = 0
  
  local x, y = startPoint:getCenter()
  
  -- the starting position marks the center of the ball
  -- we need to translate the position to the upper right corner
  x = x - RADIUS
  y = y - RADIUS
  self.image = love.graphics.newImage("gfx/player/player.png")
  self.savePoint = startPoint
  self.body = love.physics.newBody(world, x, y, "dynamic") 
  self.shape = love.physics.newCircleShape(RADIUS) 
  self.fixture = love.physics.newFixture(self.body, self.shape, MASS)
  self.fixture:setRestitution(RESITUTION) 
  self.fixture:setUserData("player")
  self.moveToSavePoint = false
  
  
  local function beginContact(fixture, contact)    
      for _, object in pairs(game.map.current.objects) do
        if object:containsFixture(fixture) then
          if object:isInstanceOf(KillArea) then
            self:kill()
            return nil
          elseif object:isInstanceOf(SavePoint) then
            game.player.setSavePoint(object)
            return nil
          end
          break
        end
      end 
      
      
      local x,y = contact:getNormal()
      if y < -0.6 and y > -1.2 then
        self.groundFixture = fixture
        self.onGround = true
        self.isJumping = false
      end
    
      -- forward collision to sound visualisations
      game.overlays.sounds.collision(contact, self.fixture, fixture)
  end

  local function endContact(fixture, contact)
      if self.groundFixture == fixture then
        self.groundFixture = nil
        self.onGround = false
        self.jumpReactionTimer = JUMP_REACTION
      end
  end
  
  game.contactEventManager.register(self.fixture, beginContact, endContact)

end

function self.update(dt)
  
  -- move the player only in the update method, because the body might be locked elsewhere
  if self.moveToSavePoint or love.keyboard.isDown("r") then
    local cx, cy = self.savePoint:getCenter()
    self.body:setX(cx)
    self.body:setY(cy)
    self.body:setLinearVelocity(0,0)
    self.body:setAngularVelocity(0)
    self.savePoint:playerSpawnsHere()
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

  if not love.keyboard.isDown("up") and self.isJumping == true and y < 0 then
    -- decrease jump speed
    self.body:applyForce(0, JUMP_DECREASE)
  end  
end

function self.getX()
  return self.body:getX()
end

function self.getY()
  return self.body:getY()
end

function self.getCenter()
    return self:getX() - RADIUS, self:getY() - RADIUS
end



function self.draw()
    love.graphics.setColor(255, 255, 255) 
    love.graphics.draw(self.image, self:getX(), self:getY(), self.body:getAngle(), 1, 1, RADIUS, RADIUS)
end

function self.setSavePoint(savePoint)
    self.savePoint = savePoint
end

function self.kill()
    game.overlays.damage.show()
    
    -- move the player only in the update method, because the body might be locked elsewhere
    self.moveToSavePoint = true

end

return self
