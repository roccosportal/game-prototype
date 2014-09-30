local self = {}

require("src/game/map")
require("src/game/player")
require("src/game/contact-event-manager")

self.overlays = require("src/game/overlays/overlays")
self.camera = require("src/game/camera")

return self
