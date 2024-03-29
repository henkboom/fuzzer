--require 'profiler'
--profiler.start()
using = require('dokidoki.base').using
using 'dokidoki'
using 'pl'
class = pl.class

dokidoki.kernel.set_video_mode(640, 480)
--dokidoki.kernel.set_fullscreen(true)
dokidoki.kernel.set_max_frameskip(2)

local game = dokidoki.game(
  {'preupdate', 'update', 'postupdate'},
  {'predraw', 'opaque_draw', 'draw', '_debugdraw', 'postdraw'})

--

local audio_source = require 'audio_source'
local resources = require 'resources'
local title_screen = require 'title_screen'

local function init()
  game.keyboard = dokidoki.keyboard(game)
  
  game.exit_handler = dokidoki.exit_handler(game)
  game.exit_handler.exit_on_esc = true
  
  game.resources = resources(game)
  
  game.collision = dokidoki.retro_component(game, 'physics.collision')
  
  game.camera = dokidoki.retro_component(game, 'camera')
  
  game.effects = dokidoki.retro_component(game, 'effects')

  game.music = audio_source(game)
  game.music.sound = game.resources.sounds.music
  game.music.volume = 1
  game.music.loop = true
  game.music:play()
  
  function game.reset()
    game.race_manager:remove()
    game.title_screen = title_screen(game)
  end

  game.title_screen = title_screen(game)
  
  --game:add_handler_for('preupdate', function ()
  --  if not game.race_manager or game.race_manager.dead then
  --    game.race_manager = dokidoki.retro_component(game, 'race_manager', {
  --      player(1, false),
  --      player(2, false),
  --      player(3, false),
  --      player(4, false),
  --    })
  --  end
  --
  --  if glfw.GetJoystickButtons(0, 7)[7] == 1 or
  --     glfw.GetJoystickButtons(1, 7)[7] == 1 then
  --    game.reset()
  --  end
  --end)
end

--

game:start_main_loop(init)

