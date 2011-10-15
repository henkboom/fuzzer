local mixer = require 'mixer'

local args = ...
transform = false
if args and args.transform ~= nil then
  transform = args.transform
else
  transform = parent.transform
end
sound = args and args.sound
volume = args and args.volume or 1
loop = args and args.loop or false

local last_played

function play()
  assert(sound)
  last_played = sound:play(volume, volume, loop and 0 or 1)
  mixer.channel_fade_to(last_played, 0, volume)
end

function fade_to(volume)
  if last_played then
    mixer.channel_fade_to(last_played, 0.05, volume)
  end
end

function on_removal()
  if loop then
    if last_played then
      mixer.channel_stop(last_played)
    end
  end
end
