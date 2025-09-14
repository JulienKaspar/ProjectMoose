-- Global variables

GYRO_X, GYRO_Y = 200, 120

local maximum_strikes <const> = 3

-- Gameplay state variables that should be reset

GAMEPLAY_STATE = {
    current_strikes = 1,
    previous_strikes = 0,
    claw_moving_up = false,
}

import "world"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

local world_angle = 0
local angle = 1


-- Local methods


-- Resource Management


function Init_gameplay()
    -- Done only once on start of the game, to load and setup const resources.

    playdate.startAccelerometer()
    GAMEPLAY_STATE.claw_moving_up = false
end


function Stop_gameplay()
    -- Done on every game over/win to stop ongoing sounds and events.
    -- Not a complete tear down of resources.
end


function Reset_gameplay()
    -- Done on every (re)start of the play.
    Reset_gameplay_entities()
    GAMEPLAY_STATE.current_strikes = 0
    GAMEPLAY_STATE.previous_strikes = 0
    GAMEPLAY_STATE.claw_moving_up = false
end


function try_ending_game()
    if GAMEPLAY_STATE.current_strikes >= maximum_strikes then
        Enter_game_over_screen()
    -- NOTE: Commentented out until we have an actual win condition
    -- elseif GAMEPLAY_STATE.current_strikes < 0 then
    --     Enter_win_screen()
    end
end


function receive_strike()
    GAMEPLAY_STATE.previous_strikes = GAMEPLAY_STATE.current_strikes
    GAMEPLAY_STATE.current_strikes += 1
    GAMEPLAY_STATE.current_strikes = Clamp(GAMEPLAY_STATE.current_strikes, 0, 3)
    kiddo_gets_mad()
end


function receive_correct_toy()
    GAMEPLAY_STATE.previous_strikes = GAMEPLAY_STATE.current_strikes
    GAMEPLAY_STATE.current_strikes -= 1
    GAMEPLAY_STATE.current_strikes = Clamp(GAMEPLAY_STATE.current_strikes, 0, 3)
    kiddo_is_pleased()
end


-- Update Loop

function Handle_input()
    local gravityX, gravityY, _gravityZ = playdate.readAccelerometer()
    GYRO_X = Clamp(GYRO_X + gravityX * 10, 0, 400)
    GYRO_Y = Clamp(GYRO_Y + gravityY * 10, 0, 240)

    -- Placeholder debug for accumilating strikes
    -- if playdate.buttonJustPressed( playdate.kButtonB ) then
    --     receive_strike()
    -- end
    -- if playdate.buttonJustPressed( playdate.kButtonA ) then
    --     receive_correct_toy()
    -- end
end

function check_toys_got_out()
  local cx, cy = claw.ceiling:getCenter()
  if GAMEPLAY_STATE.claw_moving_up and cy < -270 then
    local got_right_toy = false
    for i, toy in ipairs(TOYS) do
      local _, y = toy.bodies[1]:getCenter()
      if y < 50 then
        if toy == selected_toy then
          got_right_toy = true
          selected_toy = nil
        end
        table.remove(TOYS, i)
        toy:destructor()
        toy = nil
      end
    end

    if selected_toy == nil then
      local random_i = math.random(#TOYS)
      selected_toy = TOYS[random_i]
    end

    if not got_right_toy then
      receive_strike()
    else
      receive_correct_toy()
    end
    GAMEPLAY_STATE.claw_moving_up = false
  end
end


function update(dt)
    world:update(dt)

    -- See if the game is lost or won
    try_ending_game()

    -- TODO(weizhen): stop reading the accelerometer if moving?
    local gravityX, gravityY, _ = pd.readAccelerometer()
    angle = Clamp(math.atan2(gravityX, gravityY), -MAX_ANGLE, MAX_ANGLE)

    claw:update()

    if playdate.buttonIsPressed(playdate.kButtonDown) then
        claw:moveVertical(angle, 1)
        GAMEPLAY_STATE.claw_moving_up = false
    end

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        claw:moveVertical(angle + math.pi, 4)
        GAMEPLAY_STATE.claw_moving_up = true
    end

  -- TODO: limit resolution
    if angle ~= world_angle then
        world_angle = angle
        world:setGravity(math.sin(angle) * 9.81, math.cos(angle) * 9.81)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        selected_toy.bodies[1]:addForce(0, -9000)
    end

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        selected_toy.bodies[1]:addForce(-300, 0)
    end

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        selected_toy.bodies[1]:addForce(300, 0)
    end

    check_toys_got_out()
end

function playdate.cranked(change, acceleratedChange)
  local ang_vel = selected_toy.bodies[1]:getAngularVelocity()
  -- local alpha <const> = 10
  -- ang_vel += 0.5 * (acceleratedChange * alpha / (1 + math.abs(acceleratedChange * alpha))) + 0.5
  ang_vel += acceleratedChange * 0.05
  ang_vel = Clamp(ang_vel, -4, 4)
  selected_toy.bodies[1]:setAngularVelocity(ang_vel)
  
  -- if crank is yanked, play toy sound
  if acceleratedChange > 10 then
    Play_random_toy_sound()
  end
end
