import 'AnimatedSprite'

local gfx <const> = playdate.graphics
local gfxi <const> = playdate.graphics.image
local gfxit <const> = playdate.graphics.imagetable

MENU_STATE = {}
MENU_SCREEN = { gameplay = 0, gameover = 1, how_to = 2, main = 3, credits = 4, loading = 5, win = 6,}
UI_TEXTURES = {}
UI_ANIMATIONS = {}


Overlay_loading = false


-- System Menu

local function add_system_menu_entries()

    local menu = playdate.getSystemMenu()
    menu:removeAllMenuItems() -- ensure there's no duplicated entries.

    -- Add custom entries to system menu.

    local menuItem, error = menu:addMenuItem("restart", function()
        Reset_gameplay()
    end)
    local menuItem, error = menu:addMenuItem("main menu", function()
        Reset_gameplay()
        Enter_menu_main()
    end)
end

local function remove_system_menu_entries()
    playdate.getSystemMenu():removeAllMenuItems()
end


-- Menu State Transitions

function Enter_loading_screen()
    MENU_STATE.screen = MENU_SCREEN.loading
    SOUND.loading_screen:play()
end


function Enter_menu_main()
    MENU_STATE.screen = MENU_SCREEN.main

    Hide_all_hearts()

    remove_system_menu_entries()

    SOUND.bg_loop_gameplay:stop()

    if not SOUND.bg_loop_menu:isPlaying() then
        SOUND.bg_loop_menu:play(0)
    end
end


local function enter_menu_credits()
    MENU_STATE.screen = MENU_SCREEN.credits
end


local function enter_how_to_screen()
    MENU_STATE.screen = MENU_SCREEN.how_to
end


function Enter_game_over_screen()
    MENU_STATE.screen = MENU_SCREEN.gameover
end


function Enter_win_screen()
    MENU_STATE.screen = MENU_SCREEN.win
end


function Enter_gameplay()
    MENU_STATE.screen = MENU_SCREEN.gameplay

    SOUND.bg_loop_menu:stop()
    
    if not SOUND.bg_loop_gameplay:isPlaying() then
        SOUND.bg_loop_gameplay:play(0)
    end
    add_system_menu_entries()

    select_random_toy()

    Reset_hearts()
end



-- Draw & Update

local function draw_ui()
    -- Hide all elements before showing only the ones that are required
    for k, anim in pairs(UI_ANIMATIONS) do
        anim:setVisible(false)
    end
    
    -- Draw and show menu elements.
    if MENU_STATE.screen == MENU_SCREEN.gameplay then
        return

    elseif MENU_STATE.screen == MENU_SCREEN.loading then
        UI_ANIMATIONS.loading:setVisible(true)
        UI_ANIMATIONS.logo:setVisible(true)
    
    elseif MENU_STATE.screen == MENU_SCREEN.main then
        UI_ANIMATIONS.logo:setVisible(true)
        UI_TEXTURES.startgame_credits_indicator:draw(191, 9)
    
    elseif MENU_STATE.screen == MENU_SCREEN.credits then
        UI_TEXTURES.credits:draw(0, 0)
    
    elseif MENU_STATE.screen == MENU_SCREEN.gameover then
        UI_TEXTURES.game_over_indicator:draw(124, 80)
        UI_TEXTURES.failed_header:draw(94, 8)
    elseif MENU_STATE.screen == MENU_SCREEN.win then
        UI_TEXTURES.game_over_indicator:draw(124, 80)
        UI_TEXTURES.success_header:draw(90, 6)
    elseif MENU_STATE.screen == MENU_SCREEN.how_to then
        UI_TEXTURES.instructions:draw(58, 3)
    end
end


function draw_loading_popup()
    if Overlay_loading then
        UI_TEXTURES.resetting:draw(0, 0)
    end
end

local one_frame_delay

function Handle_menu_input()
    if MENU_STATE.screen == MENU_SCREEN.gameover
    or MENU_STATE.screen == MENU_SCREEN.win then
        if playdate.buttonJustPressed( playdate.kButtonA ) then
            SOUND.button_accept:play()
            Reset_gameplay()
            -- Delay the rest of the calculations by one frame so the UI texture can draw
            one_frame_delay = playdate.frameTimer.new(0)
            one_frame_delay.performAfterDelay(10, Enter_gameplay)

        end
        if playdate.buttonJustPressed( playdate.kButtonB ) then
            SOUND.menu_confirm:play()
            Reset_gameplay()
            -- Delay the rest of the calculations by one frame so the UI texture can draw
            one_frame_delay = playdate.frameTimer.new(0)
            one_frame_delay.performAfterDelay(10, Enter_menu_main)
        end

    elseif MENU_STATE.screen == MENU_SCREEN.main then
        if playdate.buttonJustPressed( playdate.kButtonA ) then
            SOUND.menu_confirm:play()
            enter_how_to_screen()
        elseif playdate.buttonJustPressed( playdate.kButtonB ) then
            SOUND.menu_confirm:play()
            enter_menu_credits()
        end

    elseif MENU_STATE.screen == MENU_SCREEN.credits then
        if playdate.buttonJustPressed( playdate.kButtonB ) then
            SOUND.menu_confirm:play()
            Enter_menu_main()
        end
    elseif MENU_STATE.screen == MENU_SCREEN.how_to then
        if playdate.buttonJustPressed( playdate.kButtonA ) then
            SOUND.button_accept:play()
            Enter_gameplay()
        end
    end
end


function onLoadingScreenFinished()
    UI_ANIMATIONS.loading:setVisible(false)
    Enter_menu_main()
end


function Init_menus()

    -- Imagetables for animations

    local imagetable_loading = gfxit.new("images/menus/start_anim/start_anim")
    local imagetable_logo = gfxit.new("images/menus/logo_anim/logo")

    UI_ANIMATIONS.loading = AnimatedSprite.new(imagetable_loading)
    UI_ANIMATIONS.loading:addState(
            "main",
            1,
            imagetable_loading:getLength(),
            {
                tickStep = 30.0/24.0,
                loop = false,
                onAnimationEndEvent = function (self) onLoadingScreenFinished() end
            }
        ).asDefault()
    UI_ANIMATIONS.loading:playAnimation()
    UI_ANIMATIONS.loading:moveTo(200,120)

    UI_ANIMATIONS.logo = AnimatedSprite.new(imagetable_logo)
    UI_ANIMATIONS.logo:addState(
            "main",
            1,
            imagetable_logo:getLength(),
            {
                tickStep = 30.0/4.0,
                loop = true,
            }
        ).asDefault()
    UI_ANIMATIONS.logo:playAnimation()
    UI_ANIMATIONS.logo:moveTo(112,83)

    UI_TEXTURES.startgame_credits_indicator = gfxi.new("images/menus/menu_text/startgame_credits_indicator")
    UI_TEXTURES.credits = gfxi.new("images/menus/menu_text/credits_overlay")
    UI_TEXTURES.game_over_indicator = gfxi.new("images/menus/menu_text/one_more_time_nah")
    UI_TEXTURES.failed_header = gfxi.new("images/menus/menu_text/FAILED")
    UI_TEXTURES.success_header = gfxi.new("images/menus/menu_text/SUCCESS")
    UI_TEXTURES.instructions = gfxi.new("images/menus/menu_text/instructions")
    UI_TEXTURES.resetting = gfxi.new("images/menus/menu_text/onesecondpls")

    
    MENU_STATE.screen = MENU_SCREEN.main

    -- Set the multiple things in their Z order of what overlaps what.

    Set_draw_pass(100, draw_ui) -- UI goes on top of everything.
    UI_ANIMATIONS.logo:setZIndex(110)
    Set_draw_pass(120, draw_loading_popup)
    UI_ANIMATIONS.loading:setZIndex(200)
end
