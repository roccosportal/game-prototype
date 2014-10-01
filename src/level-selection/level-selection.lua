local self = {}

local DIR = "maps"

function self.init()
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.clear()
    
    self.selection = 1
    local maps = love.filesystem.getDirectoryItems( DIR )
    self.maps = {}
    for _, map in pairs(maps) do
      if string.ends(map, ".lua") then
        table.insert(self.maps, string.sub(map,1,#map - 4))
      end
    end
    
end

function self.update(dt)
  
end

function self.keypressed(key)
    if key == "down" then
        self.selection = self.selection + 1
      
    elseif key == "up" then
        self.selection = self.selection - 1
    elseif key == "return" then
        game.init(DIR .. "/" .. self.maps[self.selection])
        state = game
    elseif key == "escape" then
        state = menu
    end
    
    if self.selection > #self.maps then
      self.selection = #self.maps
    elseif self.selection < 1 then
      self.selection = 1
    end
end

function self.draw()
    love.graphics.setColor(0,0,0)
    for i=1,#self.maps do
      if i == self.selection then
        love.graphics.print("*", 144, 86+i*13)
      end
      love.graphics.print(self.maps[i], 152, 86+i*13)
    end
end

function self.resize(w, h)
  
end

return self
