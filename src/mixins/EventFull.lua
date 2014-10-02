EventFull = { 

    addEventListener = function(self, name, callback)
      self.eventListeners = self.eventListeners or {}
      self.eventListeners[name] = self.eventListeners[name] or {}    
      table.insert(self.eventListeners[name], callback)
    end,
    
    fireEvent = function(self, name, data)
      self.eventListeners = self.eventListeners or {}
      if not self.eventListeners[name] then
        return
      end
      
      for _, callback in ipairs(self.eventListeners[name]) do
        callback(unpack(data))
      end
    end
    
}
return EventFull
