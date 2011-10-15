local glfw = require 'glfw'
local vect = require 'dokidoki.vect'

-- varies from 0 to 1
acceleration = 0
-- varies from -1 (right) to 1 (left)
steering = 0
shooting = false

local args = ...
local num = args.num

local function remove_deadzone(x)
  if x == 0 then
    return x
  end
  local absx = math.abs(x)
  local sign = absx/x
  return sign * (math.max(0, absx - 0.1) * 1/0.9)
end

function preupdate()
  local joybuttons = glfw.GetJoystickButtons(num, 2)
  local joyaxes = glfw.GetJoystickPos(num, 10)
  --table.foreach(joyaxes, print)

  acceleration = (num == 1 and game.keyboard.key_held(glfw.KEY_UP) and 1 or 0) +
                 (joybuttons[1] and joybuttons[1] or 0)
  steering = (num == 1 and game.keyboard.key_held(glfw.KEY_LEFT) and 1 or 0) -
             (num == 1 and game.keyboard.key_held(glfw.KEY_RIGHT) and 1 or 0) -
             (joyaxes and joyaxes[1] and remove_deadzone(joyaxes[1]) or 0)
  shooting = num == 1 and game.keyboard.key_held(string.byte('Z')) or
             (joybuttons[2] == 1)
end
