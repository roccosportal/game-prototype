local self = {}

require("src/game/map")
self.player = require("src/game/player")
self.contactEventManager = require("src/game/contact-event-manager")

self.overlays = require("src/game/overlays/overlays")
self.camera = require("src/game/camera")

return self
