local class = require('lib/middleclass/middleclass')
local Physical = require("src/game/objects/Physical")
local CoilSpring = class('game.objects.CoilSpring', Physical)

CoilSpring.static.POWER = 600
CoilSpring.static.NOISE = 600
CoilSpring.static.BORDER_WIDTH = 1
CoilSpring.static.BORDER_HEIGHT = 14
CoilSpring.static.TRIGGER_WIDTH = 16
CoilSpring.static.HEIGHT = 16
CoilSpring.static.TRIGGER_HEIGHT = 1


function CoilSpring:initialize(world, x, y)
    Physical.initialize(self, world, x, y)
    local w_offset = CoilSpring.TRIGGER_WIDTH + CoilSpring.BORDER_WIDTH
    local h_offset = CoilSpring.HEIGHT - CoilSpring.BORDER_HEIGHT
    
    self.leftBorder = {}
    self.leftBorder.body = love.physics.newBody(self.world, self.x + CoilSpring.BORDER_WIDTH / 2, h_offset + self.y + CoilSpring.BORDER_HEIGHT / 2, "static")
    self.leftBorder.shape = love.physics.newRectangleShape(0, 0, CoilSpring.BORDER_WIDTH, CoilSpring.BORDER_HEIGHT)
    self.leftBorder.fixture = love.physics.newFixture(self.leftBorder.body, self.leftBorder.shape, 1)
    
    Physical.registerPhysicalObject(self, self.leftBorder.body, self.leftBorder.shape, self.leftBorder.fixture)
    
    self.rightBorder = {}
    self.rightBorder.body = love.physics.newBody(self.world,w_offset + self.x + CoilSpring.BORDER_WIDTH / 2,h_offset + self.y + CoilSpring.BORDER_HEIGHT / 2, "static")
    self.rightBorder.shape = love.physics.newRectangleShape(0, 0, CoilSpring.BORDER_WIDTH, CoilSpring.BORDER_HEIGHT)
    self.rightBorder.fixture = love.physics.newFixture(self.rightBorder.body, self.rightBorder.shape, 1)
    
    Physical.registerPhysicalObject(self, self.rightBorder.body, self.rightBorder.shape, self.rightBorder.fixture)
    
    self.trigger = {}
    self.trigger.body = love.physics.newBody(self.world, CoilSpring.BORDER_WIDTH + self.x + CoilSpring.TRIGGER_WIDTH / 2, self.y + CoilSpring.TRIGGER_HEIGHT / 2, "static")
    self.trigger.shape = love.physics.newRectangleShape(0, 0, CoilSpring.TRIGGER_WIDTH, CoilSpring.TRIGGER_HEIGHT)
    self.trigger.fixture = love.physics.newFixture(self.trigger.body, self.trigger.shape, 1)
    self.trigger.fixture:setSensor(true)
    
    Physical.registerPhysicalObject(self, self.trigger.body, self.trigger.shape, self.trigger.fixture)
    
    local function beginContact(fixture, contact)
        if fixture == game.player.fixture then
            local x, y = game.player.body:getLinearVelocity()
            game.player.body:setLinearVelocity(x, -CoilSpring.POWER)
            game.overlays.sounds.new(game.player.body:getX(), game.player.body:getY(), CoilSpring.NOISE)
            
        end
    end
    game.contactEventManager.register(self.trigger.fixture, beginContact)
end


return CoilSpring
