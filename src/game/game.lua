self = {}

require("src/game/map")
require("src/game/player")
require("src/game/contact-event-manager")

self.overlays = {}
self.overlays.sounds = require("src/game/overlays/sounds")
self.overlays.damage = require("src/game/overlays/damage")
self.camera = require("src/game/camera")

return self
