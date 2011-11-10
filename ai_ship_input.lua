local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'

acceleration = 0
steering = 0
shooting = true

function preupdate()
  local transform = parent.ship.transform

  local to_target = parent.ship.direction_to_checkpoint()
  local forward = quaternion.rotated_i(transform.orientation)

  acceleration = math.max(0, math.sqrt(vect.dot(forward, to_target)))
  steering = (vect.cross(forward, to_target)[2] > 0) and 1 or -1
  shooting = math.random(3) == 1
end
