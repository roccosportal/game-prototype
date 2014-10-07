local Physical = class('game.objects.Physical')


function Physical:initialize(world, x, y, width, height, type)
    self.world = world
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.type = type
    self.debug = false
    self.physicalObjects = {}
end

function Physical:draw()
    if self.debug then
      love.graphics.setColor(255, 0, 0)
      for _, o in ipairs(self.physicalObjects) do
        love.graphics.polygon("line", o.body:getWorldPoints(o.shape:getPoints()))
      end
    end
end

function Physical:update(dt)
    
end


function Physical:registerPhysicalObject(body, shape, fixture)
    o = {
      body = body,
      shape = shape,
      fixture = fixture
    }
    table.insert(self.physicalObjects, o)
end

function Physical:containsFixture(fixture)
  for _, o in ipairs(self.physicalObjects) do
    if fixture == o.fixture then
      return true
    end
  end
  return false
end

return Physical
