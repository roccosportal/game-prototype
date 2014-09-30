require("lib/monocle/monocle")
game = require("src/game/game")





function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end




function love.load()
    Monocle.new({
       isActive=false,
       customPrinter=false,
       printColor = {51,51,51},
       debugToggle='.'   
    })
    Monocle.watch("FPS", function() return math.floor(1/love.timer.getDelta()) end)
		love.physics.setMeter(64)
    
	  world = love.physics.newWorld(0, 9.81*64, true)
	   
	 	game.contactEventManager.init(world)
		game.contactEventManager.onBeginContact(beginContact)
		
		game.map = Map.create("maps/test", world)
    
    -- create player 
		local px, py = game.map:getPlayerStartingPosition()
		game.camera:setCenter(px, py)
		game.player.init(px, py, world)
    Monocle.watch("onGround", function() return tostring(game.player.onGround) end)
    

		
		game.overlays.sounds.init()
	
		game.overlays.damage.init()
end


function love.update( dt )
		world:update(dt)
		game.map:update(dt)
		game.player.update(dt)  
		game.overlays.sounds.update(dt)
		
		-- try center camera at player
		local ww = love.graphics.getWidth()
		local wh = love.graphics.getHeight()
		local x, y = game.player.getCenter()
		x =  math.floor(x - ww / 2)
		y =  math.floor(y - wh / 2)

		game.camera:update(dt, x, y)
    
	  game.overlays.damage.update(dt)
    Monocle.update()
	
end

function love.draw()
		love.graphics.setCanvas()
    
		game.camera:set()
    
		love.graphics.setBackgroundColor(255, 255, 255)
		love.graphics.clear()
		game.map:draw()
		game.player.draw()
		
    game.camera:unset()
    
    game.overlays.sounds.draw()
		game.overlays.damage.draw()
	  Monocle.draw()
end

function love.resize(w, h)
    game.map:resize(w, h)
end

function beginContact(a, b, contact)
	  -- if player do nothing
		if a ~= game.player.fixture and b ~= game.player.fixture then
			-- forward collision to sound visualisations
			game.overlays.sounds.collision(contact, a, b)
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
