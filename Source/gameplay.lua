-- Global variables

GYRO_X, GYRO_Y = 200, 120

local maximum_strikes <const> = 3


local jump_timeout_value = 0.0
local jump_timeout_max <const> = 0.8


-- Gameplay state variables that should be reset

GAMEPLAY_STATE = {
    current_strikes = 0,
    previous_strikes = 0,
    claw_movement = 'down'
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
    claw:move_down()
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
    claw:move_down()
    select_random_toy()
end


function try_ending_game()
    if GAMEPLAY_STATE.current_strikes >= maximum_strikes then
        Enter_game_over_screen()
    elseif #TOYS == 0 then
        Enter_win_screen()
    end
end

function select_random_toy()
  if selected_toy == nil and #TOYS > 0 then
    local random_i = math.random(#TOYS)
    selected_toy = TOYS[random_i]
    selected_toy:setHighlight()
  end
end


function receive_strike()
    GAMEPLAY_STATE.previous_strikes = GAMEPLAY_STATE.current_strikes
    GAMEPLAY_STATE.current_strikes += 1
    GAMEPLAY_STATE.current_strikes = Clamp(GAMEPLAY_STATE.current_strikes, 0, 3)
    kiddo_gets_mad()
    SOUND.child_disappointed:play()
    SOUND.kiddo_bang_glass:play()
end


function receive_correct_toy()
    GAMEPLAY_STATE.previous_strikes = GAMEPLAY_STATE.current_strikes
    GAMEPLAY_STATE.current_strikes -= 1
    GAMEPLAY_STATE.current_strikes = Clamp(GAMEPLAY_STATE.current_strikes, 0, 3)
    kiddo_is_pleased()
    SOUND.child_wow:play()
    SOUND.toy_ascend:play()
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
  if claw_is_moving_up() and cy < CEILING_DETECTION_HEIGHT then
    local got_right_toy = false
    for i, toy in ipairs(TOYS) do
      local _, y = toy.bodies[1]:getCenter()
      if y < 50 then
        local reset_selected = false
        if toy == selected_toy then
          got_right_toy = true
          reset_selected = true
        end
        toy:destructor(world)
        table.remove(TOYS, i)
        toy = nil
        if reset_selected then
          selected_toy:removeHighlight()
          selected_toy = nil
        end 
      end
    end

    if not got_right_toy then
      receive_strike()
    else
      receive_correct_toy()
    end

    select_random_toy()

    claw:move_down()
  end
end


function update(dt)
    -- Update timers
    jump_timeout_value -= dt
    jump_timeout_value = Clamp(jump_timeout_value, 0, jump_timeout_max)


    -- See if the game is lost or won
    try_ending_game()

    -- TODO(weizhen): stop reading the accelerometer if moving?
    local gravityX, gravityY, _ = pd.readAccelerometer()
    angle = Clamp(math.atan2(gravityX, gravityY), -MAX_ANGLE, MAX_ANGLE)

    claw:update(dt)

  -- TODO: limit resolution
    if angle ~= world_angle then
        world_angle = angle
        world:setGravity(math.sin(angle) * 9.81, math.cos(angle) * 9.81)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) and jump_timeout_value <= 0.0 then
        jump_timeout_value = jump_timeout_max
        -- Use the size of the body as a factor for the added force.
        local jump_force = -180.0 / (#selected_toy.bodies)
        for k, body in ipairs(selected_toy.bodies) do
          local mass = selected_toy.bodies[1]:getMass()
          body:addForce(0, mass * jump_force)
          
        end
    end

    check_toys_got_out()
end

function playdate.cranked(change, acceleratedChange)

  local rotation_velocity_acceleration <const> = 0.25
  local min_rotation_velocity <const> = 3.0
  local max_rotation_velocity <const> = 16.0
  
  if #TOYS <= 0 or selected_toy == nil then
    return
  end
  local ang_vel = selected_toy.bodies[1]:getAngularVelocity()
  -- local alpha <const> = 10
  -- ang_vel += 0.5 * (acceleratedChange * alpha / (1 + math.abs(acceleratedChange * alpha))) + 0.5\
  ang_vel += acceleratedChange * rotation_velocity_acceleration

  local ang_vel_sign = Sign(ang_vel)
  local ang_vel_abs = math.abs(ang_vel)

  ang_vel_abs = Clamp(ang_vel_abs, min_rotation_velocity, max_rotation_velocity)
  ang_vel = ang_vel_abs * ang_vel_sign
  selected_toy.bodies[1]:setAngularVelocity(ang_vel)

  -- Push the toy a bit as well
  local mass = selected_toy.bodies[1]:getMass()
  selected_toy.bodies[1]:addForce(ang_vel * mass, 0)
  
  -- if crank is yanked enough, play toy sound
  if acceleratedChange > 20 and MENU_STATE.screen == MENU_SCREEN.gameplay then
    Play_random_toy_sound()
  end
end
