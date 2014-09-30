require("src/game")
require("src/sound-visualisation")
require("src/map")
require("src/player")
require("src/contact-event-manager")
require("src/overlays/damage")
require("lib/monocle/monocle")
game.camera = require("src/camera")

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end




function love.load()
    Monocle.new({
        isActive=false,          -- Whether the debugger is initially active
       customPrinter=false,    -- Whether Monocle prints status messages to the output
       printColor = {51,51,51},-- Color to print with
       debugToggle='.'   
    })
    Monocle.watch("FPS", function() return math.floor(1/love.timer.getDelta()) end)
		-- love.window.setFullscreen(true)

		
		-- map:removeLayer(1)

		--collision = map:getCollisionMap("collision")

		love.physics.setMeter(64) --the height of a meter our worlds will be 64px
	  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	
	
	 	game.contactEventManager = ContactEventManager.create(world)
		game.contactEventManager:onBeginContact(beginContact)
		
		game.map = Map.create("maps/test", world)
		-- map = sti.new("maps/test")
		-- dynamicLayer = map.layers["dynamic"]
		-- 
		-- collisionMap = map:initWorldCollision(world)


		local px, py = game.map:getPlayerStartingPosition()
		game.camera:setCenter(px, py)
		-- game.camera.rotation = 0.05
		game.player = Player.create(px, py, world)
    Monocle.watch("onGround", function() return tostring(game.player.onGround) end)
		
		local w, h = game.map:getWorldSize()
		fogCanvas = love.graphics.newCanvas()
		
		game.overlays = {}
		game.overlays.damage = DamageOverlay.create()
end


function love.update( dt )
  
		world:update(dt)
		game.map:update(dt)

		game.player:update(dt)  

		game.soundVisualisations.update(dt)
		
		
		-- try center camera at player
		local ww = love.graphics.getWidth()
		local wh = love.graphics.getHeight()
		
		local x, y = game.player:getCenter()
		x =  math.floor(x - ww / 2)
		y =  math.floor(y - wh / 2)

		game.camera:update(dt, x, y)
		
	  game.overlays.damage:update(dt)
    Monocle.update()
	
end

function love.draw()
		
	
		
		love.graphics.setCanvas()
		
		game.camera:set()
		
		love.graphics.setBackgroundColor(255, 255, 255)
		love.graphics.clear()
		
		
		game.map:draw()
  	
		game.player:draw()
		
		-- draw white over layer and only make certain areas visible
		
		love.graphics.setCanvas(fogCanvas)
	  fogCanvas:clear(255,255, 255, 255)
	  love.graphics.setBlendMode("subtractive")
		for _,soundVisualisation in pairs(game.soundVisualisations.list) do
				love.graphics.setColor(255, 255, 255, soundVisualisation:getAlpha())
				love.graphics.circle("fill", soundVisualisation:getX(), soundVisualisation:getY(), soundVisualisation:getRadius(), 200)
		end
		love.graphics.setColor(255, 255, 255, 255)
		
		love.graphics.setCanvas()
		love.graphics.setBlendMode('alpha')
		
		game.camera:unset()
		
		love.graphics.draw(fogCanvas)
		
		game.overlays.damage:draw()
	  Monocle.draw()
end

function love.resize(w, h)
    game.map:resize(w, h)
end

function beginContact(a, b, contact)
	  -- if player do nothing
		if a ~= game.player.fixture and b ~= game.player.fixture then
			-- forward collision to sound visualisations
			game.soundVisualisations.collision(contact, a, b)
		end	
end

function love.textinput(t)
    Monocle.textinput(t)
end

function love.keypressed(text)
    Monocle.keypressed(text)
end


function logline(message)
	io.write ("\n[" .. love.timer.getTime() .. "]")
	log(message)
end

function log(message)
	io.write (message)
end
