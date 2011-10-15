local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'

local args = ...
input = assert(args.input)

-- constants

local ACCELERATION = 0.0025
local MAX_VEL = 0.5
local BRAKE_DAMPING = 0.04
local TURN_SPEED = 0.05
local SIZE = {0.5, 10, 0.20}

-- subcomponents

transform = game.add_component(self, 'dokidoki.transform', {
  pos = args.pos,
  orientation = args.orientation,
})
renderer = game.add_component(self, 'ship_renderer', {
  size=SIZE,
  color = args.color
})
collider = game.add_component(self, 'collider', { size=SIZE })
ship_shooting = game.add_component(self, 'ship_shooting')

bump_audio_source = game.add_component(self, 'audio_source', {
  volume = 0.2
})
lap_audio_source = game.add_component(self, 'audio_source', {
  volume = 1,
  sound = game.resources.sounds.finish_lap
})
if parent.type == 'player' then
  engine_audio_source = game.add_component(self, 'audio_source', {
    volume = 0,
    loop = true,
    sound = game.resources.sounds.engine_loops[parent.num+1]
  })

  engine_audio_source.play()
end

-- behaviour

vel = vect.zero
local impulse = vect.zero
local next_checkpoint = 1
lap = 0

collider.on_collision = function (other, point, normal, depth)

  if(other.parent.type == 'checkpoint') then
    reach_checkpoint(other.parent)
  else -- assume we collide with everything else
    normal = vect(normal[1], 0, normal[3])
    if(vect.sqrmag(normal) > 0) then
      normal = vect.norm(normal)
      transform.pos = transform.pos + normal * depth/3
      local other_vel = other.parent.type == 'ship' and other.parent.vel or vect.zero
      local rel_vel = vel - other_vel
      if vect.dot(rel_vel, normal) < 0 then
        if -vect.dot(rel_vel, normal) > 0.1 then
          bump_audio_source.sound = game.resources.sounds.hit_wall[math.random(3)]
          bump_audio_source.play()
        end
        rel_vel = rel_vel - 0.6 * vect.project(rel_vel, normal)
        impulse = impulse + rel_vel + other_vel - vel
      end
    end
  end
end

local function apply_acceleration()
  local i = quaternion.rotated_i(transform.orientation)
  vel = vel + i * ACCELERATION * input.acceleration
  vel = vel + impulse
  impulse = vect.zero
end

local function damp_velocity()
  -- damp sideways and backwards velocity
  local i = quaternion.rotated_i(transform.orientation)

  -- backwards, damp everything, otherwise damp sideways only
  if vect.dot(vel, i) < 0 then
    vel = vel - vel * BRAKE_DAMPING
  else
    local k = quaternion.rotated_k(transform.orientation)
    local sideways = vect.project(vel, k)
    vel = vel - sideways * BRAKE_DAMPING
  end

  if vect.sqrmag(vel) > MAX_VEL * MAX_VEL then
    vel = vel * MAX_VEL / vect.mag(vel)
  end
end

local function apply_steering()
  self.transform.orientation = self.transform.orientation *
    quaternion.from_rotation(vect.j, input.steering * TURN_SPEED)
end

local function apply_velocity()
  self.transform.pos = self.transform.pos + vel
end

function update()
  local steering = input and input.steering or 0 

  apply_acceleration()
  damp_velocity()
  apply_velocity()
  apply_steering()

  if parent.type == 'player' then
    engine_audio_source.fade_to(vect.mag(vel)*1.8 + 0.2)
  end
end

function jitter()
  transform.orientation = transform.orientation *
    quaternion.from_rotation(vect.j, (math.random() - 0.5) * math.pi/3*1.5)
end

-- checkpoint handling

function reach_checkpoint(checkpoint)
  local race_checkpoints = game.race_manager.checkpoints
  if checkpoint == race_checkpoints[next_checkpoint] then
    --print('checkpoint ' .. next_checkpoint .. ' reached')
    next_checkpoint = next_checkpoint + 1
    if(next_checkpoint > #race_checkpoints) then
      next_checkpoint = 1
      --print('finished lap ' .. lap)
      if parent.type == 'player' then
        lap_audio_source.play()
      end
      lap = lap + 1
    end
  end
end

function direction_to_checkpoint()
  local checkpoint = game.race_manager.checkpoints[next_checkpoint]
  return vect.norm(checkpoint.transform.pos - transform.pos)
end

-- debug
--local gl = require 'gl'
--function draw()
--  gl.glBegin(gl.GL_LINES)
--  gl.glVertex3d(vect.coords(transform.pos))
--  gl.glVertex3d(vect.coords(transform.pos + direction_to_checkpoint() * 2))
--  gl.glEnd()
--end
