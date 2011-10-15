local vect = require 'dokidoki.vect'
local gl = require 'gl'

local args = ...

local rect = assert(args.rect)
local size = {(rect[3] - rect[1])/2, 1, (rect[4]-rect[2])/2}

transform = game.add_component(self, 'dokidoki.transform', {
  pos = vect((rect[3]+rect[1])/2, 0, (rect[4]+rect[2])/2)
})
collider = game.add_component(self, 'collider', {size = size})
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
