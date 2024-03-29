local stb_image = require 'stb_image'
local vect = require 'dokidoki.vect'
local quaternion = require 'dokidoki.quaternion'
local gl = require 'gl'
local audio_source = require 'audio_source'
local track = require 'track'
local enemy = require 'enemy'

-- just for now, soon I'll port this to be a class with a proper constructor
local players_to_use = ...

game.add_component(self, 'terrain')
powerup_sound = audio_source(self)
powerup_sound.sound = game.resources.sounds.powerup
powerup_sound.volume = 1
powerup_sound:play()

win_sound = audio_source(self)
win_sound.sound = game.resources.sounds.win
win_sound.volume = 2

checkpoints = { }

local reset_countdown

local track_data = game.resources.firsttrack
track = track(self)
track.mesh = track_data.track
local checkpoint_meshes = {}
for k,v in pairs(track_data) do
  if string.match(k, '^checkpoint%.') then
    table.insert(checkpoint_meshes, {name = k, mesh = v})
  end
end
table.sort(checkpoint_meshes, function (a, b) return a.name < b.name end)
for i = 1, #checkpoint_meshes do
  table.insert(checkpoints,
    game.add_component(self, 'checkpoint', {mesh = checkpoint_meshes[i].mesh}))
end

--local level_data, level_width, level_height =
--  assert(stb_image.load('level.png', 1))
--
--local function block_at(i, j)
--  return i >= 0 and i < level_width and j >= 0 and j < level_height and
--         string.byte(level_data, 1+i+j*level_width) == 255
--end
--
--local blocks = {}
--for i = 0, level_width-1 do
--  for j = 0, level_height-1 do
--    if block_at(i, j) then
--      table.insert(blocks,
--        game.add_component(self, 'block', {
--          pos=vect(i+0.5, 0, j+0.5),
--          left = block_at(i-1, j),
--          right = block_at(i, j+1)
--        }))
--    end
--  end
--end
--
--local block_display_list = nil
--function draw()
--  if not block_display_list then
--    block_display_list = gl.glGenLists(1);
--    gl.glNewList(block_display_list, gl.GL_COMPILE)
--    for i = 1, #blocks do
--      blocks[i].manual_draw()
--    end
--    gl.glEndList()
--  end
--  gl.glCallList(block_display_list)
--end

local orientation = quaternion.from_rotation(vect.j, math.pi/2)

local player_positions = {}
local start_meshes = {}
for k,v in pairs(track_data) do
  if string.match(k, '^start%.') then
    table.insert(start_meshes, {name = k, mesh = v})
  end
end
table.sort(start_meshes, function (a, b) return a.name < b.name end)
for i = 1, #start_meshes do
  local avg = vect.zero
  local vertex_count = 0
  for face_index = 1, #start_meshes[i].mesh do
    local face = start_meshes[i].mesh[face_index]
    for vertex_index = 1, #face do
      avg = avg + face[vertex_index].position
      vertex_count = vertex_count + 1
    end
  end
  avg = avg / vertex_count
  table.insert(player_positions, avg)
end

player_ships = {}
local next_pos = 1
for _, player in ipairs(players_to_use) do
  if player.is_human then
    table.insert(player_ships, game.add_component(self, 'player_ship', {
      pos = player_positions[next_pos],
      orientation = orientation,
      player = player
    }))
  else
    table.insert(player_ships, enemy(self, {
      pos = player_positions[next_pos],
      orientation = orientation,
      player = player
    }))
  end
  next_pos = next_pos + 1
end

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
    win_sound:play()
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
