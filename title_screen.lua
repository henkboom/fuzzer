using 'dokidoki'

local player = require 'player'
local gl = require 'gl'
local vect = dokidoki.vect

local title_screen = class(dokidoki.component)
title_screen._name = 'title_screen'

function title_screen:_init(parent)
  self:super(parent)
  self.game.race_manager = dokidoki.retro_component(self.game, 'race_manager', {
    player(1, false),
    player(2, false),
    player(3, false),
    player(4, false),
  })

  self.human_players = {
    player(1, true),
    player(2, true),
    player(3, true),
    player(4, true),
  }
  self.player_inputs = {
    dokidoki.retro_component(self, 'player_input', {player = self.human_players[1]}),
    dokidoki.retro_component(self, 'player_input', {player = self.human_players[2]}),
    dokidoki.retro_component(self, 'player_input', {player = self.human_players[3]}),
    dokidoki.retro_component(self, 'player_input', {player = self.human_players[4]}),
  }
  self.players_confirmed = { false, false, false, false }
  self.player_count = 0

  self.time = 0
  self.countdown_time = false

  self:add_handler_for('update')
  self:add_handler_for('postdraw')
end

function title_screen:update()
  self.time = self.time + 1
  if self.countdown_time then
    self.countdown_time = self.countdown_time - 1
  end
  if self.countdown_time and self.countdown_time < 0 then
    local players = {}
    for i = 1, 4 do
      players[i] = player(i, self.players_confirmed[i])
    end
    self.game.race_manager:remove()
    self.game.race_manager =
      dokidoki.retro_component(self.game, 'race_manager', players)
    self:remove()
  end

  if self.time > 120 then
    for i = 1, #self.player_inputs do
      if self.player_inputs[i].acceleration > 0.7 and
         not self.players_confirmed[i]
      then
        self.player_count = self.player_count + 1
        self.players_confirmed[i] = true
        self.game.resources.sounds.finish_lap:play(3)
        if self.player_count > 1 then
          self.countdown_time = 5*60
        end
      end
    end
  end

end

local player_inactive_texts = {
  ' ...                ',
  '      ...           ',
  '           ...      ',
  '                ... '
}

local player_active_texts = {
  ' !!!                ',
  '      !!!           ',
  '           !!!      ',
  '                !!! '
}

function title_screen:postdraw()
  local height = 60
  local ratio = dokidoki.kernel.get_ratio()

  gl.glMatrixMode(gl.GL_PROJECTION)
  gl.glLoadIdentity()
  gl.glOrtho(0, ratio*height, 0, height, 100, -100)
  gl.glMatrixMode(gl.GL_TEXTURE)
  gl.glLoadIdentity()
  gl.glMatrixMode(gl.GL_MODELVIEW)
  gl.glLoadIdentity()

  local font = self.game.resources.font
  local line_height = dokidoki.graphics.font_map_line_height(font)

  local b = math.sqrt(math.random()) * math.max(0, math.min(1, (self.time-120)/30))

  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA)
  gl.glColor4d(0, 0, 0, (0.4 * b)+0.1 + (self.countdown_time and 0.5 or 0))
  gl.glBegin(gl.GL_QUADS)
  gl.glVertex2d(0, 0)
  gl.glVertex2d(ratio*height, 0)
  gl.glVertex2d(ratio*height, height)
  gl.glVertex2d(0, height)
  gl.glEnd()
  gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE)

  gl.glTranslated(0, height-line_height/2, 0)
  gl.glColor4d(1,1,1,b)
  if self.countdown_time then
    dokidoki.graphics.draw_text(font, "    starting  in    \n        " ..
                                      string.format("%3d", self.countdown_time))
  else
    dokidoki.graphics.draw_text(font, "       FUZZER       \n"..
                                      "     henk  boom     \n"..
                                      "  richard flanagan  ")
  end
  gl.glTranslated(0, -4*line_height, 0)
  if self.player_count > 0 then
    if self.player_count < 2 then
      dokidoki.graphics.draw_text(font,"  one more player   ")
    end
  else
    dokidoki.graphics.draw_text(font,"  press A to start  ")
  end
  gl.glTranslated(0, -1*line_height, 0)
  for i = 1, 4 do
    if self.players_confirmed[i] then
      local color = self.human_players[i].color
      gl.glColor4d(color[1], color[2], color[3], b)
      dokidoki.graphics.draw_text(font,player_active_texts[i])
      gl.glColor4d(1, 1, 1, b)
    else
      dokidoki.graphics.draw_text(font,player_inactive_texts[i])
    end
  end
  gl.glColor3d(1, 1, 1)
end

return title_screen
