clock = 0

function trigger_flare(pos, vel, color, source)
  game.add_component(self, 'flare', {
    pos = pos,
    vel = vel,
    opacity = 0.3,
    size = 3,
    color = color,
    source = source
  })
  game.add_component(self, 'flare', {
    pos = pos,
    vel = vel,
    opacity = 0.1,
    size = 6,
    color = color,
    source = source
  })
end

function update()
  clock = clock + 1
end
