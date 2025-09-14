local geo = playdate.geometry
local gfx = playdate.graphics

TOYS_INSTRUCTIONS = {
  peedee = {
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
  monkey = {
    bodies = {
      {
        position = geo.vector2D.new(10, 2),
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
  mouse = {
    bodies = {
      {
        position = geo.vector2D.new(0, 3),
        rotation = -2.48848,
        dimensions = geo.vector2D.new(16.6, 18.4),
        img = gfx.image.new("images/toys/mouse_body.png"),
      },
      {
        position = geo.vector2D.new(1, -22),
        rotation = -9.42672,
        dimensions = geo.vector2D.new(50.7, 24.3),
        img = gfx.image.new("images/toys/mouse_head.png"),
      },
      {
        position = geo.vector2D.new(-1, 26),
        rotation = -2.40257,
        dimensions = geo.vector2D.new(55.7, 20.1),
        img = gfx.image.new("images/toys/mouse_feet.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(1, -6),
      },
      {
        body1 = 1,
        body2 = 3,
        position = geo.vector2D.new(0, 12),
      }
    }
  },
  toast = {
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
  crab = {
    -- sprite_claw_right = {
    --   position = geo.vector2D.new(4, 0),
    -- },
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
  cactus = {
    bodies = {
      {
        position = geo.vector2D.new(2, 1),
        rotation = -15.7791,
        dimensions = geo.vector2D.new(14.9, 41.7),
        img = gfx.image.new("images/toys/cactus_main.png"),
      },
      {
        position = geo.vector2D.new(-11, -13),
        rotation = 30.7259,
        dimensions = geo.vector2D.new(11.9, 12.1),
        img = gfx.image.new("images/toys/cactus_arm.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(-6, -11),
      }
    }
  },
  fish = {
    bodies = {
      {
        position = geo.vector2D.new(-9, 4),
        rotation = -6.10786,
        dimensions = geo.vector2D.new(25.5, 21.5),
        img = gfx.image.new("images/toys/fish_main.png"),
      },
      {
        position = geo.vector2D.new(13, -9),
        rotation = -46.1007,
        dimensions = geo.vector2D.new(21.9, 11.5),
        img = gfx.image.new("images/toys/fish_tail.png"),
      }
    },
    joints = {
      {
        body1 = 1,
        body2 = 2,
        position = geo.vector2D.new(3, -3),
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
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.sprites = {}
  self.bodies = {}
  self.initial_rotations = {}
  self.joints = {}
  for _, body_instr in ipairs(instr.bodies) do
    local mass <const> = (body_instr.dimensions.x * body_instr.dimensions.y) * 0.025
    local body = playbox.body.new(body_instr.dimensions.x, body_instr.dimensions.y, mass)
    body:setCenter(body_instr.position.x, body_instr.position.y)
    body:setRotation(math.rad(body_instr.rotation))
    body:setFriction(100)
    world:addBody(body)
    self.sprites[#self.sprites + 1] = body_instr.img
    self.bodies[#self.bodies + 1] = body
    self.initial_rotations[#self.initial_rotations + 1] = body_instr.rotation 
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

  return o
end

function Toy:move(offset)
  for _, body in ipairs(self.bodies) do
    local pos = geo.vector2D.new(body:getCenter())
    pos = pos + offset
    body:setCenter(pos.x, pos.y)
  end
end
