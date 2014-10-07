class = require('lib/middleclass/middleclass')

require("src/helpers")
require("lib/monocle/monocle")
menu = require("src/menu/menu")
game = require("src/game/game")
levelSelection = require("src/level-selection/level-selection")

state = nil

function love.load()
    love.window.setMode(0, 0, {fullscreen = true} )
    
    state = menu
    Monocle.new({
       isActive=false,
       customPrinter=false,
       printColor = {51,51,51},
       debugToggle='.'   
    })
    Monocle.watch("FPS", function() return math.floor(1/love.timer.getDelta()) end)
		state.init()
end


function love.update( dt )
  state.update(dt)
  Monocle.update(dt)
	
end

function love.draw()
  
  state.draw()
  Monocle.draw()
end

function love.resize(w, h)
  state.resize(w,h)
end

function changeState(state)
  
end

function love.textinput(t)
    Monocle.textinput(t)
end

function love.keypressed(key)
    state.keypressed(key)
    Monocle.keypressed(key)
end


function logline(message)
	io.write ("\n[" .. love.timer.getTime() .. "]")
	log(message)
end

function log(message)
	io.write (message)
end
