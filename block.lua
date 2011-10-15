local gl = require 'gl'

local args = ...

local h = math.tan(math.pi/6)*math.sqrt(2)/2
local left = args.left
local right = args.right

transform = game.add_component(self, 'dokidoki.transform', {
  pos = args.pos
})
collider = game.add_component(self, 'collider', {
  size = {0.6, 10, 0.6},
  collision_mask = 0
})

function manual_draw()
  local x1 = transform.pos[1] - 0.5
  local x2 = transform.pos[1] + 0.5
  local z1 = transform.pos[3] - 0.5
  local z2 = transform.pos[3] + 0.5

  gl.glBegin(gl.GL_LINE_LOOP)
  gl.glVertex3d(x1, h, z1)
  gl.glVertex3d(x2, h, z1)
  gl.glVertex3d(x2, h, z2)
  gl.glVertex3d(x1, h, z2)
  gl.glEnd()

  if not left then
    gl.glBegin(gl.GL_LINE_STRIP)
    gl.glVertex3d(x1, h, z1)
    gl.glVertex3d(x1, 0, z1)
    gl.glVertex3d(x1, 0, z2)
    gl.glVertex3d(x1, h, z2)
    gl.glEnd()
  end

  if not right then
    gl.glBegin(gl.GL_LINE_STRIP)
    gl.glVertex3d(x1, h, z2)
    gl.glVertex3d(x1, 0, z2)
    gl.glVertex3d(x2, 0, z2)
    gl.glVertex3d(x2, h, z2)
    gl.glEnd()
  end

  gl.glBegin(gl.GL_LINE_STRIP)
  gl.glVertex3d(x1, h, z1)
  gl.glVertex3d(x2, h, z1)
  gl.glVertex3d(x2, h, z2)
  gl.glEnd()
end
