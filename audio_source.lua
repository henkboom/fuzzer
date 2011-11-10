local mixer = require 'mixer'
using 'dokidoki'

local audio_source = class(dokidoki.component)
audio_source._name = 'audio_source'

function audio_source:_init(parent)
  self:super(parent)
  self.sound = false
  self.volume = 1
  self.loop = false
  self._last_played = false
  self.removed:add_handler(function () self:on_removal() end)
end

function audio_source:play()
  assert(self.sound)
  self._last_played = self.sound:play(
    self.volume, self.volume, self.loop and 0 or 1)
end

function audio_source:fade_to(volume)
  if self._last_played then
    mixer.channel_fade_to(self._last_played, 0.05, volume)
  end
end

function audio_source:on_removal()
  if self.loop and self._last_played then
    mixer.channel_stop(self._last_played)
  end
end

return audio_source
