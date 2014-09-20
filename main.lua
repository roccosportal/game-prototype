require("src/game")
require("src/sound-visualisation")
local sti = require("lib/sti")

onGround = true
groundBody = nil

function love.load()
		love.window.setFullscreen(true)

		map = sti.new("maps/test")

		--collision = map:getCollisionMap("collision")

		love.physics.setMeter(64) --the height of a meter our worlds will be 64px
	  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
		collisionMap = map:enableCollision(world)

	  objects = {} -- table to hold all our physical objects

		objects.ball = {}
		objects.ball.body = love.physics.newBody(world, 30, 30, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
		objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
		objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
		objects.ball.fixture:setRestitution(0.4) --let the ball bounce
		objects.ball.fixture:setUserData("player")

		canvas = love.graphics.newCanvas(love.window.getWidth(), love.window.getHeight())
end


function love.update( dt )
		world:update(dt)
		map:update(dt)

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
end

function love.draw()
		map:draw()

  	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

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
		love.graphics.draw(canvas)
end

function love.resize(w, h)
    map:resize(w, h)
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
		game.soundVisualisations.new(x,y,strength)
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
