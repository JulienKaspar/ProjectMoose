-- CoreLibs
import "CoreLibs/crank"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- Game scripts
import "sound"
import "gameplay"
import "visuals"
import "menu"
import "utils"
import "world"


local gfx <const> = playdate.graphics

local function initialize()
    -- Start all systems needed by the game to start ticking

    -- Make it different, every time!
    math.randomseed(playdate.getSecondsSinceEpoch())

    -- Init all the things!
    Init_gameplay()
    Init_visuals()
    Init_menus()
    Init_sounds()
    Init_world()
end

initialize()
Enter_menu_start()
-- Enter_gameplay()


function playdate.update()
    -- Always redraw and update entities (sprites) and timers.
    gfx.clear()
    gfx.sprite.update()
    playdate.timer.updateTimers()

    -- Called before every frame is drawn.
    if MENU_STATE.screen ~= MENU_SCREEN.gameplay then
        -- In Menu system.
        Handle_menu_input()
    end
    -- Intentionally check again (no else), the menu might have just started gameplay
    if MENU_STATE.screen == MENU_SCREEN.gameplay then
        -- In gameplay.
        local dt <const> = 1.0 / playdate.display.getRefreshRate()
        update(dt)
        draw()
    end
end
