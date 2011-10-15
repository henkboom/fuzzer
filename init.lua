require 'dokidoki.module' [[]]

local dokidoki_kernel = require 'dokidoki.kernel'
local dokidoki_game = require 'dokidoki.game'

dokidoki_kernel.set_video_mode(640, 480)
dokidoki_kernel.set_fullscreen(true)
dokidoki_kernel.set_max_frameskip(2)

dokidoki_kernel.start_main_loop(dokidoki_game.make_game(
  {'preupdate', 'update', 'postupdate'},
  {'predraw', 'draw', '_debugdraw', 'postdraw'}, 
  'game'))


