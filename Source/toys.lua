local geo = playdate.geometry
local gfx = playdate.graphics

TOYS_INSTRUCTIONS = {
  -- peedee
  {
    bodies = {
      {
        position = geo.vector2D.new(-12, 1),
        rotation = 10.8854,
        dimensions = geo.vector2D.new(50, 60),
        img = gfx.image.new("images/toys/peedee_main.png"),
      },
      {
        position = geo.vector2D.new(31, -17),
        rotation = -34.2189,
        dimensions = geo.vector2D.new(21, 19),
        img = gfx.image.new("images/toys/peedee_arm.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(16, -21),
      }
    }
  },
  -- monkey
  {
    bodies = {
      {
        position = geo.vector2D.new(-10, 2),
        rotation = 2.10368,
        dimensions = geo.vector2D.new(37.4, 72.8),
        img = gfx.image.new("images/toys/monkey_main.png"),
      },
      {
        position = geo.vector2D.new(26, 24),
        rotation = -51.2069,
        dimensions = geo.vector2D.new(20.7, 20.1),
        img = gfx.image.new("images/toys/monkey_tail.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(7, 22),
      }
    }
  },
  -- mouse
  {
    bodies = {
      {
        position = geo.vector2D.new(-1, 26),
        rotation = -2.40257,
        dimensions = geo.vector2D.new(55.7, 20.1),
        img = gfx.image.new("images/toys/mouse_feet.png"),
      },
      {
        position = geo.vector2D.new(1, -22),
        rotation = -9.42672,
        dimensions = geo.vector2D.new(50.7, 24.3),
        img = gfx.image.new("images/toys/mouse_head.png"),
      },
      {
        position = geo.vector2D.new(0, 3),
        rotation = -2.48848,
        dimensions = geo.vector2D.new(16.6, 18.4),
        img = gfx.image.new("images/toys/mouse_body.png"),
      },
    },
    joints = {
      {
        body1 = 2,
        body2 = 3,
        position = geo.vector2D.new(1, -6),
      },
      {
        body1 = 1,
        body2 = 3,
        position = geo.vector2D.new(0, 12),
      }
    }
  },
  -- toast
  {
    bodies = {
      {
        position = geo.vector2D.new(0, 0),
        rotation = -3.29623,
        dimensions = geo.vector2D.new(69.6, 54.5),
        img = gfx.image.new("images/toys/toast.png"),
      }
    },
    joints = {}
  },
  -- crab
  {
    bodies = {
      {
        position = geo.vector2D.new(1, 10),
        rotation = -1.75174,
        dimensions = geo.vector2D.new(44.7, 24.8),
        img = gfx.image.new("images/toys/crab_main.png"),
      },
      {
        position = geo.vector2D.new(31, -11),
        rotation = 42.7352,
        dimensions = geo.vector2D.new(20.5, 20.6),
        img = gfx.image.new("images/toys/crab_claw_right.png"),
      },
      {
        position = geo.vector2D.new(-31, -13),
        rotation = -37.8537,
        dimensions = geo.vector2D.new(22.6, 20),
        img = gfx.image.new("images/toys/crab_claw_left.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(22, -2),
      },
      {
        body1 = 1,
        body2 = 3,
        position = geo.vector2D.new(-18, -1),
      },
    }
  },
  -- cactus
  {
    bodies = {
      {
        position = geo.vector2D.new(3, 1),
        rotation = -15.7791,
        dimensions = geo.vector2D.new(20.6, 57.5),
        img = gfx.image.new("images/toys/cactus_main.png"),
      },
      {
        position = geo.vector2D.new(-18, -21),
        rotation = 30.7259,
        dimensions = geo.vector2D.new(19.2, 19.5),
        img = gfx.image.new("images/toys/cactus_arm.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(-8, -14),
      }
    }
  },
  -- fish
  {
    bodies = {
      {
        position = geo.vector2D.new(13, -9),
        rotation = -46.1007,
        dimensions = geo.vector2D.new(21.9, 11.5),
        img = gfx.image.new("images/toys/fish_tail.png"),
      },
      {
        position = geo.vector2D.new(-9, 4),
        rotation = -6.10786,
        dimensions = geo.vector2D.new(25.5, 21.5),
        img = gfx.image.new("images/toys/fish_main.png"),
      },
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(3, -3),
      }
    }
  },
  -- cat
  {
    bodies = {
      {
        position = geo.vector2D.new(-7, 11),
        rotation = 17.2364,
        dimensions = geo.vector2D.new(38.2, 28.7),
        img = gfx.image.new("images/toys/cat_body.png"),
      },
      {
        position = geo.vector2D.new(30, -7),
        rotation = 27.0197,
        dimensions = geo.vector2D.new(28.7, 34.3),
        img = gfx.image.new("images/toys/cat_head.png"),
      },
      {
        position = geo.vector2D.new(-44, -11),
        rotation = 39.9932,
        dimensions = geo.vector2D.new(13.4, 31),
        img = gfx.image.new("images/toys/cat_tail.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(12, 5),
      },
      {
        body1 = 1,
        body2 = 3,
        position = geo.vector2D.new(-30, 3),
      }
    }
  },
  -- chicken
  {
    bodies = {
      {
        position = geo.vector2D.new(21, 25),
        rotation = 14.0097,
        dimensions = geo.vector2D.new(14.1, 15.0),
        img = gfx.image.new("images/toys/chicken_leg_back.png"),
      },
      {
        position = geo.vector2D.new(1, -4),
        rotation = -36.2071,
        dimensions = geo.vector2D.new(38.1, 40.5),
        img = gfx.image.new("images/toys/chicken_main.png"),
      },
      {
        position = geo.vector2D.new(-11, 28),
        rotation = -1.02813,
        dimensions = geo.vector2D.new(14.1, 15.0),
        img = gfx.image.new("images/toys/chicken_leg_front.png"),
      },
    },
    joints = {
      {
        body1 = 2,
        body2 = 3,
        position = geo.vector2D.new(-3, 20),
      },
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(10, 18),
      }
    }
  },
  -- bear
  {
    bodies = {
      {
        position = geo.vector2D.new(-29, 13),
        rotation = -6.66993,
        dimensions = geo.vector2D.new(10.3, 23.0),
        img = gfx.image.new("images/toys/bear_arm_back.png"),
      },
      {
        position = geo.vector2D.new(-2, 4),
        rotation = -6.15081,
        dimensions = geo.vector2D.new(39.6, 70.8),
        img = gfx.image.new("images/toys/bear_main.png"),
      },
      {
        position = geo.vector2D.new(27, 15),
        rotation = 8.00634,
        dimensions = geo.vector2D.new(13.0, 26.4),
        img = gfx.image.new("images/toys/bear_arm_front.png"),
      }
    },
    joints = {
      {
        body1 = 2,
        body2 = 3,
        position = geo.vector2D.new(19, 3),
      },
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(-23, 2),
      }
    }
  },
  -- frog
  {
    bodies = {
      {
        position = geo.vector2D.new(-1, 20),
        rotation = -3.80082,
        dimensions = geo.vector2D.new(85.8, 33.3),
        img = gfx.image.new("images/toys/frog.png"),
      },
      {
        position = geo.vector2D.new(-2, -18),
        rotation = -3.80082,
        dimensions = geo.vector2D.new(39.6, 26.3),
        img = gfx.image.new(64, 64),
      },
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(-4, 0),
      }
    }
  },
  -- knight
  {
    bodies = {
      {
        position = geo.vector2D.new(17, 18),
        rotation = 39.8936,
        dimensions = geo.vector2D.new(6.3, 21.9),
        img = gfx.image.new("images/toys/knight_nail.png"),
      },
      {
        position = geo.vector2D.new(-4, 18),
        rotation = 0.0,
        dimensions = geo.vector2D.new(15.7, 18.7),
        img = gfx.image.new("images/toys/knight_body.png"),
      },
      {
        position = geo.vector2D.new(-5, -11),
        rotation = 0.0,
        dimensions = geo.vector2D.new(29.6, 34),
        img = gfx.image.new("images/toys/knight_head.png"),
      }
    },
    joints = {
      {
        body1 = 2,
        body2 = 3,
        position = geo.vector2D.new(-4, 8),
      },
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(8, 8),
      }
    }
  },
  -- terror_bird
  {
    bodies = {
      {
        position = geo.vector2D.new(10, 10),
        rotation = -23.4308,
        dimensions = geo.vector2D.new(16.9, 16.2),
        img = gfx.image.new("images/toys/terrorbird_body.png"),
      },
      {
        position = geo.vector2D.new(-5, -23),
        rotation = 26.0954,
        dimensions = geo.vector2D.new(39.5, 42.8),
        img = gfx.image.new("images/toys/terrorbird_head.png"),
      },
      {
        position = geo.vector2D.new(11, 36),
        rotation = -2.34043,
        dimensions = geo.vector2D.new(45.1, 16.8),
        img = gfx.image.new("images/toys/terrorbird_feet.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(4, 0),
      },
      {
        body1 = 1,
        body2 = 3,
        position = geo.vector2D.new(12, 17),
      }
    }
  },
  -- pirate
  {
    bodies = {
      {
        position = geo.vector2D.new(0, 0),
        rotation = 10.9862,
        dimensions = geo.vector2D.new(47.2, 32.5),
        img = gfx.image.new("images/toys/pirate.png"),
      }
    },
    joints = {}
  },
  -- rogalik
  {
    bodies = {
      {
        position = geo.vector2D.new(0, 19),
        rotation = -3.43544,
        dimensions = geo.vector2D.new(17.0, 8.2),
        img = gfx.image.new("images/toys/rogalik_legs.png"),
      },
      {
        position = geo.vector2D.new(1, -1),
        rotation = -3.43544,
        dimensions = geo.vector2D.new(49.8, 24.4),
        img = gfx.image.new("images/toys/rogalik_main.png"),
      },
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(1, 7),
      }
    }
  },
  -- yellow
  {
    bodies = {
      {
        position = geo.vector2D.new(5, 14),
        rotation = 11.787,
        dimensions = geo.vector2D.new(33.0, 38.5),
        img = gfx.image.new("images/toys/yellow_main.png"),
      },
      {
        position = geo.vector2D.new(-21, -20),
        rotation = 19.1902,
        dimensions = geo.vector2D.new(18.6, 24.4),
        img = gfx.image.new("images/toys/yellow_tail.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(-1, -5),
      }
    }
  },
}

class('Toy').extends()

-- Base class method new
function Toy.new(instr, world)
  return Toy(instr, world)
end

function Toy:init(instr, world)
  self.imagetables = {}
  self.bodies = {}
  self.initial_rotations = {}
  self.joints = {}
  self.sprites = {}
  self.highlight = nil
  for _, body_instr in ipairs(instr.bodies) do
    local mass = (body_instr.dimensions.x * body_instr.dimensions.y) * 0.025
    -- TODO(weizhen): tweak
    mass = Clamp(mass, 50, 80)
    local body = playbox.body.new(body_instr.dimensions.x, body_instr.dimensions.y, mass)
    body:setCenter(body_instr.position.x, body_instr.position.y)
    body:setRotation(-math.rad(body_instr.rotation))
    body:setFriction(0.8)
    world:addBody(body)
    local image_table = makeRotationImageTable(body_instr.img)
    self.imagetables[#self.imagetables + 1] = image_table
    self.bodies[#self.bodies + 1] = body
    self.initial_rotations[#self.initial_rotations + 1] = body_instr.rotation
    self.sprites[#self.sprites + 1] = gfx.sprite.new()
    self.sprites[#self.sprites]:add()
  end
  for _, joint_instr in ipairs(instr.joints) do
    local body1 = self.bodies[joint_instr.body1]
    local body2 = self.bodies[joint_instr.body2]
    local joint = playbox.joint.new(body1, body2, joint_instr.position.x, joint_instr.position.y)
    joint:setBiasFactor(0.5)
    joint:setSoftness(0.0)
    world:addJoint(joint)
    self.joints[#self.joints + 1] = joint
  end
end

function Toy:move(offset)
  for _, body in ipairs(self.bodies) do
    local pos = geo.vector2D.new(body:getCenter())
    pos = pos + offset
    body:setCenter(pos.x, pos.y)
  end
end

function Toy:updateSprites()
  for i, body in ipairs(self.bodies) do
    local image_table = self.imagetables[i]
    local pos <const> = geo.vector2D.new(body:getCenter())
    --- Undo the initial rotation of the sprite
    local angle = body:getRotation() + math.rad(self.initial_rotations[i])
    while angle < 0.0 do
      angle += 2.0 * math.pi
    end
    local angle_incr <const> = 360 / IMAGE_ROTATION_INCREMENT
    local n = (math.floor(math.deg(angle) / angle_incr) % image_table:getLength()) + 1
    local image = image_table:getImage(n)
    self.sprites[i]:setImage(image)
    self.sprites[i]:moveTo(pos.x, pos.y)
    if i == 1 and self.highlight then
      self.highlight:moveTo(pos.x, pos.y)
    end
  end
end

function Toy:destructor(world)
    for _, sprite in ipairs(self.sprites) do
        sprite:remove()
    end
    if self.highlight then
      self.highlight = nil
    end
    for _, body in ipairs(self.bodies) do
        world:removeBody(body)
    end
    for _, joint in ipairs(self.joints) do
        world:removeJoint(joint)
    end
end

function Toy:setHighlight()
  if self.highlight == nil then
    self.highlight = ANIMATIONS.highlight_fx
    self.highlight:setVisible(true)
    self.highlight:setZIndex(1)

    for _, sprite in ipairs(self.sprites) do
      sprite:setZIndex(3)
    end
  end
end

function Toy:removeHighlight()
  if self.highlight then
    self.highlight:setVisible(false)
    self.highlight = nil
    for _, sprite in ipairs(self.sprites) do
      sprite:setZIndex(0)
    end
  end
end
