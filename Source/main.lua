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
    -- Called before every frame is drawn.
    if MENU_STATE.screen ~= MENU_SCREEN.gameplay then
        -- In Menu system.
        Handle_menu_input()
    end

    -- Update world based on fps
    local fps = playdate.getFPS()
    if fps > 0 then
        -- Clamp so that the physics doesn't go crazy
        fps = Clamp(fps, 18, 50)
        local dt <const> = 1.0 / fps
        force_scale = 0.03333 * fps

        -- Intentionally check again (no else), the menu might have just started gameplay
        if MENU_STATE.screen == MENU_SCREEN.gameplay then
            -- In gameplay.
            update(dt)
        end
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
