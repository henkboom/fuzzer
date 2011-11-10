local gl = require 'gl'

local width = 100
local height = 100

function draw()
  gl.glColor3d(0.1, 0.1, 0.1)
  gl.glBegin(gl.GL_LINES)
  for i = -100, 200 do
    gl.glVertex3d(i, 0, -100)
    gl.glVertex3d(i, 0, 200)
  end
  for i = -100, 200 do
    gl.glVertex3d(-100, 0, i)
    gl.glVertex3d(200, 0, i)
  end
  gl.glEnd()
  gl.glColor3d(1, 1, 1)
end
