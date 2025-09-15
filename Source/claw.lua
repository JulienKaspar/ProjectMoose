local pd = playdate
local pb = playbox
local gfx <const> = playdate.graphics
local gfxi <const> = playdate.graphics.image
local geometry <const> = playdate.geometry

local WORLD_CENTER_X <const> = 200
local CEILING_HEIGHT <const> = -299
CEILING_HEIGHT_MIN = -300
CEILING_DETECTION_HEIGHT = -270
local CEILING_HEIGHT_MAX <const> = -25
local CABLE_LENGTH <const> = 226
local CLAW_LENGTH <const> = 38
local CLAW_MASS <const> = 100

local SCALE <const> = 0.25
local FRICTION <const> = 1000

import "world"
import "gameplay"

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

class('Joint').extends()

function Joint:init()
    Joint.super.init(self)
end

function Joint:draw_debug()
    self.cable_joint:draw_debug()
    self.claw_left_joint:draw_debug()
    self.claw_right_joint:draw_debug()
    self.claw_joint:draw_debug()

    local x, y = self.center:getCenter()
    gfx.setColor(gfx.kColorBlack)
    gfx.fillCircleAtPoint(x, y, 3)
end

class('Claw').extends()

function Claw:init(ZIndex)
    Claw.super.init(self)

    self.timer = 0.0
    self.speed = 15.0

    self.joint = Joint()

    self:resetPosition(WORLD_CENTER_X)

     -- Sprites
    self.sprites = {}

    local image = gfxi.new("images/claw/claw_cable.png")
    local sprite = gfx.sprite.new(image)
    local ceiling_x, ceiling_y = self.ceiling:getCenter()
    local center_x, center_y = self.joint.center:getCenter()
    sprite:setScale(SCALE)
    sprite:moveTo(0.5 * (ceiling_x + center_x), 0.5 * (ceiling_y + center_y))
    sprite:setZIndex(ZIndex)
    sprite:add()
    self.sprites[#self.sprites + 1] = sprite

    image = gfxi.new("images/claw/claw_left.png")
    sprite = gfx.sprite.new(image)
    sprite:setScale(SCALE)
    sprite:moveTo(center_x, center_y)
    sprite:setZIndex(ZIndex - 1)
    sprite:add()
    self.sprites[#self.sprites + 1] = sprite

    image = gfxi.new("images/claw/claw_right.png")
    sprite = gfx.sprite.new(image)
    local left_x, left_y = self.left:getCenter()
    sprite:setScale(SCALE)
    sprite:moveTo(center_x, center_y)
    sprite:setZIndex(ZIndex - 1)
    sprite:add()
    self.sprites[#self.sprites + 1] = sprite
end

function claw_is_moving_up()
    return GAMEPLAY_STATE.claw_movement == 'up'
end

function claw_is_moving_down()
    return GAMEPLAY_STATE.claw_movement == 'down'
end

function Claw:removeFromWorld()
    world:removeBody(self.ceiling)
    world:removeBody(self.left)
    world:removeBody(self.right)
    world:removeBody(self.joint.center)
    world:removeJoint(self.joint.claw_joint)
    world:removeJoint(self.joint.claw_left_joint)
    world:removeJoint(self.joint.claw_right_joint)
    world:removeJoint(self.joint.cable_joint)
end

function Claw:resetPosition(x)
    -- Ceiling
    self.ceiling = pb.body.new(2*WORLD_WIDTH, 50, 0)
    self.ceiling:setCenter(x, CEILING_HEIGHT)
    self.ceiling:setFriction(WALL_FRICTION)
    world:addBody(self.ceiling)

    -- Claw body
    local CLAW_WIDTH <const> = 8
    local CLAW_HEIGHT <const> = 30
    self.left = pb.body.new(CLAW_WIDTH, CLAW_HEIGHT, CLAW_MASS)
    self.left:setCenter(x - CLAW_LENGTH, CEILING_HEIGHT + CABLE_LENGTH + CLAW_LENGTH)
    self.left:setFriction(100)
    world:addBody(self.left)

    self.right = pb.body.new(CLAW_WIDTH, CLAW_HEIGHT, CLAW_MASS)
    self.right:setCenter(x + CLAW_LENGTH, CEILING_HEIGHT + CABLE_LENGTH + CLAW_LENGTH)
    self.right:setFriction(100)
    world:addBody(self.right)

    -- Joint
    local CENTER_Y <const> = CEILING_HEIGHT + CABLE_LENGTH

    self.joint.center = pb.body.new(2, 2, CLAW_MASS)
    self.joint.center:setCenter(x, CENTER_Y)
    self.joint.center:setFriction(0)
    world:addBody(self.joint.center)

    self.joint.claw_left_joint = pb.joint.new(self.left, self.joint.center, x, CENTER_Y)
    self.joint.claw_left_joint:setBiasFactor(0.3)
    self.joint.claw_left_joint:setSoftness(0)
    world:addJoint(self.joint.claw_left_joint)

    self.joint.claw_right_joint = pb.joint.new(self.right, self.joint.center, x, CENTER_Y)
    self.joint.claw_right_joint:setBiasFactor(0.3)
    self.joint.claw_right_joint:setSoftness(0)
    world:addJoint(self.joint.claw_right_joint)

    self.joint.claw_joint = pb.joint.new(self.right, self.left, x, CENTER_Y + 14)
    self.joint.claw_joint:setBiasFactor(0.3)
    self.joint.claw_joint:setSoftness(0)
    world:addJoint(self.joint.claw_joint)

    self.joint.cable_joint = pb.joint.new(self.ceiling, self.joint.center, x, CEILING_HEIGHT)
    self.joint.cable_joint:setBiasFactor(0.1)
    self.joint.cable_joint:setSoftness(0)
    world:addJoint(self.joint.cable_joint)
end


function Claw:stop()
    GAMEPLAY_STATE.claw_movement = 'stopped'
end

function Claw:move_up()
   self:moveVertical(-4)
   GAMEPLAY_STATE.claw_movement = 'up'

end

function Claw:move_down()
    -- Reset timer
    self.timer = 0.0

    -- Start from a random location
    self:removeFromWorld()
    self:resetPosition((math.random() * 200) + 100)

    -- Set state
    GAMEPLAY_STATE.claw_movement = 'down'
end

function Claw:update(dt)
    if (self.timer * self.speed) > (CEILING_HEIGHT_MAX - CEILING_DETECTION_HEIGHT) then
        self:move_up()
        -- sound
        Play_klaw_ascend_loop()

    elseif claw_is_moving_down() then
        self.timer += dt
        self:moveVertical(1)
        
        Play_klaw_descend_loop()
    end

    -- Clamp position
    local ceiling_x, ceiling_y = self.ceiling:getCenter()
    self.ceiling:setCenter(ceiling_x, Clamp(ceiling_y, CEILING_HEIGHT_MIN, CEILING_HEIGHT_MAX))
    if ceiling_y <= CEILING_HEIGHT_MIN or ceiling_y >= CEILING_HEIGHT_MAX then
         self.ceiling:setVelocity(0, 0)
    end

    -- Apply air friction
    local vel_x, vel_y = self.left:getVelocity()
    self.left:addForce(-vel_x * FRICTION, -vel_y * FRICTION)

    vel_x, vel_y = self.right:getVelocity()
    self.right:addForce(-vel_x * FRICTION, -vel_y * FRICTION)

    vel_x, vel_y = self.joint.center:getVelocity()
    self.joint.center:addForce(-vel_x * FRICTION, -vel_y * FRICTION)

    local ceiling_x, ceiling_y = self.ceiling:getCenter()
    local center_x, center_y = self.joint.center:getCenter()
    local angle = math.atan2((ceiling_x - center_x), center_y - ceiling_y)
    self.sprites[1]:moveTo(0.5 * (ceiling_x + center_x), 0.5 * (ceiling_y + center_y))
    self.sprites[1]:setRotation(math.deg(angle))

    local left_x, left_y = self.left:getCenter()
    angle = math.atan2((center_x - left_x), left_y - center_y)
    self.sprites[2]:moveTo(center_x, center_y)
    self.sprites[2]:setRotation(math.deg(angle) - 45)

    local right_x, right_y = self.right:getCenter()
    angle = math.atan2((center_x - right_x), right_y - center_y)
    self.sprites[3]:moveTo(center_x, center_y)
    self.sprites[3]:setRotation(math.deg(angle) + 45)
end

function Claw:draw_debug()
    self.left:draw_debug()
    self.right:draw_debug()
    self.ceiling:draw_debug()
    self.joint:draw_debug()
end

function Claw:destructor()
    for _, sprite in ipairs(self.sprites) do
        sprite:remove()
    end
end

function Claw:moveHorizontalTo(target_x, dt)
  local claw_x, claw_y = self:getCenter()
  local new_x = Clamp((target_x - claw_x), -dt*self.speed, dt*self.speed) + claw_x
  self:setCenter(new_x, claw_y)
end

function Claw:moveVertical(scale)
    self.ceiling:setVelocity(0, self.speed * scale)
end
