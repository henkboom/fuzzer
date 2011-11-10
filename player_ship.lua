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
number_display = game.add_component(self, 'number_display')
number_display.transform.pos = args.pos
number_display.color = player.color

function update()
  local laps_left = 6 - ship.lap
  number_display.value = laps_left
  if laps_left <= 0 then
    game.race_manager.race_over()
  end
end
