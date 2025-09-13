local geo = playdate.geometry


local assembly_instructions = {
    peedee = {
        collision_main = {
            position = geo.vector2D(-12, 1),
            rotation = 10.8854,
            dimensions = geo.vector2D(50, 60),
        },
        collision_arm = {
            position = geo.vector2D(-31, -17),
            rotation = -34.2189,
            dimensions = geo.vector2D(21, 19),
        },
        anchor_arm = {
            position = geo.vector2D(16, -21),
        },
    },
    monkey = {
        collision_main = {
            position = geo.vector2D(10, 2),
            rotation = 2.10368,
            dimensions = geo.vector2D(37.4, 72.8),
        },
        collision_tail = {
            position = geo.vector2D(26, 24),
            rotation = -51.2069,
            dimensions = geo.vector2D(20.7, 20.1),
        },
        anchor_tail = {
            position = geo.vector2D(7, 22),
        },
    },
    mouse = {
        collision_main = {
            position = geo.vector2D(0, 3),
            rotation = -2.48848,
            dimensions = geo.vector2D(16.6, 18.4),
        },
        collision_head = {
            position = geo.vector2D(1, -22),
            rotation = -9.42672,
            dimensions = geo.vector2D(50.7, 24.3),
        },
        collision_feet = {
            position = geo.vector2D(-1, 26),
            rotation = -2.40257,
            dimensions = geo.vector2D(55.7, 20.1),
        },
        anchor_head = {
            position = geo.vector2D(1, -6),
        },
        anchor_foot = {
            position = geo.vector2D(0, 12),
        },
    },
    toast = {
        collision_main = {
            position = geo.vector2D(-1, -1),
            rotation = -3.29623,
            dimensions = geo.vector2D(69.6, 54.5),
        },
    },
    crab = {
        sprite_claw_right = {
            position = geo.vector2D(4, 0),
        },
        collision_main = {
            position = geo.vector2D(1, 10),
            rotation = -1.75174,
            dimensions = geo.vector2D(44.7, 24.8),
        },
        collision_claw_right = {
            position = geo.vector2D(31, -11),
            rotation = 42.7352,
            dimensions = geo.vector2D(20.5, 20.6),
        },
        collision_claw_left = {
            position = geo.vector2D(-31, -13),
            rotation = -37.8537,
            dimensions = geo.vector2D(22.6, 20),
        },
        anchor_claw_right = {
            position = geo.vector2D(22, -2),
        },
        anchor_claw_left = {
            position = geo.vector2D(-18, -1),
        },
    },
    cactus = {
        collision_main = {
            position = geo.vector2D(2, 1),
            rotation = -15.7791,
            dimensions = geo.vector2D(14.9, 41.7),
        },
        collision_arm = {
            position = geo.vector2D(-11, -13),
            rotation = 30.7259,
            dimensions = geo.vector2D(11.9, 12.1),
        },
        anchor_arm = {
            position = geo.vector2D(-6, -11),
        },
    },
    fish = {
        collision_main = {
            position = geo.vector2D(-9, 4),
            rotation = -6.10786,
            dimensions = geo.vector2D(25.5, 21.5),
        },
        collision_tail = {
            position = geo.vector2D(13, -9),
            rotation = -46.1007,
            dimensions = geo.vector2D(21.9, 11.5),
        },
        anchor_tail = {
            position = geo.vector2D(3, -3),
        },
    },
}