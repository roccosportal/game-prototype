local self = {}


local MENU_STRINGS = {
    "START GAME", "EXIT"
}

function self.init()
    self.selection = 1
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.clear()
end

function self.update(dt)
  
end

function self.keypressed(key)
    if key == "down" then
        self.selection = self.selection + 1
    elseif key == "up" then
        self.selection = self.selection - 1
    end
    
    if self.selection > #MENU_STRINGS then
      self.selection = #MENU_STRINGS
    elseif self.selection < 1 then
      self.selection = 1
    end
    
    if key == "return" then
        if self.selection == #MENU_STRINGS then
          love.event.quit()
        end
        
        if self.selection == 1 then
            state = game
            state.init()
        end 
        
    end
end

function self.draw()
    love.graphics.setColor(0,0,0)
    --love.graphics.setFont(font.bold)
    for i=1,#MENU_STRINGS do
      if i == self.selection then
        love.graphics.print("*", 144, 86+i*13)
      end
      love.graphics.print(MENU_STRINGS[i], 152, 86+i*13)
    end
end

function self.resize(w, h)
  
end

return self
