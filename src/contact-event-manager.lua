ContactEventManager = {}
ContactEventManager.__index = ContactEventManager


function ContactEventManager.create(world)
  local self = setmetatable({}, ContactEventManager)
  self.fixtures = {}
  self.callbacks = {
      onBeginContact = {},
      onEndContact = {},
      onPreSolve = {},
      onPostSolve = {},
      onContactFilter = {}
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
  
  local function contactFilter(a, b)
      self:call(self.callbacks.onContactFilter, {a, b})
      return self:invokeEvent("contactFilter", a, b, {})
  end
  
  world:setContactFilter(contactFilter)
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

function ContactEventManager:register(fixture, beginContact, endContact, preSolve, postSolve, contactFilter)
  -- beginContact = beginContact or function() return nil end
  -- endContact = endContact or function() return nil end
  -- preSolve = preSolve or function() return nil end
  -- postSolve = postSolve or function() return nil end
  -- contactFilter = contactFilter or function() return nil end
  

  data = {
      fixture = fixture,
      callbacks = {
        beginContact = beginContact,
        endContact = endContact,
        preSolve = preSolve,
        postSolve = postSolve,
        contactFilter = contactFilter
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
    local returnValueA = nil
    local returnValueB = nil
    -- try finding fixtures in the table
    for _, data in ipairs(self.fixtures) do
      if not aMatch and a == data.fixture then
        if data.callbacks[event] ~= nil then
            returnValueA = data.callbacks[event](b, unpack(args)) 
        end 
        aMatch = true
      elseif not bMatch and b == data.fixture then
        if data.callbacks[event] ~= nil then
            returnValueB = data.callbacks[event](a, unpack(args))
        end 
        bMatch = true
      elseif aMatch and bMatch then
        break
      end
    end
    
    -- mergin returnValues
    if returnValueA == nil and returnValueB == nil then
      return true
    elseif returnValueA ~= nil and returnValueB == nil then
      return returnValueA
    elseif returnValueA == nil and returnValueB ~= nil then
      return returnValueB
    elseif returnValueA == returnValueB then
      return returnValueA
    else
      return false -- false is the more greedy one
    end
end
