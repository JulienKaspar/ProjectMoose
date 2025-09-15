-- Global variables

GYRO_X, GYRO_Y = 200, 120

local maximum_strikes <const> = 3


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
end


function try_ending_game()
    if GAMEPLAY_STATE.current_strikes >= maximum_strikes then
        Enter_game_over_screen()
    elseif #TOYS == 0 then
        Enter_win_screen()
    end
end


function receive_strike()
    GAMEPLAY_STATE.previous_strikes = GAMEPLAY_STATE.current_strikes
    GAMEPLAY_STATE.current_strikes += 1
    GAMEPLAY_STATE.current_strikes = Clamp(GAMEPLAY_STATE.current_strikes, 0, 3)
    kiddo_gets_mad()
    SOUND.child_disappointed:play()
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
          selected_toy = nil
        end 
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
    claw:move_down()
  end
end


function update(dt)
    world:update(dt)

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

    if playdate.buttonJustPressed(playdate.kButtonA) then
        selected_toy.bodies[1]:addForce(0, -5000)
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
  if #TOYS <= 0 then
    return
  end
  local ang_vel = selected_toy.bodies[1]:getAngularVelocity()
  -- local alpha <const> = 10
  -- ang_vel += 0.5 * (acceleratedChange * alpha / (1 + math.abs(acceleratedChange * alpha))) + 0.5
  ang_vel += acceleratedChange * 0.05
  ang_vel = Clamp(ang_vel, -4, 4)
  selected_toy.bodies[1]:setAngularVelocity(ang_vel)
  
  -- if crank is yanked, play toy sound
  if acceleratedChange > 10 and MENU_STATE.screen == MENU_SCREEN.gameplay then
    Play_random_toy_sound()
  end
end
