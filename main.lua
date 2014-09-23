require("src/game")
require("src/sound-visualisation")
require("src/map")
game.camera = require("src/camera")


onGround = true
groundBody = nil

function love.load()
		print(_VERSION)
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

	  objects = {} -- table to hold all our physical objects

		objects.ball = {}
		objects.ball.body = love.physics.newBody(world, 30, 30, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
		objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
		objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
		objects.ball.fixture:setRestitution(0.4) --let the ball bounce
		objects.ball.fixture:setUserData("player")

		local w, h = game.map:getWorldSize()
		canvas = love.graphics.newCanvas(w, h)
end


function love.update( dt )
		world:update(dt)
		game.map:update(dt)

		x, y = objects.ball.body:getLinearVelocity( )

  	if love.keyboard.isDown("right") then
			if x < 200 then
	    	objects.ball.body:applyForce(200, 0)
			end

  	elseif love.keyboard.isDown("left") then
			if x > -400 then
	    	objects.ball.body:applyForce(-200, 0)
			end
		end
		if love.keyboard.isDown("up") then
			if onGround and y > -400 then
				objects.ball.body:setLinearVelocity( x, -400)
			end
		elseif love.keyboard.isDown("down") then
				objects.ball.body:applyForce(0, 1000)
	  end

		game.soundVisualisations.update(dt)
		
		
		-- center camera
		local ww = love.graphics.getWidth()
		local wh = love.graphics.getHeight()
		local cx = math.floor(objects.ball.body:getX() - (ww / 2) - objects.ball.shape:getRadius())
		local cy = math.floor(objects.ball.body:getY() - (wh / 2) - objects.ball.shape:getRadius())
		
		local step = 100 * dt
		if game.camera.x > cx  then 
			if game.camera.x - step > cx then
				game.camera.x = math.floor(game.camera.x - step)
			else
				game.camera.x = cx
			end
		elseif game.camera.x < cx  then 
			if game.camera.x + step < cx then
				game.camera.x = math.floor(game.camera.x + step)
			else
				game.camera.x = cx
			end
		end
		
		if game.camera.y > cy  then 
			if game.camera.y - step > cy then
				game.camera.y = math.floor(game.camera.y - step)
			else
				game.camera.y = cy
			end
		elseif game.camera.y < cy  then 
			if game.camera.y + step < cy then
				game.camera.y = math.floor(game.camera.y + step)
			else
				game.camera.y = cy
			end
		end
		
		local border = 100
		if game.camera.x + ww / 2 - border < cx  then
				game.camera.x = math.floor(cx - ww / 2 + border)
		elseif game.camera.x - ww / 2 + border > cx then
				game.camera.x = math.floor(cx + ww / 2 - border)
		end
		
		if game.camera.y + wh / 2 - border < cy  then
				game.camera.y = math.floor(cy - wh / 2 + border)
		elseif game.camera.y - wh / 2 + border > cy then
				game.camera.y = math.floor(cy + wh / 2 - border)
		end
		
		
end

function love.draw()
		game.camera:set()
		game.map:draw()

  	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
		game.camera:unset()
		-- draw white over layer and only make certain areas visible
		love.graphics.setCanvas(canvas)
	  canvas:clear(255,255, 255, 250)
	  love.graphics.setBlendMode("subtractive")
		for _,soundVisualisation in pairs(game.soundVisualisations.list) do
				love.graphics.setColor(255, 255, 255, soundVisualisation:getAlpha())
				love.graphics.circle("fill", soundVisualisation:getX(), soundVisualisation:getY(), soundVisualisation:getRadius(), 200)
		end
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setCanvas()
		love.graphics.setBlendMode('alpha')
		
		game.camera:set()
		love.graphics.draw(canvas)
		game.camera:unset()
		
end

function love.resize(w, h)
    game.map:resize(w, h)
end



function beginContact(a, b, coll)
    local x,y = coll:getNormal()

		if b:getUserData() == "player" and y < -0.8 and y > -1.2 then
			groundBody = a
			onGround = true
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
		if b:getUserData() == "player"  and groundBody == a then
			groundBody = nil
			onGround = false
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
