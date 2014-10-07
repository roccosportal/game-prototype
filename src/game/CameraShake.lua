-- based on http://notmagi.me/simple-camera-shake/

local CameraShake = class('CameraShake')
function CameraShake:initialize(camera)
    self.camera = camera
    self.shakes = {}
    self.shake_intensity = 0
    self.uid = 0
end

function CameraShake:add(intensity, duration)
    self.uid = self.uid + 1
    table.insert(self.shakes, {creation_time = love.timer.getTime(), id = self.uid,intensity = intensity, duration = duration})
end

function CameraShake:remove(id)
    table.remove(self.shakes, id)
end

function CameraShake:update()
    self.shake_intensity = 0
    for _, shake in ipairs(self.shakes) do
        if love.timer.getTime() > shake.creation_time + shake.duration then
            -- create smooth out
            if shake.intensity > 0.01 then
              self:add(shake.intensity / 2.5, shake.duration / 2.5)
            end
            
            self:remove(_)
        end
        -- pick the max intensity
        if self.shake_intensity < shake.intensity then
          self.shake_intensity = shake.intensity
        end

    end
    
    if self.shake_intensity ~= 0 then
      self.camera:setPosition(self.camera.x + math.random(-self.shake_intensity, self.shake_intensity),
                       self.camera.y + math.random(-self.shake_intensity, self.shake_intensity))
    end

end

return CameraShake
