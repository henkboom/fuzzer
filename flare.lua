local gl = require 'gl'
local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'

local args = ...
local opacity = args.opacity
local size = args.size
local vel = args.vel
local color = args.color
local source = args.source

color = {
  (color[1] + 1)/2,
  (color[2] + 1)/2,
  (color[3] + 1)/2,
}

-- HACK this makes the player shots lowder, this sound is also played in pulse
if source.parent.type == 'player' then
  audio_source = game.add_component(self, 'audio_source', {
    sound = game.resources.sounds.flash_loops[math.random(4)],
    volume = 0.2,
  })
  audio_source.play()
end

local LIFETIME = 60
local time_left = LIFETIME

transform = game.add_component(self, 'dokidoki.transform', {pos = args.pos})
sprite = game.add_component(self, 'dokidoki.sprite', {
  image = {
    draw = function ()
      local mode = math.floor(parent.clock / 3) % 4

      local b = 1
      if mode == 1 then
        b = math.random()/5 + 0.4
      elseif mode == 2 then
        transform.orientation = transform.orientation *
          quaternion.from_rotation(vect(0, 1, 0), math.pi/6 * math.random(1))
      elseif mode == 3 then
        b = math.random()/5 + 0.2
      end
      b = b * time_left/LIFETIME * opacity
      gl.glColor3d(b*color[1], b*color[2], b*color[3])

      gl.glBegin(gl.GL_QUADS)
      gl.glVertex3d(-size, 0, -size)
      gl.glVertex3d( size, 0, -size)
      gl.glVertex3d( size, 0,  size)
      gl.glVertex3d(-size, 0,  size)
      gl.glEnd()

      gl.glColor3d(1, 1, 1)
    end
  }
})

function update()
  time_left = time_left - 1

  if time_left <= 0 then
    game.remove_component(self)
  end

  transform.pos = transform.pos + vel
  vel = vel * 0.99
end

