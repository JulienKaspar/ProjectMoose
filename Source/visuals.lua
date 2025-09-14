local gfx <const> = playdate.graphics
local gfxi <const> = playdate.graphics.image
local gfxit <const> = playdate.graphics.imagetable
local geometry <const> = playdate.geometry

-- Image Passes
TEXTURES = {}
ANIMATIONS = {}


-- Debug / Development

local function draw_test_dither_patterns()

    local dither_types = {
        gfxi.kDitherTypeNone,
        gfxi.kDitherTypeDiagonalLine,
        gfxi.kDitherTypeVerticalLine,
        gfxi.kDitherTypeHorizontalLine,
        gfxi.kDitherTypeScreen,
        gfxi.kDitherTypeBayer2x2,
        gfxi.kDitherTypeBayer4x4,
        gfxi.kDitherTypeBayer8x8,
        gfxi.kDitherTypeFloydSteinberg,
        gfxi.kDitherTypeBurkes,
        gfxi.kDitherTypeAtkinson
    }
    local size = 20
    local x = 2
    local y = 2

    gfx.pushContext()
        gfx.setColor(gfx.kColorWhite)

        -- kDitherTypeBayer8x8 gradient
        local dither_type = gfxi.kDitherTypeBayer8x8
        local pattern_img = gfxi.new(size, size, gfx.kColorBlack)
        for i = 0, 10, 1 do
            pattern_img:clear(gfx.kColorBlack)
            gfx.pushContext(pattern_img)
                gfx.setDitherPattern(i/10, dither_type)
                gfx.fillRect(0, 0, size, size)
            gfx.popContext()
            pattern_img:draw(x, y)
            y += size+2
        end

        -- different types
        local alpha = 0.0
        for a = 0, 10, 1 do
            y = 2
            x += size
            for i = 0, 10, 1 do
                pattern_img:clear(gfx.kColorBlack)
                gfx.pushContext(pattern_img)
                    gfx.setDitherPattern(alpha, dither_types[i+1])
                    gfx.fillRect(0, 0, size, size)
                gfx.popContext()
                pattern_img:draw(x, y)
                y += size+2
            end
            alpha += 0.1
        end
     gfx.popContext()

end


-- Draw passes

local function draw_game_background( x, y, width, height )

    -- Draw full screen background.
    gfx.pushContext()
        TEXTURES.bg:draw(0, 0)
    gfx.popContext()

end


local function draw_game_foreground( x, y, width, height )

    -- Draw full screen background.
    gfx.pushContext()
        TEXTURES.fg:draw(0, 0)
    gfx.popContext()

end


local function draw_hud()
    if MENU_STATE.screen ~= MENU_SCREEN.gameplay 
        and MENU_STATE.screen ~= MENU_SCREEN.gameover 
    then
        return
    end

    local heart1_pos = geometry.vector2D.new(31, 1)
    local heart2_pos = geometry.vector2D.new(71, 1)
    local heart3_pos = geometry.vector2D.new(111, 1)
    
    if GAMEPLAY_STATE.current_strikes == 0 then
        TEXTURES.heart_full:draw(heart1_pos.dx, heart1_pos.dy)
        TEXTURES.heart_full:draw(heart2_pos.dx, heart2_pos.dy)
        TEXTURES.heart_full:draw(heart3_pos.dx, heart3_pos.dy)
    elseif GAMEPLAY_STATE.current_strikes == 1 then
        TEXTURES.heart_full:draw(heart1_pos.dx, heart1_pos.dy)
        TEXTURES.heart_full:draw(heart2_pos.dx, heart2_pos.dy)
        TEXTURES.heart_broken:draw(heart3_pos.dx, heart3_pos.dy)
    elseif GAMEPLAY_STATE.current_strikes == 2 then
        TEXTURES.heart_full:draw(heart1_pos.dx, heart1_pos.dy)
        TEXTURES.heart_broken:draw(heart2_pos.dx, heart2_pos.dy)
        TEXTURES.heart_broken:draw(heart3_pos.dx, heart3_pos.dy)
    elseif GAMEPLAY_STATE.current_strikes == 3 then
        TEXTURES.heart_broken:draw(heart1_pos.dx, heart1_pos.dy)
        TEXTURES.heart_broken:draw(heart2_pos.dx, heart2_pos.dy)
        TEXTURES.heart_broken:draw(heart3_pos.dx, heart3_pos.dy)
    end
end


function kiddo_goes_idle()
    ANIMATIONS.kiddo_idle:setVisible(true)
    ANIMATIONS.kiddo_idle:playAnimation()

    ANIMATIONS.kiddo_angry:setVisible(false)
    ANIMATIONS.kiddo_happy:setVisible(false)
    
end


function kiddo_is_pleased()
    ANIMATIONS.kiddo_happy:setVisible(true)
    ANIMATIONS.kiddo_happy:playAnimation()

    ANIMATIONS.kiddo_idle:setVisible(false)
    ANIMATIONS.kiddo_angry:setVisible(false)
    
end


function kiddo_gets_mad()
    ANIMATIONS.kiddo_angry:setVisible(true)
    ANIMATIONS.kiddo_angry:playAnimation()

    ANIMATIONS.kiddo_idle:setVisible(false)
    ANIMATIONS.kiddo_happy:setVisible(false)
    
end


local function draw_debug()
    -- Draw FPS on device
    if not playdate.isSimulator then
        gfx.pushContext()
            gfx.setLineWidth(1)
            gfx.setDitherPattern(0.5)
            playdate.drawFPS(380, 15)
        gfx.popContext()
    end

    -- Visual representation of out of bounds colliders
    claw:draw_debug()
    draw_polygon(floor)
    draw_polygon(left_wall)
    draw_polygon(right_wall)
end

function draw_toys()
  for _, toy in ipairs(TOYS) do
    for i, body in ipairs(toy.bodies) do
      --- DEBUG boxes
      local box_polygon = geometry.polygon.new(body:getPolygon())
      box_polygon:close()
      gfx.setColor(gfx.kColorWhite)
      gfx.fillPolygon(box_polygon)

      local image = toy.sprites[i]
      local pos <const> = geometry.vector2D.new(body:getCenter())
      --- Undo the initial rotation of the sprite
      local angle <const> = body:getRotation() + math.rad(toy.initial_rotations[i])
      image:drawRotated(pos.x, pos.y, math.deg(angle), 0.25)
    end
  end
end


-- Set a draw pass on Z depth

function Set_draw_pass(z, drawCallback)
    local sprite = gfx.sprite.new()
    sprite:setSize(playdate.display.getSize())
    sprite:setCenter(0, 0)
    sprite:moveTo(0, 0)
    sprite:setZIndex(z)
    sprite:setIgnoresDrawOffset(true)
    sprite:setUpdatesEnabled(false)
    sprite.draw = function(s, x, y, w, h)
        drawCallback(x, y, w, h)
    end
    sprite:add()
    return sprite
end

-- Load resources and initialize draw passes

function Init_visuals()

    -- init animations

    local imagetable_kiddo_idle = gfxit.new("images/kiddo_anims/kiddo_idle")
    local imagetable_kiddo_anger = gfxit.new("images/kiddo_anims/kiddo_anger")
    local imagetable_kiddo_happy = gfxit.new("images/kiddo_anims/kiddo_happy")
    local kiddo_pos = geometry.vector2D.new(272, 100)

    ANIMATIONS.kiddo_idle = AnimatedSprite.new(imagetable_kiddo_idle)
    ANIMATIONS.kiddo_idle:addState(
            "main",
            1,
            imagetable_kiddo_idle:getLength(),
            {
                tickStep = 30.0/1.0,
                loop = true,
            }
        ).asDefault()
    ANIMATIONS.kiddo_idle:playAnimation()
    ANIMATIONS.kiddo_idle:moveTo(kiddo_pos.dx,kiddo_pos.dy)

    ANIMATIONS.kiddo_angry = AnimatedSprite.new(imagetable_kiddo_anger)
    ANIMATIONS.kiddo_angry:addState(
            "main",
            1,
            imagetable_kiddo_anger:getLength(),
            {
                tickStep = 30.0/5.0,
                loop = false,
                onAnimationEndEvent = function (self) kiddo_goes_idle() end
            }
        ).asDefault()
    ANIMATIONS.kiddo_angry:moveTo(kiddo_pos.dx,kiddo_pos.dy)

    ANIMATIONS.kiddo_happy = AnimatedSprite.new(imagetable_kiddo_happy)
    ANIMATIONS.kiddo_happy:addState(
            "main",
            1,
            imagetable_kiddo_happy:getLength(),
            {
                tickStep = 30.0/2.0,
                loop = false,
                onAnimationEndEvent = function (self) kiddo_goes_idle() end
            }
        ).asDefault()
    ANIMATIONS.kiddo_happy:moveTo(kiddo_pos.dx,kiddo_pos.dy)

    -- Load image layers.
    TEXTURES.bg = gfxi.new("images/environment/bg")
    TEXTURES.fg = gfxi.new("images/environment/fg")
    TEXTURES.heart_full = gfxi.new("images/ui_elements/heart_full")
    TEXTURES.heart_broken = gfxi.new("images/ui_elements/heart_broken")

    -- Set the multiple things in their Z order of what overlaps what.
    Set_draw_pass(-40, draw_game_background)
    ANIMATIONS.kiddo_idle:setZIndex(-39)
    ANIMATIONS.kiddo_angry:setZIndex(-39)
    ANIMATIONS.kiddo_happy:setZIndex(-39)
    -- Set_draw_pass(-30, draw_toys())
    -- Set_draw_pass(-20, draw_claw())
    Set_draw_pass(0, draw_game_foreground)
    Set_draw_pass(20, draw_hud)
    Set_draw_pass(30, draw_debug)
    --Set_draw_pass(20, draw_test_dither_patterns)
end
