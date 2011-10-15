local args = ...

local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'
local gl = require 'gl'

local source = assert(args.source)
local color = source.renderer.color
local vel = quaternion.rotated_i(args.orientation) +
            vect(math.random()-0.5, 0, math.random()-0.5) * 0.1

local time_left = 60

transform = game.add_component(self, 'dokidoki.transform', {
  pos = args.pos + vel,
  orientation = args.orientation
})
collider = game.add_component(self, 'collider', {
  size = {1, 0.2, 0.2},
  group_mask = 0
})
sprite = game.add_component(self, 'dokidoki.sprite', {
  image = {
    draw = function ()
      gl.glBegin(gl.GL_LINE_LOOP)
      gl.glColor3d(unpack(color))
      gl.glVertex3d(0, 0, 0.05)
      gl.glVertex3d(0, 0, -0.05)

      gl.glColor3d(0.0, 0.0, 0.0)
      gl.glVertex3d(-1.5, 0, -0.02)
      gl.glVertex3d(-1.5, 0, 0.02)
      gl.glEnd()
      gl.glColor3d(1, 1, 1)
    end
  }
})

audio_source = game.add_component(self, 'audio_source', {
  sound = game.resources.sounds.flash_loops[math.random(4)],
  volume = 0.3,
})

collider.on_collision = function (other)
  if other.parent.type == 'block' then
    game.remove_component(self)
  elseif other.parent.type == 'ship' then
    if other.parent ~= source then
      game.effects.trigger_flare(self.transform.pos, other.parent.vel, color, source)
      game.remove_component(self)
      other.parent.jitter()
      if source.parent.type == 'player' or other.parent.parent.type == 'player' then
        audio_source.play()
      end
    end
  end
end

function update()
  time_left = time_left - 1
  if time_left <= 0 then
    game.remove_component(self)
  end
  transform.pos = transform.pos + vel
end
