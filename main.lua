require("src/helpers")
require("lib/monocle/monocle")
game = require("src/game/game")

function love.load()
    Monocle.new({
       isActive=false,
       customPrinter=false,
       printColor = {51,51,51},
       debugToggle='.'   
    })
    Monocle.watch("FPS", function() return math.floor(1/love.timer.getDelta()) end)
		game.init()
end


function love.update( dt )
    game.update(dt)
    Monocle.update(dt)
	
end

function love.draw()
    game.draw()
	  Monocle.draw()
end

function love.resize(w, h)
    game.resize(w,h)
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
