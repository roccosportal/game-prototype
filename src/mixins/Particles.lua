local self = {}
self.particles = {}

function self.register(p, x, y)
  table.insert(self.particles, {p = p, x = x, y = y})
end

function self.update(dt)
  local rl = {}
  for i,particle in ipairs(self.particles) do
    particle.p:update(dt)
    if particle.p:isActive() == false and particle.p:getCount() == 0 then  -- inactive particle system
      table.insert(rl, i)
    end
  end
  
  -- remove inactive particle system from list
  for _, i in ipairs(rl) do
    table.remove(self.particles, i)
  end
end

function self.draw()
  for i,particle in ipairs(self.particles) do
    love.graphics.draw(particle.p, particle.x, particle.y)
  end
end

return self
