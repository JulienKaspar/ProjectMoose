local sp <const> = playdate.sound.sampleplayer
local current_toy_sound = nil
local current_kick_sound = nil

SOUND = {
  cat_meow = sp.new("sound/sound_sample"),
  bg_loop_menu = sp.new("sound/menu_bg_loop"),
  bg_loop_gameplay = sp.new("sound/gameplay_bg_loop"),
  menu_confirm = sp.new("sound/menu_item_confirm"),
  menu_highlight = sp.new("sound/menu_item_highlight"),
  button_accept = sp.new("sound/button_accept"),
  klaw_ascend_loop = sp.new("sound/klaw_ascend_loop"),
  klaw_descend_loop = sp.new("sound/klaw_descend_loop"),
  klaw_snap = sp.new("sound/klaw_snap"),
  toy_grabbed = sp.new("sound/toy_grabbed"),
  child_disappointed = sp.new("sound/child_disappointed"),
  child_sigh = sp.new("sound/child_sigh"),
  child_laugh = sp.new("sound/child_laugh"),
  game_over = sp.new("sound/game_over"),
  toy_ascend = sp.new("sound/toy_ascend"),
  TOYS = {
    sp.new("sound/toy_sound_1"),
    sp.new("sound/toy_sound_2"),
    sp.new("sound/toy_sound_3"),
    sp.new("sound/toy_sound_4"),
  },
  KICKS = {
    machine_kick_1 = sp.new("sound/machine_kick_1"),
    machine_kick_2 = sp.new("sound/machine_kick_2"),
    machine_kick_3 = sp.new("sound/machine_kick_3"),
  },
}

function Init_sounds()
  -- initialize sounds
end

function Play_random_toy_sound()
  if current_toy_sound == nil then
    current_toy_sound = SOUND["TOYS"][math.random(1, #SOUND["TOYS"])]
    current_toy_sound:play()
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