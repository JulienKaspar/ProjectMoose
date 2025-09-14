local gfx <const> = playdate.graphics
local gfxi <const> = playdate.graphics.image

MENU_STATE = {}
MENU_SCREEN = { gameplay = 0, gameover = 1, start = 2, main = 3, credits = 4 }
local UI_TEXTURES = {}


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

function Enter_menu_start()
    MENU_STATE.screen = MENU_SCREEN.start

    remove_system_menu_entries()
    Stop_gameplay()

    MENU_STATE.active_screen_texture = UI_TEXTURES.start
    if not SOUND.bg_loop_menu:isPlaying() then
        SOUND.bg_loop_menu:play(0)
    end
end

local function enter_menu_main()
    MENU_STATE.screen = MENU_SCREEN.main
    MENU_STATE.active_screen_texture = UI_TEXTURES.main
end

local function enter_menu_credits()
    MENU_STATE.screen = MENU_SCREEN.credits
    MENU_STATE.active_screen_texture = UI_TEXTURES.credits
end

local function enter_menu_gameover()
    MENU_STATE.screen = MENU_SCREEN.gameover
    MENU_STATE.active_screen_texture = UI_TEXTURES.gameover

    Stop_gameplay()
    -- Play gameover effects & transitions.
end

function Enter_gameplay()
    MENU_STATE.screen = MENU_SCREEN.gameplay

    SOUND.bg_loop_menu:stop()
    add_system_menu_entries()
    Reset_gameplay()
end



-- Draw & Update

local function draw_ui()
    if MENU_STATE.screen == MENU_SCREEN.gameplay then
        return
    end

    -- In menus. The gameplay is inactive.

    -- Draw baground screen image.
    MENU_STATE.active_screen_texture:draw(0, 0)

    -- Start menu draws a selected option indicator.
    if MENU_STATE.screen == MENU_SCREEN.start then
        gfx.pushContext()
            gfx.setColor(gfx.kColorBlack)
            gfx.fillCircleAtPoint(73, 110 + 27*MENU_STATE.focused_option, 7)
        gfx.popContext()

    -- Draw gameover screen dynamic elements.
    elseif MENU_STATE.screen == MENU_SCREEN.gameover then
    end
end


function Handle_menu_input()
    if MENU_STATE.screen == MENU_SCREEN.gameover then
        if playdate.buttonIsPressed( playdate.kButtonA ) then
            SOUND.menu_confirm:play()
            Enter_gameplay()
        end
        if playdate.buttonJustReleased( playdate.kButtonB ) then
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


function Init_menus()

    UI_TEXTURES.gameover = gfxi.new("images/gameover_temp.png")
    UI_TEXTURES.start = gfxi.new("images/start_screen_temp.png")
    UI_TEXTURES.main = gfxi.new("images/environment/game_mockups.png")
    UI_TEXTURES.credits = gfxi.new("images/credits_temp.png")
    
    MENU_STATE.screen = MENU_SCREEN.start
    MENU_STATE.active_screen_texture = UI_TEXTURES.start
    MENU_STATE.focused_option = 0

    -- Set the multiple things in their Z order of what overlaps what.
    Set_draw_pass(100, draw_ui) -- UI goes on top of everything.
end
