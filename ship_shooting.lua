local audio_source = require 'audio_source'
local COOLDOWN = 6
--local cooldown_left = 180
local cooldown_left = 30

local args = ...

local player = args.player

transform = parent.transform
shot_sound = audio_source(self)
shot_sound.sound = game.resources.sounds.shoot[player.number]
shot_sound.volume = 0.06

function update ()
  if cooldown_left > 0 then
    cooldown_left = cooldown_left - 1
  elseif(parent.input.shooting) then
    game.add_component(self, 'pulse', {
      source = parent,
      pos = parent.transform.pos,
      orientation = parent.transform.orientation
    })
    shot_sound:play()
    cooldown_left = COOLDOWN
  end
end
