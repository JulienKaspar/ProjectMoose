-- Global variables

GYRO_X, GYRO_Y = 200, 120

-- Gameplay state variables that should be reset

GAMEPLAY_STATE = {
    example = false
}


-- Local methods

-- NOTE: Copied from the project loose project
local function check_gyro_and_gravity()
    -- Get values from gyro.
    local raw_gravity_x, raw_gravity_y, raw_gravity_z = playdate.readAccelerometer()
    -- Occasionally when simulator starts to upload the game to the actual
    -- device the gyro returns nil as results.
    -- Note: check all values and not just x for nil so that the IDE linter is sure it's numbers.
    if raw_gravity_x == nil or raw_gravity_y == nil or raw_gravity_z == nil then
        return
    end

    -- Calculate G's (length of acceleration vector)
    SHAKE_VAL = raw_gravity_x * raw_gravity_x + raw_gravity_y * raw_gravity_y + raw_gravity_z * raw_gravity_z

    -- Update the average "normal" gyroscope position. This depends on the tilt that players are
    -- comfortable holding the playdate and might change over time. aka Normalize Gravity.
    if IS_GYRO_INITIALIZED == false then
        -- For the initial value, use the gyro at the start of the game, so that
        -- it calibrates as quickly as possible to the current device orientation.
        AVG_GRAVITY_X = raw_gravity_x
        AVG_GRAVITY_Y = raw_gravity_y
        AVG_GRAVITY_Z = raw_gravity_z
        IS_GYRO_INITIALIZED = true
    else
        -- Exponential moving average:
        --   https://en.wikipedia.org/wiki/Exponential_smoothing
        --
        -- The weight from the number of samples can be estimated as `2 / (n + 1)`.
        -- See the Relationship between SMA and EMA section of the
        --   https://en.wikipedia.org/wiki/Moving_average
        local num_smooth_samples <const> = 120
        local alpha <const> = 2 / (num_smooth_samples + 1)

        AVG_GRAVITY_X = alpha * raw_gravity_x + (1 - alpha) * AVG_GRAVITY_X
        AVG_GRAVITY_Y = alpha * raw_gravity_y + (1 - alpha) * AVG_GRAVITY_Y
        AVG_GRAVITY_Z = alpha * raw_gravity_z + (1 - alpha) * AVG_GRAVITY_Z

        local len <const> = math.sqrt(AVG_GRAVITY_X*AVG_GRAVITY_X + AVG_GRAVITY_Y*AVG_GRAVITY_Y + AVG_GRAVITY_Z*AVG_GRAVITY_Z)
        AVG_GRAVITY_X /= len
        AVG_GRAVITY_Y /= len
        AVG_GRAVITY_Z /= len
    end

    -- NOTE: Commented out because it's probably not used?
    -- Only update the gyro onscreen position when it's fairly stable (player isn't actively shaking the console).
    -- if SHAKE_VAL < 1.1 then
    --     local v1 <const> = vec2d.new(0, 1)
    --     local v2 <const> = vec2d.new(AVG_GRAVITY_Y, AVG_GRAVITY_Z)
    --     local angle <const> = v2:angleBetween(v1) / 180 * math.pi

    --     local co <const> = math.cos(angle)
    --     local si <const> = math.sin(angle)

    --     local gravity_x <const> = raw_gravity_x
    --     local gravity_y <const> = raw_gravity_y*co - raw_gravity_z*si
    --     --    gravity_z <const> = raw_gravity_y*si + raw_gravity_z*co

    --     local axis_sign <const> = Sign(raw_gravity_z)
    --     local gyroSpeed <const> = 60

    --     GYRO_X = Clamp(GYRO_X + gravity_x * gyroSpeed * axis_sign, 0, 400)
    --     GYRO_Y = Clamp(GYRO_Y + gravity_y * gyroSpeed, 0, 240)
    --     GAMEPLAY_STATE.cursor_pos.x = GYRO_X
    --     GAMEPLAY_STATE.cursor_pos.y = GYRO_Y
    -- end
end



-- Resource Management


function Init_gameplay()
    -- Done only once on start of the game, to load and setup const resources.

    playdate.startAccelerometer()
end


function Stop_gameplay()
    -- Done on every game over/win to stop ongoing sounds and events.
    -- Not a complete tear down of resources.
end


function Reset_gameplay()
    -- Done on every (re)start of the play.

    GAMEPLAY_STATE.example = false
end



-- Update Loop

function Handle_input()
    local gravityX, gravityY, _gravityZ = playdate.readAccelerometer()
    GYRO_X = Clamp(GYRO_X + gravityX * 10, 0, 400)
    GYRO_Y = Clamp(GYRO_Y + gravityY * 10, 0, 240)

    check_gyro_and_gravity()
    if playdate.buttonIsPressed( playdate.kButtonA ) then
        if not SOUND.cat_meow:isPlaying() then
            SOUND.cat_meow:play()
        end
    end
end
