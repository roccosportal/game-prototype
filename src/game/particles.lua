local self = {}
self.particles = {}

function self.collision()
  i = love.graphics.newImage("gfx/particles/square_with_hole.png")
  p = love.graphics.newParticleSystem(i, 20)
  p:setEmissionRate          (20)
  p:setEmitterLifetime       (0.1)
  p:setParticleLifetime      (1.5)
  p:setDirection             (0)
  p:setSpread                (360)
  p:setSpeed                 (20, 50)
  p:setRadialAcceleration    (10)
  p:setSizes                  (1)
  p:setSizeVariation         (0.5)
  p:setSpin                  (4)
  p:setSpinVariation         (0)
  p:setColors                (0, 0, 0, 240, 255, 255, 255, 10)
  return p
end

return self
