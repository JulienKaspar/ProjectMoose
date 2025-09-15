local gfx <const> = playdate.graphics
local gfxi <const> = playdate.graphics.image
local gfxit <const> = playdate.graphics.imagetable
local geometry <const> = playdate.geometry

-- Image Passes
TEXTURES = {}
ANIMATIONS = {}

IMAGE_ROTATION_INCREMENT = 36
IMAGE_SCALING = 0.25

local heart1_pos = geometry.vector2D.new(31, 1)
local heart2_pos = geometry.vector2D.new(71, 1)
local heart3_pos = geometry.vector2D.new(111, 1)
local heart1_anim_pos = geometry.vector2D.new(53, 21)
local heart2_anim_pos = geometry.vector2D.new(93, 21)
local heart3_anim_pos = geometry.vector2D.new(133, 21)


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
        TEXTURES.static_fg_toys:draw(0, 210)
        TEXTURES.fg:draw(0, 0)
    gfx.popContext()

end


local function draw_hud()
    if MENU_STATE.screen ~= MENU_SCREEN.gameplay 
        and MENU_STATE.screen ~= MENU_SCREEN.gameover 
    then
        return
    end
    
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
    -- Kiddo animation
    ANIMATIONS.kiddo_happy:setVisible(true)
    ANIMATIONS.kiddo_happy:playAnimation()

    ANIMATIONS.kiddo_idle:setVisible(false)
    ANIMATIONS.kiddo_angry:setVisible(false)
    
    -- Heart animation
    ANIMATIONS.heart_mending:setVisible(true)
    -- Which heart is getting mended
    if GAMEPLAY_STATE.current_strikes == 0 and GAMEPLAY_STATE.previous_strikes == 1 then
        ANIMATIONS.heart_mending:moveTo(heart3_anim_pos.dx, heart3_anim_pos.dy)
        ANIMATIONS.heart_mending:playAnimation()
    elseif GAMEPLAY_STATE.current_strikes == 1 then
        ANIMATIONS.heart_mending:moveTo(heart2_anim_pos.dx, heart2_anim_pos.dy)
        ANIMATIONS.heart_mending:playAnimation()
    else
        ANIMATIONS.heart_mending:setVisible(false)
    end
end


function kiddo_gets_mad()
    -- Kiddo animation
    ANIMATIONS.kiddo_angry:setVisible(true)
    ANIMATIONS.kiddo_angry:playAnimation()

    ANIMATIONS.kiddo_idle:setVisible(false)
    ANIMATIONS.kiddo_happy:setVisible(false)

    -- Heart animation
    -- Heart animation
    ANIMATIONS.heart_breaking:setVisible(true)
    ANIMATIONS.heart_breaking:playAnimation()

    -- Which heart is getting mended
    if GAMEPLAY_STATE.current_strikes == 1 then
        ANIMATIONS.heart_breaking:moveTo(heart3_anim_pos.dx, heart3_anim_pos.dy)
        ANIMATIONS.heart_breaking:playAnimation()
    elseif GAMEPLAY_STATE.current_strikes == 2 then
        ANIMATIONS.heart_breaking:moveTo(heart2_anim_pos.dx, heart2_anim_pos.dy)
        ANIMATIONS.heart_breaking:playAnimation()
    elseif GAMEPLAY_STATE.current_strikes == 3 then
        ANIMATIONS.heart_breaking:moveTo(heart1_anim_pos.dx, heart1_anim_pos.dy)
        ANIMATIONS.heart_breaking:playAnimation()
    else
        ANIMATIONS.heart_breaking:setVisible(false)
    end
    
end


function on_heart_mending_finished()
    ANIMATIONS.heart_mending:setVisible(false)
end


function on_heart_breaking_finished()
    ANIMATIONS.heart_breaking:setVisible(false)
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
    draw_polygon(claw.ceiling)
    -- for _, box in ipairs(fg_boxes) do
    --     draw_polygon(box)
    -- end
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
    local kiddo_pos = geometry.vector2D.new(272, 99)

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

    -- local imagetable_broken_heart = gfxit.new("images/ui_elements/heart_anims/broken_heart_fixed")
    local imagetable_mending_fixed = gfxit.new("images/ui_elements/heart_anims/broken_heart_fixed")
    local imagetable_breaking_heart = gfxit.new("images/ui_elements/heart_anims/heart_breaking")
    
    ANIMATIONS.heart_mending = AnimatedSprite.new(imagetable_mending_fixed)
    ANIMATIONS.heart_mending:addState(
            "main",
            1,
            imagetable_mending_fixed:getLength(),
            {
                tickStep = 30.0/8.0,
                loop = false,
                onAnimationEndEvent = function (self) on_heart_mending_finished() end
            }
        ).asDefault()
    ANIMATIONS.heart_mending:moveTo(heart3_pos.dx, heart3_pos.dy)
    ANIMATIONS.heart_mending:setVisible(false)

    ANIMATIONS.heart_breaking = AnimatedSprite.new(imagetable_breaking_heart)
    ANIMATIONS.heart_breaking:addState(
            "main",
            1,
            imagetable_breaking_heart:getLength(),
            {
                tickStep = 30.0/8.0,
                loop = false,
                onAnimationEndEvent = function (self) on_heart_breaking_finished() end
            }
        ).asDefault()
    ANIMATIONS.heart_breaking:moveTo(heart3_pos.dx, heart3_pos.dy)
    ANIMATIONS.heart_breaking:setVisible(false)

    local imagetable_highlight_fx = gfxit.new("images/fx/highlight_fx")
    ANIMATIONS.highlight_fx = AnimatedSprite.new(imagetable_highlight_fx)
    ANIMATIONS.highlight_fx:addState(
            "main",
            1,
            imagetable_highlight_fx:getLength(),
            {
                tickStep = 30.0/2.0,
                loop = true,
            }
        ).asDefault()
    ANIMATIONS.highlight_fx:playAnimation()

    -- Load image layers.
    TEXTURES.bg = gfxi.new("images/environment/bg")
    TEXTURES.fg = gfxi.new("images/environment/fg")
    TEXTURES.static_fg_toys = gfxi.new("images/environment/static_fg_toys")
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
    ANIMATIONS.heart_mending:setZIndex(21)
    ANIMATIONS.heart_breaking:setZIndex(21)
    Set_draw_pass(30, draw_debug)
    ANIMATIONS.highlight_fx:setZIndex(25)
    --Set_draw_pass(20, draw_test_dither_patterns)
end

function makeRotationImageTable(image)
    local w, h = image:getSize()
    local sw, sh = w * IMAGE_SCALING, h * IMAGE_SCALING
    local max_wh = math.floor(math.sqrt(sw * sw + sh * sh)) + 1
    local image_table = gfx.imagetable.new(IMAGE_ROTATION_INCREMENT + 1, max_wh, max_wh)
    local image_index = 0
    for angle = 0 , 360, 360/IMAGE_ROTATION_INCREMENT do
        image_index += 1
        local rotated_image = gfx.image.new(max_wh, max_wh)
        gfx.lockFocus(rotated_image)
        image:drawRotated(max_wh/2, max_wh/2, angle, IMAGE_SCALING)
        gfx.unlockFocus()
        image_table:setImage(image_index, rotated_image)
    end
    return image_table
end
