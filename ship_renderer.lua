using 'dokidoki'
local gl = require 'gl'

local DEFAULT_COLOR = {0.4, 0.4, 0.4}

local ship_renderer = class(dokidoki.component)
ship_renderer._name = 'ship_renderer'

function ship_renderer:_init(parent, transform)
  self:super(parent)
  self.size = false
  self.color = DEFAULT_COLOR

  self.sprite = dokidoki.sprite(self, transform)
  self.sprite.image = { draw = function () self:_sprite_draw() end }
end

function ship_renderer:_set_color(b)
  local color = self.color
  gl.glColor3d(b*color[1], b*color[2], b*color[3])
end

function ship_renderer:_sprite_draw()
  -- half-width and half-length
  local hwidth = self.size[3]
  local hlength = self.size[1]
  local front = 0.1
  local back = 0.2
  
  self:_set_color(0.25)
  gl.glBegin(gl.GL_QUADS)
    gl.glVertex3d(-hlength, 0, -hwidth)
    gl.glVertex3d( hlength, 0, -hwidth)
    gl.glVertex3d( hlength, 0,  hwidth)
    gl.glVertex3d(-hlength, 0,  hwidth)
  gl.glEnd()

  self:_set_color(1)
  gl.glBegin(gl.GL_LINE_LOOP)
    gl.glVertex3d(-hlength, back,  -hwidth)
    gl.glVertex3d( 0,       back,  -hwidth)
    gl.glVertex3d( hlength, front, -hwidth)
    gl.glVertex3d( hlength, front,  hwidth)
    gl.glVertex3d( 0,       back,   hwidth)
    gl.glVertex3d(-hlength, back,   hwidth)
  gl.glEnd()
  gl.glColor3d(1, 1, 1)
end

return ship_renderer
