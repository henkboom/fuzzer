local vect = require 'dokidoki.vect'

local args = ...

num = args.input_num
ship = game.add_component(self, 'ship', {
  input = game.add_component(self, 'player_input', {num = args.input_num}),
  pos = args.pos,
  orientation = args.orientation,
  color = args.color
})
transform = ship.transform

number_display = game.add_component(self, 'number_display', {pnum=args.input_num})

function update()
  local laps_left = 4 - ship.lap
  number_display.value = laps_left
  if laps_left <= 0 then
    game.race_manager.race_over()
  end
end

