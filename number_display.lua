local graphics = require 'dokidoki.graphics'
local gl = require 'gl'
local vect = require 'dokidoki.vect'

local tex, tex_width, tex_height = graphics.texture_from_image('numbers.png')

local args = ...
local poss = {vect(55.5, 0, 44.5), vect(60.5, 0, 44.5)}
--print(args.pnum)
transform = game.add_component(self, 'dokidoki.transform', {pos = poss[args.pnum+1]})

value = 1

sprite = game.add_component(self, 'dokidoki.sprite', {
  image = {
    draw = function ()
      local tx1 = value * 4 / tex_width
      local tx2 = tx1 + 3 / tex_width
      tex:enable()
      gl.glBegin(gl.GL_QUADS)
      gl.glTexCoord2d(tx1, 5/tex_height) gl.glVertex3d(-0.5, 1, 0)
      gl.glTexCoord2d(tx2, 5/tex_height) gl.glVertex3d( 0.5, 1, 0)
      gl.glTexCoord2d(tx2, 0) gl.glVertex3d( 0.5, 2, 0)
      gl.glTexCoord2d(tx1, 0) gl.glVertex3d(-0.5, 2, 0)
      gl.glEnd()
      tex:disable()
    end
  }
})
