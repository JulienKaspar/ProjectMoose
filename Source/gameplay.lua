-- Global variables

GYRO_X, GYRO_Y = 200, 120

local maximum_strikes <const> = 3

-- Gameplay state variables that should be reset

GAMEPLAY_STATE = {
    example = false,
    current_strikes = 0,
}

import "world"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

local selected_box = 1
local world_angle = 0
local angle = 1


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
    GAMEPLAY_STATE.current_strikes = 0
end


function try_ending_game()
    if GAMEPLAY_STATE.current_strikes >= maximum_strikes then
        Reset_gameplay()
        Enter_game_over_screen()
    end
end


-- Update Loop

function Handle_input()
    local gravityX, gravityY, _gravityZ = playdate.readAccelerometer()
    GYRO_X = Clamp(GYRO_X + gravityX * 10, 0, 400)
    GYRO_Y = Clamp(GYRO_Y + gravityY * 10, 0, 240)

    -- Placeholder debug for accumilating strikes
    if playdate.buttonJustPressed( playdate.kButtonB ) then
        GAMEPLAY_STATE.current_strikes += 1
    end
end


function update(dt)
    world:update(dt)

    -- See if the game is lost or won
    try_ending_game()

    -- TODO(weizhen): stop reading the accelerometer if moving?
    local gravityX, gravityY, _ = pd.readAccelerometer()
    angle = Clamp(math.atan2(gravityX, gravityY), -MAX_ANGLE, MAX_ANGLE)

    claw:update(angle, dt)

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
