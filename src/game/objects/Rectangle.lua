local class = require('lib/middleclass/middleclass')
local Physical = require("src/game/objects/Physical")
local Rectangle = class('game.objects.Rectangle', Physical)

function Rectangle:initialize(world, x, y, width, height, type, isCollidable)
    Physical.initialize(self, world, x, y, width, height, type)
    self.isCollidable = isCollidable
    local cx, cy = self:getCenter()
    self.body = love.physics.newBody(self.world, cx, cy, type)
    self.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    Physical.registerPhysicalObject(self, self.body, self.shape, self.fixture)
     
    if self.isCollidable == "false" or self.isCollidable == false then
      self.fixture:setSensor(true)
    end
end

function Rectangle:getCenter()
  return self.x + (self.width / 2), self.y + (self.height / 2)
end

return Rectangle
