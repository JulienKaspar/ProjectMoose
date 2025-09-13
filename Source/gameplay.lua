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

    if playdate.buttonJustPressed(playdate.kButtonB) then
        selected_box += 1
        if selected_box > BOX_COUNT then
            selected_box = 1
        end
      end

    print(selected_box)

    local box = boxes[selected_box]

    local target_x, _ = box:getCenter()
    local claw_x, claw_y = claw:getCenter()
    local new_x = Clamp((target_x - claw_x), -1, 1) + claw_x
    claw:setCenter(new_x, claw_y)

    local gravityX, gravityY, _ = playdate.readAccelerometer()
    local angle = Clamp(math.atan2(gravityX, gravityY), -MAX_ANGLE, MAX_ANGLE)
    claw:setRotation(angle)

  -- TODO: limit resolution
    if angle ~= world_angle then
        world_angle = angle
        world:setGravity(math.sin(angle) * 9.81, math.cos(angle) * 9.81)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        box:addForce(0, -9000)
    end

    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        box:addForce(-300, 0)
    end

    if playdate.buttonIsPressed(playdate.kButtonRight) then
        box:addForce(300, 0)
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

  -- Draw environment
  draw_polygon(floor)
  draw_polygon(left_wall)
  draw_polygon(right_wall)

  -- Draw boxes
  gfx.setStrokeLocation(gfx.kStrokeInside)
  for i, box in ipairs(boxes) do
    local box_polygon = geometry.polygon.new(box:getPolygon())
    box_polygon:close()
    if i == selected_box then
      gfx.setColor(gfx.kColorBlack)
    else
      gfx.setColor(gfx.kColorWhite)
    end
    gfx.fillPolygon(box_polygon)
    gfx.setColor(gfx.kColorBlack)
    gfx.setLineWidth(3)
    gfx.drawPolygon(box_polygon)
  end


  gfx.setLineWidth(1)
  gfx.setDitherPattern(0.5)

  -- Draw FPS on device
  if not playdate.isSimulator then
    playdate.drawFPS(380, 15)
  end
end
