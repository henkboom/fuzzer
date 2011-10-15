local stb_image = require 'stb_image'
local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'
local gl = require 'gl'

game.add_component(self, 'terrain')
powerup_sound = game.add_component(self, 'audio_source', {
  sound = game.resources.sounds.powerup,
  volume = 1,
})
powerup_sound.play()

win_sound = game.add_component(self, 'audio_source', {
  sound = game.resources.sounds.win,
  volume = 2,
})

checkpoints = { }

local reset_countdown

local checkpoint_data = dofile('level_checkpoints.lua')
for i = 1, #checkpoint_data do
  table.insert(checkpoints,
    game.add_component(self, 'checkpoint', {rect = checkpoint_data[i]}))
end

local level_data, level_width, level_height =
  assert(stb_image.load('level.png', 1))

local function block_at(i, j)
  return i >= 0 and i < level_width and j >= 0 and j < level_height and
         string.byte(level_data, 1+i+j*level_width) == 255
end

local blocks = {}
for i = 0, level_width-1 do
  for j = 0, level_height-1 do
    if block_at(i, j) then
      table.insert(blocks,
        game.add_component(self, 'block', {
          pos=vect(i+0.5, 0, j+0.5),
          left = block_at(i-1, j),
          right = block_at(i, j+1)
        }))
    end
  end
end

local block_display_list = nil
function draw()
  if not block_display_list then
    block_display_list = gl.glGenLists(1);
    gl.glNewList(block_display_list, gl.GL_COMPILE)
    for i = 1, #blocks do
      blocks[i].manual_draw()
    end
    gl.glEndList()
  end
  gl.glCallList(block_display_list)
end

local orientation = quaternion.from_rotation(vect.j, math.pi/2)
player1 = game.add_component(self, 'player', {
  pos = vect(56.5, 0, 45.5),
  orientation = orientation,
  color = {0.6, 0.2, 0.8},
  input_num=0
})
--print(player1.parent.type)

player2 = game.add_component(self, 'player', {
  pos = vect(56.5, 0, 45.5),
  orientation = orientation,
  color = {0.6, 0.8, 0.2},
  input_num=1
})

game.add_component(self, 'enemy', {
  pos = vect(57.5, 0, 45.5),
  orientation = orientation
})
game.add_component(self, 'enemy', {
  pos = vect(58.5, 0, 45.5),
  orientation = orientation
})
game.add_component(self, 'enemy', {
  pos = vect(59.5, 0, 45.5),
  orientation = orientation
})

game.add_component(self, 'goat', { pos = vect(70, 0, 50) })
game.add_component(self, 'goat', { pos = vect(72, 0, 51) })
game.add_component(self, 'goat', { pos = vect(73, 0, 45) })

function on_removal()
  if block_display_list then
    gl.glDeleteLists(block_display_list, 1)
    block_display_list = nil
  end
end

function race_over()
  if not reset_countdown then
    reset_countdown = 230
    win_sound.play()
  end
end

function update()
  if reset_countdown then
    reset_countdown = reset_countdown - 1
    if reset_countdown <= 0 then
      game.reset()
    end
  end
end
