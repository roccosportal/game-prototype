local class = require('lib/middleclass/middleclass')
local Area = require("src/game/objects/Area")
local KillArea = class('game.objects.KillArea', Area)

function KillArea:initialize(world, x, y, width, height, isCollidable)
    Area.initialize(self, world, x, y, width, height, isCollidable)
end

return KillArea
