import 'AnimatedSprite'

local gfx <const> = playdate.graphics
local gfxi <const> = playdate.graphics.image
local gfxit <const> = playdate.graphics.imagetable

MENU_STATE = {}
MENU_SCREEN = { gameplay = 0, gameover = 1, start = 2, main = 3, credits = 4, loading = 5, }
local UI_TEXTURES = {}
local UI_ANIMATIONS = {}


-- System Menu

local function add_system_menu_entries()

    local menu = playdate.getSystemMenu()
    menu:removeAllMenuItems() -- ensure there's no duplicated entries.

    -- Add custom entries to system menu.

    local menuItem, error = menu:addMenuItem("restart", function()
        Reset_gameplay()
    end)
    local menuItem, error = menu:addMenuItem("main menu", function()
        Enter_menu_start()
    end)
end

local function remove_system_menu_entries()
    playdate.getSystemMenu():removeAllMenuItems()
end


-- Menu State Transitions

function Enter_loading_screen()
    MENU_STATE.screen = MENU_SCREEN.loading
end


function Enter_menu_start()
    MENU_STATE.screen = MENU_SCREEN.start

    remove_system_menu_entries()
    Stop_gameplay()

    if not SOUND.bg_loop_menu:isPlaying() then
        SOUND.bg_loop_menu:play(0)
    end
end


local function enter_menu_main()
    MENU_STATE.screen = MENU_SCREEN.main
end


local function enter_menu_credits()
    MENU_STATE.screen = MENU_SCREEN.credits
end


function Enter_game_over_screen()
    MENU_STATE.screen = MENU_SCREEN.gameover
    Stop_gameplay()
end


function Enter_gameplay()
    MENU_STATE.screen = MENU_SCREEN.gameplay

    SOUND.bg_loop_menu:stop()
    add_system_menu_entries()
    Reset_gameplay()
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
    
    elseif MENU_STATE.screen == MENU_SCREEN.start then
        UI_ANIMATIONS.logo:setVisible(true)
        -- UI_TEXTURES.start:draw(0, 0)
    
    elseif MENU_STATE.screen == MENU_SCREEN.main then
        UI_ANIMATIONS.logo:setVisible(true)
        -- UI_TEXTURES.main:draw(0, 0)
        UI_TEXTURES.startgame_credits_indicator:draw(191, 9)
    
    elseif MENU_STATE.screen == MENU_SCREEN.credits then
        UI_TEXTURES.credits:draw(0, 0)
    
    elseif MENU_STATE.screen == MENU_SCREEN.gameover then
        UI_TEXTURES.game_over_indicator:draw(124, 52)
    end
end


function Handle_menu_input()
    if MENU_STATE.screen == MENU_SCREEN.gameover then
        if playdate.buttonJustPressed( playdate.kButtonA ) then
            SOUND.menu_confirm:play()
            Enter_gameplay()
        end
        if playdate.buttonJustPressed( playdate.kButtonB ) then
            SOUND.menu_confirm:play()
            Enter_menu_start()
        end

    elseif MENU_STATE.screen == MENU_SCREEN.start then
        -- Select an Option.
        if playdate.buttonJustReleased( playdate.kButtonA ) then
            SOUND.menu_confirm:play()
            enter_menu_main()
        end

    elseif MENU_STATE.screen == MENU_SCREEN.main then
        if playdate.buttonJustReleased( playdate.kButtonA ) then
            SOUND.menu_confirm:play()
            Enter_gameplay()
        elseif playdate.buttonJustReleased( playdate.kButtonB ) then
            SOUND.menu_confirm:play()
            enter_menu_credits()
        end

    elseif MENU_STATE.screen == MENU_SCREEN.credits then
        if playdate.buttonJustReleased( playdate.kButtonB ) then
            SOUND.menu_confirm:play()
            enter_menu_main()
        end
    end
end


function onLoadingScreenFinished()
    UI_ANIMATIONS.loading:setVisible(false)
    Enter_menu_start()
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
                tickStep = 2.0,
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

    UI_TEXTURES.game_over_indicator = gfxi.new("images/menus/menu_text/one_more_try_nah")
    UI_TEXTURES.start = gfxi.new("images/start_screen_temp.png")
    UI_TEXTURES.main = gfxi.new("images/environment/game_mockups.png")
    UI_TEXTURES.credits = gfxi.new("images/credits_temp.png")
    UI_TEXTURES.startgame_credits_indicator = gfxi.new("images/menus/menu_text/startgame_credits_indicator")

    
    MENU_STATE.screen = MENU_SCREEN.start

    -- Set the multiple things in their Z order of what overlaps what.

    Set_draw_pass(100, draw_ui) -- UI goes on top of everything.
    UI_ANIMATIONS.logo:setZIndex(110)
    UI_ANIMATIONS.loading:setZIndex(200)
end
