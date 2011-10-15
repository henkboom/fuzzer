local COOLDOWN = 6
local cooldown_left = 180

local args = ...

transform = parent.transform
audio_source = game.add_component(self, 'audio_source')
if parent.parent.type == 'player' then
  audio_source.sound = game.resources.sounds.shoot[parent.parent.num+1]
  audio_source.volume = 0.06
else
  audio_source.sound = game.resources.sounds.shoot[math.random(2)]
  audio_source.volume = 0.02
end

function update ()
  if cooldown_left > 0 then
    cooldown_left = cooldown_left - 1
  elseif(parent.input.shooting) then
    game.add_component(self, 'pulse', {
      source = parent,
      pos = parent.transform.pos,
      orientation = parent.transform.orientation
    })
    audio_source.play()
    cooldown_left = COOLDOWN
  end
end
