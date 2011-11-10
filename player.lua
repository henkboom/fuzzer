local player = class()
player._name = 'player'

local ai_color = {0.80, 0.80, 0.80}

local colors = {
  {0.33, 0.80, 0.16},
  {0.23, 0.16, 0.80},
  {0.80, 0.16, 0.78},
  {0.80, 0.78, 0.16},
}


function player:_init(number, is_human)
  self.number = number
  self.is_human = is_human
  if is_human then
    self.color = colors[number]
  else
    self.color = ai_color
  end
end

return player
