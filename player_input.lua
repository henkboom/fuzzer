local glfw = require 'glfw'
local vect = require 'dokidoki.vect'

-- varies from 0 to 1
acceleration = 0
-- varies from -1 (right) to 1 (left)
steering = 0
shooting = false

local args = ...
local player = args.player

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
  return game.keyboard:key_held(keys[player.number].accelerate) and 1 or 0
end

local function get_steering(player)
  local k = keys[player.number]
  return (game.keyboard:key_held(k.left) and 1 or 0) -
         (game.keyboard:key_held(k.right) and 1 or 0)
end

local function get_shooting(player)
  local k = keys[player.number]
  local shooting = false
  for i = 1, #k.shoot do
    shooting = shooting or game.keyboard:key_held(k.shoot[i])
  end
  return shooting
end

function preupdate()
  --local joybuttons = glfw.GetJoystickButtons(num, 2)
  --local joyaxes = glfw.GetJoystickPos(num, 10)
  --table.foreach(joyaxes, print)

  local k = keys[player.number]

  acceleration = get_acceleration(player)
  steering = get_steering(player)
  shooting = get_shooting(player)
end
