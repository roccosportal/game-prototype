local Rectangle = require("src/game/objects/Rectangle")
local KillArea = class('game.objects.KillArea', Rectangle)

function KillArea:initialize(world, x, y, width, height, isCollidable)
    Rectangle.initialize(self, world, x, y, width, height, "static", isCollidable)
end

return KillArea
