using 'dokidoki'
local gl = require 'gl'
local kernel = require 'dokidoki.kernel'
local vect = require 'dokidoki.vect'

local args = ...

local ratio = 4/3
local height = 5

local transform = dokidoki.transform(self)

function set_target(new_target)
  target = new_target
end

function postupdate()
  if game.race_manager then
    local min_x = false
    local max_x = false
    local min_z = false
    local max_z = false
    for _, player_ship in ipairs(game.race_manager.player_ships) do
      local pos = player_ship.ship.transform.pos
      min_x = min_x and math.min(min_x, pos[1]) or pos[1]
      max_x = max_x and math.max(max_x, pos[1]) or pos[1]
      min_z = min_z and math.min(min_z, pos[3]) or pos[3]
      max_z = max_z and math.max(max_z, pos[3]) or pos[3]
    end
    transform.pos = vect(min_x + max_x, 0, min_z + max_z)/2
    local diagonal = vect.mag(vect(max_x-min_x, 0, max_z-min_z))
    height = math.max(5, diagonal*0.4 + 1)
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
