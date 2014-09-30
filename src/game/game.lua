local self = {}

self.map = require("src/game/map")
self.player = require("src/game/player")
self.contactEventManager = require("src/game/contact-event-manager")

self.overlays = require("src/game/overlays/overlays")
self.camera = require("src/game/camera")


function self.init()
    love.physics.setMeter(64)
    
    world = love.physics.newWorld(0, 9.81*64, true)
     
    self.contactEventManager.init(world)
    self.contactEventManager.onBeginContact(beginContact)
    
    self.map.create("maps/test", world)
    
    -- create player 
    local px, py = self.map.current:getPlayerStartingPosition()
    self.camera:setCenter(px, py)
    self.player.init(px, py, world)
    Monocle.watch("onGround", function() return tostring(game.player.onGround) end)
    
    self.overlays.sounds.init()
  
    self.overlays.damage.init()
end

function self.update(dt)
    world:update(dt)
    self.map.current:update(dt)
    self.player.update(dt)  
    self.overlays.sounds.update(dt)
    
    -- try center camera at player
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local x, y = self.player.getCenter()
    x =  math.floor(x - ww / 2)
    y =  math.floor(y - wh / 2)

    self.camera:update(dt, x, y)
    
    self.overlays.damage.update(dt)
end

function self.draw()
    love.graphics.setCanvas()
    
    self.camera:set()
    
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.clear()
    self.map.current:draw()
    self.player.draw()
    
    self.camera:unset()
    
    self.overlays.sounds.draw()
    self.overlays.damage.draw()
end 

function self.resize(w, h)
    self.map.current:resize(w, h)
end

function beginContact(a, b, contact)
    -- if player do nothing
    if a ~= game.player.fixture and b ~= game.player.fixture then
      -- forward collision to sound visualisations
      game.overlays.sounds.collision(contact, a, b)
    end	
end

function self.keypressed(key)
    if key == "escape" then
        menu.enableContinue()
        state = menu
    end
end

return self
