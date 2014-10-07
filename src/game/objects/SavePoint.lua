local Rectangle = require("src/game/objects/Rectangle")

local EventFull = require("src/mixins/EventFull")

local SavePoint = class('game.objects.SavePoint', Rectangle)
SavePoint:include(EventFull)


function SavePoint:initialize(world, x, y, width, height, id)
    Rectangle.initialize(self, world, x, y, width, height, "static", false)
    self.id = id
end

function SavePoint:playerSpawnsHere()
    self:fireEvent("onRespawn", {self})
end

return SavePoint
