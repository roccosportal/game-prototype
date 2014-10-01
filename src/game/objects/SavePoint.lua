local class = require('lib/middleclass/middleclass')
local Area = require("src/game/objects/Area")
local SavePoint = class('game.objects.SavePoint', Area)

function SavePoint:initialize(world, x, y, width, height, id)
    Area.initialize(self, world, x, y, width, height, false)
    self.id = id
end

return SavePoint
