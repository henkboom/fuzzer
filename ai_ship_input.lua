using 'dokidoki'
local vect = dokidoki.vect
local quaternion = dokidoki.quaternion

local ai_ship_input = class(dokidoki.component)
ai_ship_input._name = 'ai_ship_input'

function ai_ship_input:_init(parent)
  self:super(parent)

  self.acceleration = 0
  self.steering = 0
  self.shooting = true

  self:add_handler_for('preupdate')
end

function ai_ship_input:preupdate()
  local transform = self.parent.ship.transform

  local to_target = self.parent.ship.direction_to_checkpoint()
  local forward = quaternion.rotated_i(transform.orientation)

  self.acceleration = math.max(0, math.sqrt(vect.dot(forward, to_target)))
  self.steering = (vect.cross(forward, to_target)[2] > 0) and 1 or -1
  self.shooting = math.random(3) == 1
end

return ai_ship_input
