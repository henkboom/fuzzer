local gl = require 'gl'

local args = ...
local size = args.size
color = args.color or {0.4, 0.4, 0.4}

local function set_color(b)
  gl.glColor3d(b*color[1], b*color[2], b*color[3])
end

local image = {
  draw = function()
    -- half-width and half-length
    local hwidth = size[3]
    local hlength = size[1]
    local front = 0.1
    local back = 0.2
  
    set_color(0.25)
    gl.glBegin(gl.GL_QUADS)
      gl.glVertex3d(-hlength, 0, -hwidth)
      gl.glVertex3d( hlength, 0, -hwidth)
      gl.glVertex3d( hlength, 0,  hwidth)
      gl.glVertex3d(-hlength, 0,  hwidth)
    gl.glEnd()

    set_color(1)
    gl.glBegin(gl.GL_LINE_LOOP)
      gl.glVertex3d(-hlength, back,  -hwidth)
      gl.glVertex3d( 0,      back,   -hwidth)
      gl.glVertex3d( hlength, front, -hwidth)
      gl.glVertex3d( hlength, front,  hwidth)
      gl.glVertex3d( 0,      back,    hwidth)
      gl.glVertex3d(-hlength, back,   hwidth)
    gl.glEnd()
  end
}

game.add_component(self, 'dokidoki.sprite', {
  transform = game.optional_argument(..., 'transform', parent.transform),
  image = image
})

