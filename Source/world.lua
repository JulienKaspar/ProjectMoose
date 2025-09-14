local gfx <const> = playdate.graphics
local geometry <const> = playdate.geometry

import "toys"
import "claw"

WORLD_WIDTH = 400
WORLD_HEIGHT = 240
WORLD_PIXEL_SCALE = 80
local WALL_FRICTION <const> = 0.2
WALL_WIDTH = 50
local PAD <const> = 10
MAX_ANGLE = 0.5
BOX_COUNT = 20

world = nil
claw = nil
floor = nil
left_wall = nil
right_wall = nil
selected_toy = nil
TOYS = {}

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


function Reset_gameplay_entities()
  -- Remove all entities if needed
  if world then
    world = nil
    claw:destructor()
    claw = nil
    floor = nil
    left_wall = nil
    right_wall = nil
    selected_toy = nil
    for _, toy in ipairs(TOYS) do
      toy:destructor()
    end
    TOYS = {}
  end
  
  -- Create world
  world = playbox.world.new(0.0, 9.81, 10)
  world:setPixelScale(WORLD_PIXEL_SCALE)

  -- Create floor
  floor = playbox.body.new(WORLD_WIDTH, WALL_WIDTH, 0)
  floor:setCenter(WORLD_WIDTH * 0.5, WORLD_HEIGHT + WALL_WIDTH * 0.5 + PAD)
  floor:setFriction(WALL_FRICTION)
  world:addBody(floor)

  -- Create wall
  left_wall = playbox.body.new(WALL_WIDTH, WORLD_HEIGHT, 0)
  left_wall:setCenter(-WALL_WIDTH * 0.5 - 2 * PAD, WORLD_HEIGHT * 0.5)
  left_wall:setFriction(WALL_FRICTION)
  world:addBody(left_wall)

  right_wall = playbox.body.new(WALL_WIDTH, WORLD_HEIGHT, 0)
  right_wall:setCenter(WORLD_WIDTH + WALL_WIDTH * 0.5 + 2 * PAD, WORLD_HEIGHT * 0.5)
  right_wall:setFriction(WALL_FRICTION)
  world:addBody(right_wall)

  -- Create all entities

  local peedee_toy = Toy.new(TOYS_INSTRUCTIONS.peedee, world)
  peedee_toy:move(geometry.vector2D.new(80, 50))
  TOYS[#TOYS + 1] = peedee_toy

  local monkey_toy = Toy.new(TOYS_INSTRUCTIONS.monkey, world)
  monkey_toy:move(geometry.vector2D.new(130, 140))
  TOYS[#TOYS + 1] = monkey_toy

  local mouse_toy = Toy.new(TOYS_INSTRUCTIONS.mouse, world)
  mouse_toy:move(geometry.vector2D.new(180, 140))
  TOYS[#TOYS + 1] = mouse_toy

  local toast_toy = Toy.new(TOYS_INSTRUCTIONS.toast, world)
  toast_toy:move(geometry.vector2D.new(230, 140))
  TOYS[#TOYS + 1] = toast_toy

  local crab_toy = Toy.new(TOYS_INSTRUCTIONS.crab, world)
  crab_toy:move(geometry.vector2D.new(270, 140))
  TOYS[#TOYS + 1] = crab_toy

  local cactus_toy = Toy.new(TOYS_INSTRUCTIONS.cactus, world)
  cactus_toy:move(geometry.vector2D.new(300, 140))
  TOYS[#TOYS + 1] = cactus_toy

  local fish_toy = Toy.new(TOYS_INSTRUCTIONS.fish, world)
  fish_toy:move(geometry.vector2D.new(330, 140))
  TOYS[#TOYS + 1] = fish_toy

  -- Select a random toy
  local random_i = math.random(#TOYS)
  selected_toy = TOYS[random_i]

  -- Create claw
  claw = Claw(-20)
end
