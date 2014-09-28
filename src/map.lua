local STI = require("lib/sti")

Map = {}
Map.__index = Map
function Map.create(path, world)
    local self = setmetatable({}, Map)
    self.dynamics = {
      objects = {}
    }
    self.world = world
    self.player = {x = 0, y = 0}
    self.mapSTI = STI.new(path)

    self:initRopes()
		self:initDynamicLayer()
    self:initKillAreas()
    self:initSavePoints()
    self.mapSTI:initWorldCollision(world)    
    return self
end


function Map:initDynamicLayer()
  if self.mapSTI.layers["dynamic"] then
    self.dynamics = self.mapSTI.layers["dynamic"]
    for _,object in pairs(self.dynamics.objects) do
      if object.properties.isPlayer then
          -- use the center of the object as starting position
          self.player.x = object.x + object.width / 2
          self.player.y = object.y + object.height / 2
          self.dynamics.objects[_] = nil
      elseif object.shape == "rectangle" then
        object.body = love.physics.newBody(self.world, object.x + (object.width / 2), object.y + (object.height / 2), "dynamic")
        object.shape = love.physics.newRectangleShape(0, 0, object.width, object.height)
        object.fixture = love.physics.newFixture(object.body, object.shape, 5)
        
        -- body object should be used
        object.x = nil
        object.y = nil
        object.width = nil
        object.height = nil
      end
    end
    self.mapSTI:removeLayer("dynamic")
  end
end

function Map:initKillAreas()
  if self.mapSTI.layers["killAreas"] then
    
    
    
    local function setKillArea(area)
        local function contactFilter(fixture)
          -- nothing but player hits me
          if game.player.fixture ~= fixture then
            return false
          end
          return true
        end
        
        area.body = love.physics.newBody(self.world, area.x + (area.width / 2), area.y + (area.height / 2))
        area.shape = love.physics.newRectangleShape(0, 0, area.width, area.height)
        area.fixture = love.physics.newFixture(area.body, area.shape, 5)
        -- area.body:setActive(false) 
               
        -- body object should be used
        area.x = nil
        area.y = nil
        area.width = nil
        area.height = nil
        
        if area.properties.isCollidable ~= nil or area.properties.isCollidable then 
          game.contactEventManager:register(area.fixture, nil, nil, nil, nil, contactFilter)
        end
    end

    self.killAreas = self.mapSTI.layers["killAreas"].objects
    for _,area in pairs(self.killAreas) do
        setKillArea(area)
    end
    self.mapSTI:removeLayer("killAreas")
  end
end


function Map:initSavePoints()
  if self.mapSTI.layers["savePoints"] then
    
    local function setSavePoint(savePoint) 
      local function contactFilter(fixture)
        -- nothing hits me
        if game.player.fixture == fixture then
          game.player:setSavePoint(savePoint.body:getX(),savePoint.body:getY())
        end
        return false
      end
      
      savePoint.body = love.physics.newBody(self.world, savePoint.x + (savePoint.width / 2), savePoint.y + (savePoint.height / 2))
      savePoint.shape = love.physics.newRectangleShape(0, 0, savePoint.width, savePoint.height)
      savePoint.fixture = love.physics.newFixture(savePoint.body, savePoint.shape, 5)
      
      -- body object should be used
      savePoint.x = nil
      savePoint.y = nil
      savePoint.width = nil
      savePoint.height = nil
      
      game.contactEventManager:register(savePoint.fixture, nil, nil, nil, nil, contactFilter)
    end
    
    
  
    
    self.savePoints = self.mapSTI.layers["savePoints"].objects
    for _,savePoint in pairs(self.savePoints) do
        setSavePoint(savePoint)
    end
    self.mapSTI:removeLayer("savePoints")
  end
end


function Map:initRopes()
  self.ropes = {}
  local removeLayers = {}
  for _, layer in ipairs(self.mapSTI.layers) do
      if string.starts(layer.name, "rope") then
        local rope = {
          chains = {},
          joints = {}
        }
        
        local isFirst = true
        local lastChain = {}
        local mode = "static"
        for __, ropeChain in pairs(layer.objects) do
            	local chain = {}              
            	chain.body = love.physics.newBody( self.world, ropeChain.x, ropeChain.y, mode)
            	chain.shape = love.physics.newCircleShape( 2 )
            	chain.fixture = love.physics.newFixture( chain.body, chain.shape )
              table.insert(rope.chains, chain)
              
              if not isFirst then
                local a = math.abs(chain.body:getY() - lastChain.body:getY())
                local b = math.abs(chain.body:getX() - lastChain.body:getX())
                local disLength =  math.sqrt(math.pow(a,2) + math.pow(b, 2))
                                
                local joint = love.physics.newRopeJoint( lastChain.body, chain.body, lastChain.body:getX(), lastChain.body:getY(), chain.body:getX(), chain.body:getY(), disLength )
                
                table.insert(rope.joints, joint)
              else
                isFirst = false
                mode = "dynamic"
              end
              lastChain = chain
              
        end
        table.insert(self.ropes, rope)
        table.insert(removeLayers, _)
      end 
  end
  
  for _, i in pairs(removeLayers) do
    --logline(i)
    self.mapSTI:removeLayer(i)
  end
end




function Map:update(dt)
    self.mapSTI:update(dt)
    
  
end

function Map:draw()
    self.mapSTI:draw()
    love.graphics.setColor(50, 50, 50)
    for _,object in pairs(self.dynamics.objects) do
          love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
    end
    
    love.graphics.setColor( 0,0,0 )
    for _,rope in pairs(self.ropes) do
          local lastChain = nil
          for __, chain in pairs(rope.chains) do
            if lastChain ~= nil then
              local points = {}
              
              love.graphics.line(lastChain.body:getX(), lastChain.body:getY(), chain.body:getX(), chain.body:getY())
            end
            lastChain = chain
          end
    end
    -- for _,area in pairs(self.killAreas) do
    --       love.graphics.polygon("fill", area.body:getWorldPoints(area.shape:getPoints()))
    -- end
end

function Map:resize()
    self.mapSTI:resize()
end

function Map:getWorldSize()
  return self.mapSTI.width * self.mapSTI.tilewidth, self.mapSTI.height * self.mapSTI.tileheight
end

function Map:getPlayerStartingPosition()
  return self.player.x, self.player.y
end
  
  
