local vect = require 'dokidoki.vect'

local args = ...
local player = args.player

ship = game.add_component(self, 'ship', {
  input = game.add_component(self, 'ai_ship_input'),
  pos = args.pos,
  orientation = args.orientation,
  player = player,
})
transform = ship.transform
