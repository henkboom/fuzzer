local glfw = require 'glfw'
local vect = require 'dokidoki.vect'

-- TODO only poll joystick info once per frame, since it's not buffered

-- varies from 0 to 1
acceleration = 0
-- varies from -1 (right) to 1 (left)
steering = 0
shooting = false

local args = ...
local player = args.player

local joybuttons
local joyaxes

local function remove_deadzone(x)
  if x == 0 then
    return x
  end
  local absx = math.abs(x)
  local sign = absx/x
  return sign * (math.max(0, absx - 0.1) * 1/0.9)
end

keys = {
  {
    left = glfw.KEY_LEFT,
    right = glfw.KEY_RIGHT,
    accelerate = string.byte('Z'),
    shoot = {string.byte('X'), string.byte('C'), string.byte('V')}
  },
  {
    left = string.byte('D'),
    right = string.byte('G'),
    accelerate = string.byte('A'),
    shoot = {string.byte('S'), string.byte('Q'), string.byte('W')}
  },
  {
    left = string.byte('K'),
    right = string.byte(';'),
    accelerate = string.byte('H'),
    shoot = {string.byte('J'), string.byte('Y'), string.byte('U')}
  },
  {
    left = glfw.KEY_DEL,
    right = glfw.KEY_PAGEDOWN,
    accelerate = string.byte('B'),
    shoot = {string.byte('N'), string.byte('M'), string.byte(',')}
  }
}

local function get_acceleration(player)
  local k = keys[player.number]
  local accel = game.keyboard:key_held(k.accelerate) and 1 or 0
  accel = accel + (joybuttons and joybuttons[1] and 1 or 0)
  return math.max(0, math.min(1, accel))
end

local function get_steering(player)
  local k = keys[player.number]
  local steering =
    (game.keyboard:key_held(k.left) and 1 or 0) -
    (game.keyboard:key_held(k.right) and 1 or 0) -
    (joyaxes and joyaxes[1] or 0)
  return math.max(-1, math.min(1, steering))
end

local function get_shooting(player)
  local k = keys[player.number]
  local shooting = false
  for i = 1, #k.shoot do
    shooting = shooting or game.keyboard:key_held(k.shoot[i])
  end
  for i = 2, 4 do
    shooting = shooting or (joybuttons and joybuttons[i])
  end
  return shooting
end

function preupdate()
  joyaxes = glfw.GetJoystickPos(player.number, 6)
  joybuttons = glfw.GetJoystickButtons(player.number, 14)
  --if joyaxes then print(player.number, unpack(joyaxes)) end
  --if joybuttons then print(player.number, unpack(joybuttons)) end

  acceleration = get_acceleration(player)
  steering = get_steering(player)
  shooting = get_shooting(player)
end
