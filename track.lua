using 'dokidoki'
local gl = require 'gl'
local vect = dokidoki.vect

local track = class(dokidoki.component)
track._name = 'track'

function track:_init(parent)
  self:super(parent)

  self.mesh = false
  self.transform = dokidoki.transform()
  print(self.transform.position)
  self.collider = false

  self:add_handler_for('update')
  self:add_handler_for('opaque_draw')
  self:add_handler_for('draw')
end

function track:update()
  self.collider = dokidoki.retro_component(self, 'physics.collider', {
    collision_shape = physics.triangle_mesh_shape(self.mesh),
    group_mask = 1 + 2
  })
  self:remove_handler_for('update')
end

function track:draw_mesh(opaque)
  gl.glPushMatrix()
  dokidoki.graphics.apply_transform(self.transform.pos, self.transform.orientation)
  for i = 1, #self.mesh do
    local vertices = self.mesh[i]
    local off_ground = opaque
    for j = 1, #vertices do
      off_ground = off_ground or vertices[j].position[2] ~= 0
    end
    if off_ground then
      gl.glBegin(gl.GL_POLYGON)
      for j = 1, #vertices do
        gl.glVertex3d(unpack(vertices[j].position))
      end
      gl.glEnd()
    end
  end
  gl.glPopMatrix()
end

function track:opaque_draw()
  gl.glEnable(gl.GL_DEPTH_TEST)
  gl.glDepthMask(true)
  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
  gl.glColor3d(0, 0, 0)
  gl.glEnable(gl.GL_POLYGON_OFFSET_FILL)
  gl.glPolygonOffset(1, 1)

  self:draw_mesh(true)

  gl.glDisable(gl.GL_POLYGON_OFFSET_FILL)
  gl.glColor3d(1, 1, 1)
  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE)
  gl.glDepthMask(false)
  --gl.glDisable(gl.GL_DEPTH_TEST)
end

function track:draw()
  gl.glEnable(gl.GL_DEPTH_TEST)
  gl.glPolygonMode(gl.GL_FRONT_AND_BACK, gl.GL_LINE)
  self:draw_mesh(false)
  gl.glPolygonMode(gl.GL_FRONT_AND_BACK, gl.GL_FILL)
  gl.glDisable(gl.GL_DEPTH_TEST)
end

return track
