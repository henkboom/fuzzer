using 'dokidoki'
local graphics = require 'dokidoki.graphics'
local gl = require 'gl'
local vect = require 'dokidoki.vect'

local tex, tex_width, tex_height = graphics.texture_from_image('goat.png')

local args = ...
transform = dokidoki.transform(self)
transform.pos = args.pos

value = 1

sprite = dokidoki.sprite(self)
sprite.image = {
  draw = function ()
    local tx1 = value * 4 / tex_width
    local tx2 = tx1 + 3 / tex_width
    tex:enable()
    gl.glBegin(gl.GL_QUADS)
    gl.glTexCoord2d(tx1, 1) gl.glVertex3d(-0.5, 0, 0)
    gl.glTexCoord2d(tx2, 1) gl.glVertex3d( 0.5, 0, 0)
    gl.glTexCoord2d(tx2, 0) gl.glVertex3d( 0.5, 1, 0)
    gl.glTexCoord2d(tx1, 0) gl.glVertex3d(-0.5, 1, 0)
    gl.glEnd()
    tex:disable()
  end
}
