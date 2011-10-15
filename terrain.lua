local gl = require 'gl'

local width = 100
local height = 100

function draw()
  gl.glColor3d(0.1, 0.1, 0.1)
  gl.glBegin(gl.GL_LINES)
  for i = 0, width do
    gl.glVertex3d(i, 0, 0)
    gl.glVertex3d(i, 0, height)
  end
  for i = 0, height do
    gl.glVertex3d(0, 0, i)
    gl.glVertex3d(width, 0, i)
  end
  gl.glEnd()
  gl.glColor3d(1, 1, 1)
end
