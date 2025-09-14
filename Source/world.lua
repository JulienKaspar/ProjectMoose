local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

import "toys"

WORLD_WIDTH = 400
WORLD_HEIGHT = 240
WORLD_PIXEL_SCALE = 80
local WALL_FRICTION <const> = 0.2
local WALL_HEIGHT <const> = 3
local PAD <const> = 5
MAX_ANGLE = 0.5
BOX_COUNT = 20

world = nil
claw = nil
floor = nil
left_wall = nil
right_wall = nil
peedee_toy = nil

local MASS_MIN <const> = 50
local MASS_MAX <const> = 120

local world_rotation = 0

function draw_polygon(object)
  local polygon = geometry.polygon.new(object:getPolygon())
  polygon:close()
  gfx.fillPolygon(polygon)
end

function Init_world()
  -- Setup background color
  gfx.setBackgroundColor(gfx.kColorBlack)

  -- Create world
  world = playbox.world.new(0.0, 9.81, 10)
  world:setPixelScale(WORLD_PIXEL_SCALE)

  peedee_toy = Toy:new(nil, TOYS_INSTRUCTIONS.peedee, world)
  peedee_toy:move(geometry.vector2D.new(100, 50))

  -- Create floor
  floor = playbox.body.new(WORLD_WIDTH, WALL_WIDTH, 0)
  floor:setCenter(WORLD_WIDTH*0.5, WORLD_HEIGHT+PAD)
  floor:setFriction(WALL_FRICTION)
  world:addBody(floor)

  -- Create wall
  left_wall = playbox.body.new(WALL_WIDTH, WORLD_HEIGHT)
  left_wall:setCenter(0, WORLD_HEIGHT*0.5)
  left_wall:setFriction(WALL_FRICTION)
  world:addBody(left_wall)

  right_wall = playbox.body.new(WALL_WIDTH, WORLD_HEIGHT)
  right_wall:setCenter(WORLD_WIDTH, WORLD_HEIGHT*0.5)
  right_wall:setFriction(WALL_FRICTION)
  world:addBody(right_wall)

  -- Create claw
  claw = playbox.body.new(0, 0, 0)
  claw:setCenter(WORLD_WIDTH*0.5, 0)
  claw:setFriction(CLAW_FRICTION)
  world:addBody(claw)
end
