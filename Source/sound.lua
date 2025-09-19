local sp <const> = playdate.sound.sampleplayer
local current_toy_sound = nil
local current_kick_sound = nil
local skip_toy_sound_chance = 0.5

SOUND = {
  loading_screen = sp.new("sound/loading_screen"),
  bg_loop_menu = sp.new("sound/menu_bg_loop"),
  bg_loop_gameplay = sp.new("sound/gameplay_bg_loop"),
  menu_confirm = sp.new("sound/menu_item_confirm"),
  menu_highlight = sp.new("sound/menu_item_highlight"),
  button_accept = sp.new("sound/button_accept"),
  klaw_ascend_loop = sp.new("sound/klaw_ascend_loop"),
  klaw_descend_loop = sp.new("sound/klaw_descend_loop"),
  kiddo_mad = sp.new("sound/kiddo_mad"),
  kiddo_disappointed = sp.new("sound/kiddo_disappointed"),
  kiddo_bang_glass = sp.new("sound/kiddo_bang_glass"),
  kiddo_wow = sp.new("sound/kiddo_wow"),
  heart_break = sp.new("sound/heart_break"),
  heart_up = sp.new("sound/heart_up"),
  game_over = sp.new("sound/game_over"),
  toy_ascend = sp.new("sound/toy_ascend"),
  TOYS = {
    sp.new("sound/toy_sounds_1"),
    sp.new("sound/toy_sounds_2"),
    sp.new("sound/toy_sounds_3"),
    sp.new("sound/toy_sounds_4"),
  },
  KICKS = {
    machine_kick_1 = sp.new("sound/machine_kick_1"),
    machine_kick_2 = sp.new("sound/machine_kick_2"),
    machine_kick_3 = sp.new("sound/machine_kick_3"),
  },
}

function Play_random_toy_sound()
  if current_toy_sound == nil then
    current_toy_sound = SOUND["TOYS"][math.random(1, #SOUND["TOYS"])]
    current_toy_sound:play()
    skip_toy_sound = true
  elseif (math.random() > skip_toy_sound_chance) then 
    -- add random skips to lower frequency
    return
  elseif not current_toy_sound:isPlaying() then
    current_toy_sound = nil
  end
end

function Play_machine_kick_sound()
  if current_kick_sound == nil then
    current_kick_sound = SOUND["KICKS"][math.random(1, #SOUND["KICKS"])]
    current_kick_sound:play()
  elseif not current_kick_sound:isPlaying() then
    current_kick_sound = nil
  end
end

function Play_klaw_descend_loop()
  -- Toggle klaw sfx
  if not SOUND.bg_loop_gameplay:isPlaying() then
      SOUND.klaw_ascend_loop:stop()
      SOUND.bg_loop_gameplay:play(0)
  end
end

function Play_klaw_ascend_loop()
  -- Toggle klaw sfx
  if not SOUND.klaw_ascend_loop:isPlaying() then
      SOUND.bg_loop_gameplay:stop()
      SOUND.klaw_ascend_loop:play()
  end
end