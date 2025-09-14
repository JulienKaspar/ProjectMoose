-- Global variables

GYRO_X, GYRO_Y = 200, 120

-- Gameplay state variables that should be reset

GAMEPLAY_STATE = {
    example = false
}

import "world"

local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

local selected_box = 1
local world_angle = 0
local angle = 1
local moving = false

-- Local methods


-- Resource Management


function Init_gameplay()
    -- Done only once on start of the game, to load and setup const resources.

    playdate.startAccelerometer()
end


function Stop_gameplay()
    -- Done on every game over/win to stop ongoing sounds and events.
    -- Not a complete tear down of resources.
end


function Reset_gameplay()
    -- Done on every (re)start of the play.

    GAMEPLAY_STATE.example = false
end



-- Update Loop

function Handle_input()
    local gravityX, gravityY, _gravityZ = playdate.readAccelerometer()
    GYRO_X = Clamp(GYRO_X + gravityX * 10, 0, 400)
    GYRO_Y = Clamp(GYRO_Y + gravityY * 10, 0, 240)

    -- check_gyro_and_gravity()
    if playdate.buttonIsPressed( playdate.kButtonA ) then
        if not SOUND.cat_meow:isPlaying() then
            SOUND.cat_meow:play()
        end
    end
end

function update(dt)
    world:update(dt)

    -- TODO(weizhen): stop reading the accelerometer if moving?
    local gravityX, gravityY, _ = playdate.readAccelerometer()
    angle = Clamp(math.atan2(gravityX, gravityY), -MAX_ANGLE, MAX_ANGLE)
    claw:setRotation(angle)

    local toy_x, toy_y = peedee_toy.bodies[1]:getCenter()
    local claw_x, claw_y = claw:getCenter()
    local target_x = toy_x - math.tan(angle) * toy_y

    if math.floor(target_x + 0.5) == math.floor(claw_x + 0.5) then
        moving = true
    end

    if moving then
        claw:moveVertical(world_angle)
    else
        claw:moveHorizontalTo(target_x, dt)
    end

  -- TODO: limit resolution
    if angle ~= world_angle then
        world_angle = angle
        world:setGravity(math.sin(angle) * 9.81, math.cos(angle) * 9.81)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        peedee_toy.bodies[1]:addForce(0, -9000)
    end

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        peedee_toy.bodies[1]:addForce(-300, 0)
    end

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        peedee_toy.bodies[1]:addForce(300, 0)
    end
end

function playdate.cranked(change, acceleratedChange)
  local ang_vel = peedee_toy.bodies[1]:getAngularVelocity()
  -- local alpha <const> = 10
  -- ang_vel += 0.5 * (acceleratedChange * alpha / (1 + math.abs(acceleratedChange * alpha))) + 0.5
  ang_vel += acceleratedChange * 0.05
  ang_vel = Clamp(ang_vel, -4, 4)
  peedee_toy.bodies[1]:setAngularVelocity(ang_vel)
end
