local pd = playdate
local pb = playbox
local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

local WORLD_CENTER_X <const> = 200
local CEILING_HEIGHT <const> = -100
local CABLE_LENGTH <const> = 200
local CLAW_LENGTH <const> = 40
local CLAW_MASS <const> = 500

import "world"

-- TODO(weizhen): make state
local moving = false

function playbox.body:draw_debug()
    local polygon = geometry.polygon.new(self:getPolygon())
    polygon:close()
    gfx.setColor(gfx.kColorWhite)
    gfx.fillPolygon(polygon)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(1)
    gfx.drawPolygon(polygon)
end

function playbox.joint:draw_debug()
    gfx.setStrokeLocation(gfx.kStrokeCentered)
    local x1, y1, px1, py1, x2, y2, px2, py2 = self:getPoints()
    gfx.setDitherPattern(0.5)
    gfx.drawLine(x2, y2, px1, py1)
    gfx.drawLine(x1, y1, px2, py2)
end

Joint = {claw_left_joint = nil, claw_right_joint = nil, claw_joint = nil, cable_joint = nil, center = nil}
Joint.__index = Joint

function Joint:new(claw)
    local joint = {}
    setmetatable(joint, Joint)

    local CENTER_X <const> = WORLD_CENTER_X
    local CENTER_Y <const> = CEILING_HEIGHT + CABLE_LENGTH

    joint.center = pb.body.new(2, 2, CLAW_MASS)
    joint.center:setCenter(CENTER_X, CENTER_Y)
    joint.center:setFriction(100)
    world:addBody(joint.center)

    joint.claw_left_joint = pb.joint.new(claw.left, joint.center, CENTER_X, CENTER_Y)
    joint.claw_left_joint:setBiasFactor(0.3)
    joint.claw_left_joint:setSoftness(0)
    world:addJoint(joint.claw_left_joint)

    joint.claw_right_joint = pb.joint.new(claw.right, joint.center, CENTER_X, CENTER_Y)
    joint.claw_right_joint:setBiasFactor(0.3)
    joint.claw_right_joint:setSoftness(0)
    world:addJoint(joint.claw_right_joint)

    joint.claw_joint = pb.joint.new(claw.right, claw.left, CENTER_X, CENTER_Y + CLAW_LENGTH)
    joint.claw_joint:setBiasFactor(0.3)
    joint.claw_joint:setSoftness(0)
    world:addJoint(joint.claw_joint)

    joint.cable_joint = pb.joint.new(claw.ceiling, joint.center, 0.5*WORLD_WIDTH, CEILING_HEIGHT)
    joint.cable_joint:setBiasFactor(0.1)
    joint.cable_joint:setSoftness(0)
    world:addJoint(joint.cable_joint)

    return joint
end

function Joint:draw_debug()
    self.cable_joint:draw_debug()
    self.claw_left_joint:draw_debug()
    self.claw_right_joint:draw_debug()

    local x, y = self.center:getCenter()
    gfx.setColor(gfx.kColorBlack)
    gfx.fillCircleAtPoint(x, y, 3)
end

-- TODO(weizhen): add or extend sprite
Claw = {ref = nil, joint = nil, left = nil, right = nil, ceiling = nil, speed = 15}
Claw.__index = Claw

function Claw:new()
    local claw = {}
    setmetatable(claw, Claw)

    -- Ceiling
    claw.ceiling = pb.body.new(2*WORLD_WIDTH, WALL_WIDTH)
    claw.ceiling:setCenter(0.5*WORLD_WIDTH, CEILING_HEIGHT)
    claw.ceiling:setFriction(WALL_FRICTION)
    world:addBody(claw.ceiling)

    -- Claw body
    local CLAW_SIZE <const> = 10

    claw.left = pb.body.new(CLAW_SIZE, CLAW_SIZE, CLAW_MASS)
    claw.left:setCenter(WORLD_CENTER_X - CLAW_LENGTH, CEILING_HEIGHT + CABLE_LENGTH + CLAW_LENGTH)
    claw.left:setFriction(100)
    world:addBody(claw.left)

    claw.right = pb.body.new(CLAW_SIZE, CLAW_SIZE, CLAW_MASS)
    claw.right:setCenter(WORLD_CENTER_X + CLAW_LENGTH, CEILING_HEIGHT + CABLE_LENGTH + CLAW_LENGTH)
    claw.right:setFriction(100)
    world:addBody(claw.right)

    claw.joint = Joint:new(claw)

    claw.ref = pb.body.new(0, 0, 0)
    claw.ref:setCenter(WORLD_WIDTH*0.5, 0)
    claw.ref:setFriction(0)
    world:addBody(claw.ref)
    return claw
end

function Claw:update(angle, dt)
    self:setRotation(angle)

    local toy_x, toy_y = peedee_toy.bodies[1]:getCenter()
    local claw_x, claw_y = self:getCenter()
    local target_x = toy_x - math.tan(angle) * toy_y

    if math.floor(target_x + 0.5) == math.floor(claw_x + 0.5) then
        moving = true
    end

    if moving then
        self:moveVertical(angle)
    else
        self:moveHorizontalTo(target_x, dt)
    end

    -- Apply air friction
    local friction = 1000
    local vel_x, vel_y = self.left:getVelocity()
    self.left:addForce(-vel_x * friction, -vel_y * friction)

    vel_x, vel_y = self.right:getVelocity()
    self.right:addForce(-vel_x * friction, -vel_y * friction)

    vel_x, vel_y = self.joint.center:getVelocity()
    self.joint.center:addForce(-vel_x * friction, -vel_y * friction)

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
    local x, y = self:getCenter()
    claw_image:drawRotated(x, y, -math.deg(self:getRotation()))

    -- Debug position
    gfx.setColor(gfx.kColorWhite)
    gfx.fillCircleAtPoint(x, y, 10)

    self.left:draw_debug()
    self.right:draw_debug()
    self.ceiling:draw_debug()
    self.joint:draw_debug()
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
