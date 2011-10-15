local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'

math.randomseed(os.time())

keyboard = game.add_component(self, 'dokidoki.keyboard')
exit_handler = game.add_component(self, 'dokidoki.exit_handler', {
  exit_on_esc = true
})

resources = game.add_component(self, 'resources')

collision = game.add_component(self, 'collision')

camera = game.add_component(self, 'camera')

effects = game.add_component(self, 'effects')

race_manager = game.add_component(self, 'race_manager')

music = game.add_component(self, 'audio_source', {
  sound = resources.sounds.music,
  volume = 1,
  loop = true
})
music.play()

function reset()
  game.remove_component(race_manager)
end

function preupdate()
  if not race_manager or race_manager.dead then
    race_manager = game.add_component(self, 'race_manager')
  end

  if glfw.GetJoystickButtons(0, 7)[7] == 1 or
     glfw.GetJoystickButtons(1, 7)[7] == 1 then
    reset()
  end
end

