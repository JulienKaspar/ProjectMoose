local sp <const> = playdate.sound.sampleplayer

SOUND = {
  cat_meow = sp.new("sound/sound_sample"),
  bg_loop_menu = sp.new("sound/menu_bg_loop"),
  bg_loop_gameplay = sp.new("sound/gameplay_bg_loop"),
  menu_confirm = sp.new("sound/menu_item_confirm"),
  menu_highlight = sp.new("sound/menu_item_highlight"),
  button_accept = sp.new("sound/bg_accept"),
  klaw_ascend_loop = sp.new("sound/klaw_ascend_loop"),
  klaw_descend_loop = sp.new("sound/klaw_descend_loop"),
  klaw_snap = sp.new("sound/klaw_snap"),
  machine_kick_1 = sp.new("sound/machine_kick_1"),
  machine_kick_2 = sp.new("sound/machine_kick_2"),
  machine_kick_3 = sp.new("sound/machine_kick_3"),
  toy_grunt_1 = sp.new("sound/toy_grunt_1"),
  toy_grunt_2 = sp.new("sound/toy_grunt_2"),
  toy_grunt_3 = sp.new("sound/toy_grunt_3"),
  toy_grunt_4 = sp.new("sound/toy_grunt_4"),
  toy_grabbed = sp.new("sound/toy_grabbed"),

}

function Init_sounds()

  -- Create any sounds needed for the game
  
end