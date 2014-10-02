local STI = require("lib/sti")
local class = require ('lib/middleclass/middleclass')
local Object = class.Object
local KillArea = require("src/game/objects/KillArea")
local CoilSpring = require("src/game/objects/CoilSpring")
local SavePoint = require("src/game/objects/SavePoint")
local Dynamic = require("src/game/objects/Dynamic")

-- module

map = {}
map.current = nil
function map.create(path, world)
    local self = setmetatable({}, Map)
    self.dynamics = {
      objects = {}
    }
    self.objects = {}
    self.world = world
    self.startPoint = nil
    self.mapSTI = STI.new(path)

    self:initRopes()
    self:initSavePoints()
		self:initDynamics()
    self:initKillAreas()
    self:initCoilSprings()
    self.mapSTI:initWorldCollision(world)  
    map.current = self 
    return self
end

-- class starts here

Map = {}
Map.__index = Map

function Map:initDynamics()
  local function findSavePointById(id)
    local savePoint = nil
    if id ~= nil then
      for _, object in ipairs(self.objects) do
        if Object.isInstanceOf(object, SavePoint) and object.id == id then
          savePoint = object
          break
        end
      end
    end
    return savePoint
  end
  
  
  if self.mapSTI.layers["dynamic"] then
    for _, object in pairs(self.mapSTI.layers["dynamic"].objects) do
        local resetSavePoint = findSavePointById(object.properties.resetSavePoint)
        local dynamic = Dynamic:new(self.world, object.x, object.y, object.width, object.height, resetSavePoint)
        table.insert(self.objects, dynamic)
    end
    self.mapSTI:removeLayer("dynamic")
  end
end

function Map:initKillAreas()
  if self.mapSTI.layers["killAreas"] then
    for _,area in pairs(self.mapSTI.layers["killAreas"].objects) do      
        local killArea = KillArea:new(self.world, area.x, area.y, area.width, area.height, area.properties.isCollidable)
        table.insert(self.objects, killArea)
    end
    self.mapSTI:removeLayer("killAreas")
  end
end


function Map:initSavePoints()
  if self.mapSTI.layers["savePoints"] then
    local first = true
    for _,p in pairs(self.mapSTI.layers["savePoints"].objects) do      
        local savePoint = SavePoint:new(self.world, p.x, p.y, p.width, p.height, p.properties.id)
        
        if first or p.properties.isStart == "true" then
          -- use first save point as starting point or the one that is set to `isStart`
          first = false
          self.startPoint = savePoint
        end
        
        table.insert(self.objects, savePoint)
    end
    self.mapSTI:removeLayer("savePoints")
  
    
    
  end
end

function Map:initCoilSprings()
  if not self.mapSTI.layers["coilSprings"] then
    return
  end
  
  for _,object in pairs(self.mapSTI.layers["coilSprings"].objects) do
      local y = object.y + object.height - CoilSpring.HEIGHT -- use the bottom left corner as reference point
      local coilSpring = CoilSpring:new(self.world,object.x,y)
      coilSpring.debug = true
      table.insert(self.objects, coilSpring)
  end
  self.mapSTI:removeLayer("coilSprings")
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
    for _,object in ipairs(self.objects) do
      object:update(dt)
    end
  
end

function Map:draw()
    self.mapSTI:draw()
    for _,object in ipairs(self.objects) do
      object:draw()
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

return map  
