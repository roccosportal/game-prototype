ContactEventManager = {}
ContactEventManager.__index = ContactEventManager


function ContactEventManager.create(world)
  local self = setmetatable({}, ContactEventManager)
  self.fixtures = {}
  self.callbacks = {
      onBeginContact = {},
      onEndContact = {},
      onPreSolve = {},
      onPostSolve = {}
  }
  
  local function beginContact(a, b, contact)
      self:call(self.callbacks.onBeginContact, {a, b, contact})
      self:invokeEvent("beginContact", a, b, {contact})  
  end

  local function endContact(a, b, contact)
      self:call(self.callbacks.onEndContact, {a, b, contact})
      self:invokeEvent("endContact", a, b, {contact})
  end

  local function preSolve(a, b, contact)
      self:call(self.callbacks.onPreSolve, {a, b, contact})
      self:invokeEvent("preSolve", a, b, {contact})
  end

  local function postSolve(a, b, contact, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
      self:call(self.callbacks.onPostSolve, {a, b, contact, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2})
      self:invokeEvent("postSolve", a, b, {contact, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2})
  end
  
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
  return self
end

function ContactEventManager:onBeginContact(callback)
  table.insert(self.callbacks.onBeginContact, callback)
end

function ContactEventManager:onEndContact(callback)
  table.insert(self.callbacks.onEndContact, callback)
end

function ContactEventManager:onPreSolve(callback)
  table.insert(self.callbacks.onPreSolve, callback)
end

function ContactEventManager:onPostSolve(callback)
  table.insert(self.callbacks.onPostSolve, callback)
end

function ContactEventManager:register(fixture, beginContact, endContact, preSolve, postSolve)
  beginContact = beginContact or function() end
  endContact = endContact or function() end
  preSolve = preSolve or function() end
  postSolve = postSolve or function() end
  

  data = {
      fixture = fixture,
      callbacks = {
        beginContact = beginContact,
        endContact = endContact,
        preSolve = preSolve,
        postSolve = postSolve
      }
  }
  table.insert(self.fixtures, data)
end

function ContactEventManager:call(t, args)
  for _, callback in ipairs(t) do
    callback(unpack(args))
  end
end

function ContactEventManager:invokeEvent(event,a, b, args)
    local aMatch = false
    local bMatch = false
    -- try finding fixtures in the table
    for _, data in ipairs(self.fixtures) do
      if not aMatch and a == data.fixture then
        data.callbacks[event](b, unpack(args))
        aMatch = true
      elseif not bMatch and b == data.fixture then
        data.callbacks[event](a, unpack(args))
        bMatch = true
      elseif aMatch and bMatch then
        break
      end
    end
end
