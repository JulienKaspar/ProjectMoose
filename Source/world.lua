local pd = playdate

local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

local WORLD_WIDTH <const> = 400
local WORLD_HEIGHT <const> = 240
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

boxes = table.create(BOX_COUNT, 0)
box_patterns = table.create(BOX_COUNT, 0)

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
  claw = playbox.body.new(100, 200, 0)
  claw:setCenter(WORLD_WIDTH*0.5, 20)
  claw:setFriction(CLAW_FRICTION)
  world:addBody(claw)

  -- Create boxes
  for i = 1, BOX_COUNT do
    local box_mass <const> = math.random(MASS_MIN, MASS_MAX)
    local box = playbox.body.new((math.random()*0.5 + 0.2)*WORLD_PIXEL_SCALE, (math.random()*0.5 + 0.2) * WORLD_PIXEL_SCALE, box_mass)
    box:setCenter((math.random()*0.6+0.2) * WORLD_WIDTH, 0)
    box:setFriction(0.8)
    box:setRotation(math.random() * 0.3 + 0.1)
    world:addBody(box)
    boxes[#boxes + 1] = box

    -- Box color connected to its mass. Lighter pattern = less mass.
    box_patterns[#box_patterns + 1] = math.max(math.min(1.0 - box_mass/MASS_MAX, 0.9), 0.1)
  end
end
