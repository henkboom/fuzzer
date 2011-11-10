local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'
local audio_source = require 'audio_source'
local ship_renderer = require 'ship_renderer'
local track = require 'track'
using 'physics'

local args = ...
input = assert(args.input)
player = assert(args.player)

-- constants

local ACCELERATION = 0.0025
local MAX_VEL = 2
local BRAKE_DAMPING = 0.04
local TURN_SPEED = 0.05
local SIZE = {0.5, 0.1, 0.20}

-- subcomponents

transform = dokidoki.transform(self)
transform.pos = args.pos + vect(0, SIZE[2] + 0.01, 0)
transform.orientation = args.orientation

renderer = ship_renderer(self, transform)
renderer.size = SIZE
renderer.color = player.color

local shape = physics.box_shape(SIZE)
collider = game.add_component(self, 'physics.collider', {
  collision_shape = shape
})
ship_shooting = game.add_component(self, 'ship_shooting', {player = player})

bump_audio_source = audio_source(self)
bump_audio_source.volume = 0.2

lap_audio_source = false
if player.is_human then
  lap_audio_source = audio_source(self)
  lap_audio_source.volume = 1
  lap_audio_source.sound = game.resources.sounds.finish_lap
end

engine_audio_source = audio_source(self)
engine_audio_source.volume = 0
engine_audio_source.loop = true
engine_audio_source.sound = game.resources.sounds.engine_loops[player.number]
engine_audio_source:play()

drift_audio_source = audio_source(self)
drift_audio_source.volume = 0
drift_audio_source.loop = true
drift_audio_source.sound = game.resources.sounds.slidenoise
drift_audio_source:play()

-- behaviour

vel = vect.zero
active = true
local impulse = vect.zero
local next_checkpoint = 1
lap = 0

local function on_collision(other, point, normal, depth)
  if(other.parent.type == 'checkpoint') then
    reach_checkpoint(other.parent)
  else -- assume we collide with everything else
    -- only affected by 2d collisions
    normal = vect(normal[1], 0, normal[3])
    if(vect.sqrmag(normal) > 0) then
      normal = vect.norm(normal)
      transform.pos = transform.pos + normal * depth
      local other_vel = other.parent.type == 'ship' and other.parent.vel or vect.zero
      local rel_vel = vel - other_vel
      if vect.dot(rel_vel, normal) < 0 then
        if -vect.dot(rel_vel, normal) > 0.1 then
          bump_audio_source.sound = game.resources.sounds.hit_wall[math.random(3)]
          bump_audio_source:play()
        end
        local rebound = 0.6
        if track:class_of(other.parent) then
          rebound = 1.2
        end
        rel_vel = rel_vel - rebound * vect.project(rel_vel, normal)
        impulse = impulse + rel_vel + other_vel - vel
      end
    end
  end
end
collider.on_collision = on_collision

local function apply_acceleration()
  local i = quaternion.rotated_i(transform.orientation)
  vel = vel + i * ACCELERATION * (input.shooting and 0 or input.acceleration)
  vel = vel + impulse
  impulse = vect.zero
end

local function damp_velocity()
  -- damp sideways and backwards velocity
  local i = quaternion.rotated_i(transform.orientation)

  -- backwards, damp everything, otherwise damp sideways only
  local damping
  if vect.dot(vel, i) < 0 then
    damping = vel * BRAKE_DAMPING
  else
    local k = quaternion.rotated_k(transform.orientation)
    local sideways = vect.project(vel, k)
    damping = sideways * BRAKE_DAMPING
  end

  local driftiness = 4000 * vect.sqrmag(damping)
  if drift_audio_source then
    drift_audio_source:fade_to(driftiness)
  end
  vel = vel - damping

  if vect.sqrmag(vel) > MAX_VEL * MAX_VEL then
    vel = vel * MAX_VEL / vect.mag(vel)
  end
end

local function apply_steering_and_velocity()
  local new_transform = dokidoki.transform()
  new_transform.pos = transform.pos + vel
  new_transform.orientation = transform.orientation *
    quaternion.from_rotation(vect.j, input.steering * TURN_SPEED)

  local closest_hit = nil
  local fraction = 1

  -- mask bit 2 is static geometry
  game.collision.convex_sweep_test(shape, transform, new_transform, 2,
    function (hit)
      if closest_hit == nil or hit.fraction < fraction then
        closest_hit = hit
        fraction = hit.fraction
      end
    end)

  transform.pos = transform.pos * (1-fraction) + new_transform.pos * fraction
  transform.orientation = new_transform.orientation

  if closest_hit ~= nil then
    --on_collision(closest_hit.collider, closest_hit.point, closest_hit.normal, 0)
  end
end

function update()
  if active then
    local steering = input and input.steering or 0 

    apply_acceleration()
    damp_velocity()
    apply_steering_and_velocity()
  end

  if engine_audio_source then
    engine_audio_source:fade_to((vect.mag(vel)*1.8 + 0.2) * input.acceleration)
  end
end

function jitter()
  transform.orientation = transform.orientation *
    quaternion.from_rotation(vect.j, (math.random() - 0.5) * math.pi/2)
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
      if lap_audio_source then
        lap_audio_source:play()
      end
      lap = lap + 1
    end
  end
end

function direction_to_checkpoint()
  local checkpoint = game.race_manager.checkpoints[next_checkpoint]
  return vect.norm(checkpoint.center - transform.pos)
end

-- debug
--local gl = require 'gl'
--function draw()
--  gl.glBegin(gl.GL_LINES)
--  gl.glVertex3d(vect.coords(transform.pos))
--  gl.glVertex3d(vect.coords(transform.pos + direction_to_checkpoint() * 2))
--  gl.glEnd()
--end
