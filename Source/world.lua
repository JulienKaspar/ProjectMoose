local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

import "toys"
import "claw"

WORLD_WIDTH = 400
WORLD_HEIGHT = 240
WORLD_PIXEL_SCALE = 80
local WALL_FRICTION <const> = 0.2
WALL_WIDTH = 150
local PAD <const> = 10
MAX_ANGLE = 0.3
BOX_COUNT = 20

world = nil
claw = nil
floor = nil
left_wall = nil
right_wall = nil
selected_toy = nil
TOYS = {}
fg_boxes = {}

local MASS_MIN <const> = 50
local MASS_MAX <const> = 120

function draw_polygon(object)
  local polygon = geometry.polygon.new(object:getPolygon())
  polygon:close()
  gfx.setColor(gfx.kColorWhite)
  gfx.fillPolygon(polygon)
end

function Init_world()
  Reset_gameplay_entities()
end

function add_fg_boxes()
  local box = playbox.body.new(70, 25, 0)
  box:setCenter(360, 246)
  box:setRotation(0.25)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(30, 30, 0)
  box:setCenter(308, 240)
  box:setRotation(0.25)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(42, 32, 0)
  box:setCenter(269, 245)
  box:setRotation(0.1)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(40, 32, 0)
  box:setCenter(210, 243)
  box:setRotation(0.15)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(20, 50, 0)
  box:setCenter(236, 243)
  box:setRotation(0.15)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(50, 32, 0)
  box:setCenter(160, 245)
  box:setRotation(0.7)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(70, 50, 0)
  box:setCenter(130, 260)
  box:setRotation(0.7)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(30, 30, 0)
  box:setCenter(82, 245)
  box:setRotation(0.7)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(30, 30, 0)
  box:setCenter(52, 247)
  box:setRotation(0.1)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)

  box = playbox.body.new(30, 30, 0)
  box:setCenter(22, 245)
  box:setRotation(0.7)
  box:setFriction(WALL_FRICTION)
  world:addBody(box)
  table.insert(fg_boxes, box)
end


function Reset_gameplay_entities()
  -- Remove all entities if needed
  if world then
    claw:destructor()
    claw = nil
    floor = nil
    left_wall = nil
    right_wall = nil
    selected_toy = nil
    for _, toy in ipairs(TOYS) do
      toy:destructor(world)
    end
    TOYS = {}
    world = nil
  end
  
  -- Create world
  world = playbox.world.new(0.0, 9.81, 10)
  world:setPixelScale(WORLD_PIXEL_SCALE)

  -- Create floor
  floor = playbox.body.new(WORLD_WIDTH, WALL_WIDTH, 0)
  floor:setCenter(WORLD_WIDTH * 0.5, WORLD_HEIGHT + WALL_WIDTH * 0.5 + PAD)
  floor:setFriction(WALL_FRICTION)
  world:addBody(floor)

  add_fg_boxes()

  local wall_height <const> = WORLD_HEIGHT - CEILING_HEIGHT_MIN
  print(wall_height)

  -- Create wall
  left_wall = playbox.body.new(WALL_WIDTH, wall_height, 0)
  left_wall:setCenter(-WALL_WIDTH * 0.5 - 2 * PAD, wall_height * 0.5)
  left_wall:setFriction(WALL_FRICTION)
  world:addBody(left_wall)

  right_wall = playbox.body.new(WALL_WIDTH, wall_height, 0)
  right_wall:setCenter(WORLD_WIDTH + WALL_WIDTH * 0.5 + 2 * PAD, wall_height * 0.5)
  right_wall:setFriction(WALL_FRICTION)
  world:addBody(right_wall)

  -- Create all entities

  local spawn_height = 200
  local peedee_toy = Toy.new(TOYS_INSTRUCTIONS.peedee, world)
  peedee_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = peedee_toy

  local monkey_toy = Toy.new(TOYS_INSTRUCTIONS.monkey, world)
  monkey_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = monkey_toy

  local mouse_toy = Toy.new(TOYS_INSTRUCTIONS.mouse, world)
  mouse_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = mouse_toy

  local toast_toy = Toy.new(TOYS_INSTRUCTIONS.toast, world)
  toast_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = toast_toy

  local crab_toy = Toy.new(TOYS_INSTRUCTIONS.crab, world)
  crab_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = crab_toy

  local cactus_toy = Toy.new(TOYS_INSTRUCTIONS.cactus, world)
  cactus_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = cactus_toy

  local fish_toy = Toy.new(TOYS_INSTRUCTIONS.fish, world)
  fish_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = fish_toy

  local cat_toy = Toy.new(TOYS_INSTRUCTIONS.cat, world)
  cat_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = cat_toy

  local chicken_toy = Toy.new(TOYS_INSTRUCTIONS.chicken, world)
  chicken_toy:move(geometry.vector2D.new(math.random(25,375), spawn_height))
  TOYS[#TOYS + 1] = chicken_toy

  -- Create claw
  claw = Claw(2)
end
