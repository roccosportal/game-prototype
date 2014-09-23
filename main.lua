require("src/game")
require("src/sound-visualisation")
require("src/map")
require("src/player")
game.camera = require("src/camera")


function love.load()	
		-- love.window.setFullscreen(true)

	
		-- map:removeLayer(1)

		--collision = map:getCollisionMap("collision")

		love.physics.setMeter(64) --the height of a meter our worlds will be 64px
	  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
		
		game.map = Map.create("maps/test", world)
		-- map = sti.new("maps/test")
		-- dynamicLayer = map.layers["dynamic"]
		-- 
		-- collisionMap = map:initWorldCollision(world)


		local px, py = game.map:getPlayerStartingPosition()
		game.camera:setCenter(px, py)
		game.player = Player.create(px, py, world)
		
		local w, h = game.map:getWorldSize()
		fogCanvas = love.graphics.newCanvas()
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
	
end

function love.resize(w, h)
    game.map:resize(w, h)
end



function beginContact(a, b, coll)
    

		if b:getUserData() == "player" then
			game.player:beginContact(a, coll)
		end

		local x,y = coll:getPositions()
		local aX,aY = a:getBody():getLinearVelocity()
		local bX,bY = b:getBody():getLinearVelocity()


		strength = math.abs(aX) + math.abs(aY) + math.abs(bX) + math.abs(bY)
		if strength > 200 then
			game.soundVisualisations.new(x,y,strength)
		end
end

function endContact(a, b, coll)
		if b:getUserData() == "player" then
				game.player:endContact(a, coll)
		end
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)

end

function logline(message)
	io.write ("\n[" .. love.timer.getTime() .. "]")
	log(message)
end

function log(message)
	io.write (message)
end
