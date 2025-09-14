local pd = playdate
local gfx <const> = playdate.graphics

import "world"

Claw = {ref = nil, joint = nil, left = nil, right = nil, speed = 15}
Claw.__index = Claw

function Claw:new()
    local claw = {}
    setmetatable(claw, Claw)
    claw.ref = playbox.body.new(0, 0, 0)
    claw.ref:setCenter(WORLD_WIDTH*0.5, 0)
    claw.ref:setFriction(0)
    world:addBody(claw.ref)
    return claw
end

function Claw:getRotation()
    return self.ref:getRotation()
end

function Claw:getCenter()
    return self.ref:getCenter()
end

function Claw:setRotation(x)
    self.ref:setRotation(x)
end

function Claw:setCenter(x, y)
    self.ref:setCenter(x, y)
end

function Claw:setVelocity(x, y)
    self.ref:setVelocity(x, y)
end

function Claw:draw(image)
    local claw_image = gfx.image.new(image)
    local x, y = claw:getCenter()
    claw_image:drawRotated(x, y, -math.deg(claw:getRotation()))

    -- Debug position
    gfx.setColor(gfx.kColorWhite)
    gfx.fillCircleAtPoint(x, y, 10)
end

function Claw:moveHorizontalTo(target_x, dt)
  local claw_x, claw_y = claw:getCenter()
  local new_x = Clamp((target_x - claw_x), -dt*self.speed, dt*self.speed) + claw_x
  claw:setCenter(new_x, claw_y)
end

function Claw:moveVertical(angle)
    local vel_x = math.sin(angle) * self.speed
    local vel_y = math.cos(angle) * self.speed
    claw.ref:setVelocity(vel_x, vel_y)
end
