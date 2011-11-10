using 'dokidoki'
using 'physics'
local vect = require 'dokidoki.vect'
local gl = require 'gl'

local args = ...

--local rect = assert(args.rect)
local mesh = assert(args.mesh)

transform = dokidoki.transform(self)
--transform.pos = vect((rect[3]+rect[1])/2, 0, (rect[4]+rect[2])/2)

local vertex_count = 0
center = vect.zero
for i = 1, #mesh do
  local face = mesh[i]
  for j = 1, #face do
    vertex_count = vertex_count + 1
    center = center + face[j].position
  end
end
center = center / vertex_count

local shape = physics.triangle_mesh_shape(mesh)
collider = game.add_component(self, 'physics.collider', {
  collision_shape = shape
})
--sprite = game.add_component(self, 'dokidoki.sprite', {
--  image = {
--    draw = function ()
--      gl.glLineWidth(2)
--      gl.glColor3d(0, 0, 0.3)
--      gl.glBegin(gl.GL_LINE_LOOP)
--      gl.glVertex3d(-size[1], 0, -size[3])
--      gl.glVertex3d( size[1], 0, -size[3])
--      gl.glVertex3d( size[1], 0,  size[3])
--      gl.glVertex3d(-size[1], 0,  size[3])
--      gl.glEnd()
--      gl.glBegin(gl.GL_LINES)
--      gl.glVertex3d(-size[1], 0, -size[3])
--      gl.glVertex3d( size[1], 0,  size[3])
--      gl.glVertex3d( size[1], 0, -size[3])
--      gl.glVertex3d(-size[1], 0,  size[3])
--      gl.glEnd()
--      gl.glLineWidth(1)
--      gl.glColor3d(1, 1, 1)
--    end
--  }
--})
