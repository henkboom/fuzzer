local vect = require 'dokidoki.vect'

local args = ...

ship = game.add_component(self, 'ship', {
  input = game.add_component(self, 'ai_ship_input'),
  pos = args.pos,
  orientation = args.orientation
})
transform = ship.transform
