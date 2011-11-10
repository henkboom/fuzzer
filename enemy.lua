using 'dokidoki'
local vect = dokidoki.vect

local ai_ship_input = require 'ai_ship_input'

local enemy = class(dokidoki.component)
enemy._name = 'enemy'

function enemy:_init(parent, args)
  self:super(parent)
  self.ship = dokidoki.retro_component(self, 'ship', {
    input = ai_ship_input(self),
    pos = args.pos,
    orientation = args.orientation,
    player = args.player,
  })
  self.transform = self.ship.transform
end

return enemy
