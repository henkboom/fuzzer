local vect = require 'dokidoki.vect'

local args = ...

player = args.player

ship = game.add_component(self, 'ship', {
  input = game.add_component(self, 'player_input', {player = player}),
  pos = args.pos,
  orientation = args.orientation,
  player = player
})
transform = ship.transform

-- number display
local origin = vect(55.5, 0, 44.5)
local offset = vect(5/4, 0, 0)
number_display = game.add_component(self, 'number_display')
number_display.transform.pos = origin + (player.number-1) * offset
number_display.color = player.color

function update()
  local laps_left = 4 - ship.lap
  number_display.value = laps_left
  if laps_left <= 0 then
    game.race_manager.race_over()
  end
end
