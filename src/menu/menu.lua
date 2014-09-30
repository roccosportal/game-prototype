local self = {}


local MENU_STRINGS = {
    "CONTINUE", "NEW GAME", "EXIT"
}

function self.init()
    self.showContinue = false
    self.selection = 2
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
        if self.selection == 1 and self.showContinue == false then
          self.selection = 2
        end
    elseif key == "return" then
        if self.selection == #MENU_STRINGS then
            love.event.quit()
        elseif self.selection == 1 then
            state = game
        elseif self.selection == 2 then
            state = game
            state.init()
        end
    elseif key == "escape" and self.showContinue == true then
        state = game
    end
    
    if self.selection > #MENU_STRINGS then
      self.selection = #MENU_STRINGS
    elseif self.selection < 1 then
      self.selection = 1
    end
    
  
  
end

function self.draw()
    love.graphics.setColor(0,0,0)
    --love.graphics.setFont(font.bold)
    for i=1,#MENU_STRINGS do
      if i ~= 1 or self.showContinue then
        if i == self.selection then
          love.graphics.print("*", 144, 86+i*13)
        end
        love.graphics.print(MENU_STRINGS[i], 152, 86+i*13)
      end
    end
end

function self.resize(w, h)
  
end

function self.enableContinue()
  self.showContinue = true
  self.selection = 1
end

return self
