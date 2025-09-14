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

function move_down(claw)
    local claw_x, claw_y = claw:getCenter()
    local vel_x = math.sin(world_angle) * 0.3
    local vel_y = math.cos(world_angle) * 0.3
    claw:setVelocity(vel_x, vel_y)
end

function update(dt)
    world:update(dt)

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
        move_down(claw)
    else
        local new_x = Clamp((target_x - claw_x), -dt*15, dt*15) + claw_x
        new_x = Clamp(new_x, 0, WORLD_WIDTH)
        claw:setCenter(new_x, claw_y)
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

function draw()
    local bg = gfx.image.new("images/environment/bg.png")
    bg:draw(0, 0)

  -- Draw claw
  local claw_image = gfx.image.new("images/claw/temp_claw.png")
  local x, y = claw:getCenter()
  local angle = -claw:getRotation() * 180 / math.pi
  claw_image:drawRotated(x, y, angle)

  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleAtPoint(x, y, 10)

  -- Draw environment
  draw_polygon(floor)
  draw_polygon(left_wall)
  draw_polygon(right_wall)

  -- Draw toy
  for i, body in ipairs(peedee_toy.bodies) do
    --- DEBUG boxes
    -- local box_polygon = geometry.polygon.new(body:getPolygon())
    -- box_polygon:close()
    -- gfx.setColor(gfx.kColorWhite)
    -- gfx.fillPolygon(box_polygon)

    local image = peedee_toy.sprites[i]
    local pos <const> = geometry.vector2D.new(body:getCenter())
    --- Undo the initial rotation of the sprite
    local angle <const> = body:getRotation() + math.rad(TOYS_INSTRUCTIONS.peedee.bodies[i].rotation)
    image:drawRotated(pos.x, pos.y, math.deg(angle), 0.25)
  end



  gfx.setLineWidth(1)
  gfx.setDitherPattern(0.5)

  -- Draw FPS on device
  if not playdate.isSimulator then
    playdate.drawFPS(380, 15)
  end
end
