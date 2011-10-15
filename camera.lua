local gl = require 'gl'
local kernel = require 'dokidoki.kernel'
local vect = require 'dokidoki.vect'

local args = ...

local ratio = 16/9
local height = 5

local transform = game.add_component(self, 'dokidoki.transform')

function set_target(new_target)
  target = new_target
end

function postupdate()
  if game.race_manager then
    local pos1 = game.race_manager.player1.ship.transform.pos
    local pos2 = game.race_manager.player2.ship.transform.pos
    transform.pos = (pos1 + pos2)/2
    height = math.max(5, vect.mag(pos1 - pos2)*0.4 + 1)
  else
    transform.pos = vect(0, 0, 0)
    height = 5
  end
end

function predraw ()
  kernel.set_ratio(ratio)

  gl.glClearColor(0, 0, 0, 0)
  gl.glClear(gl.GL_COLOR_BUFFER_BIT)

  gl.glEnable(gl.GL_BLEND)
  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE)
  gl.glAlphaFunc(gl.GL_GREATER, 0)
  gl.glEnable(gl.GL_ALPHA_TEST)
  gl.glDisable(gl.GL_DEPTH_TEST)

  gl.glMatrixMode(gl.GL_PROJECTION)
  gl.glLoadIdentity()
  gl.glOrtho(-ratio*height, ratio*height, -height, height, 100, -100)
  gl.glMatrixMode(gl.GL_TEXTURE)
  gl.glLoadIdentity()
  gl.glMatrixMode(gl.GL_MODELVIEW)
  gl.glLoadIdentity()
  --gl.glRotated(math.sin(0.5/math.sqrt(2))*180/math.pi, 1, 0, 0)
  gl.glRotated(30, 1, 0, 0)
  gl.glRotated(45, 0, 1, 0)
  gl.glTranslated(vect.coords(-transform.pos))
end
