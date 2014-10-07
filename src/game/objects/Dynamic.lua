local Rectangle = require("src/game/objects/Rectangle")


local Dynamic = class('game.objects.Dynamic', Rectangle)


function Dynamic:initialize(world, x, y, width, height, resetSavePoint)
    Rectangle.initialize(self, world, x, y, width, height, "dynamic", true)
    self.resetSavePoint = resetSavePoint
    if self.resetSavePoint ~= nil then 
      self.resetSavePoint:addEventListener("onRespawn", function() self:reset() end)
    end
    self.startPosition = {
        x = x,
        y = y
    }
end

function Dynamic:draw()
    love.graphics.setColor(50, 50, 50)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Dynamic:reset()
    self.body:setActive(false)
    self.body:setLinearVelocity(0, 0)
    self.body:setAngularVelocity(0)
    self.body:setX(self.startPosition.x)
    self.body:setY(self.startPosition.y)
    self.body:setAngle(0)
    self.body:setActive(true)
end

return Dynamic
