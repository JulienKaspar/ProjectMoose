-- CoreLibs
import "CoreLibs/crank"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"

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
    Init_world()
    Init_gameplay()
    Init_visuals()
    Init_menus()
end

initialize()
Enter_loading_screen()
-- Enter_gameplay()


function playdate.update()
    local dt <const> = 1.0 / playdate.getFPS()

    -- Called before every frame is drawn.
    if MENU_STATE.screen ~= MENU_SCREEN.gameplay then
        -- In Menu system.
        Handle_menu_input()
    end
    -- Intentionally check again (no else), the menu might have just started gameplay
    if MENU_STATE.screen == MENU_SCREEN.gameplay then
        -- In gameplay.
        Handle_input()
        if dt > 0 then
        update(dt)
        end
    end
    if dt > 0 then
        update_physics(dt)
    end

    Check_if_heart_animations_finished()

    -- Always redraw and update entities (sprites) and timers.
    gfx.clear()
    for _, toy in ipairs(TOYS) do
      toy:updateSprites()
    end
    gfx.sprite.update()
    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()
end
