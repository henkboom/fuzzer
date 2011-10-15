local mixer = require 'mixer'

sounds = {
  shoot = {
    mixer.load_wav('sounds/shoot_player_1.wav'),
    mixer.load_wav('sounds/shoot_player_2.wav'),
  },
  hit_wall = {
    mixer.load_wav('sounds/hit_wall_1.wav'),
    mixer.load_wav('sounds/hit_wall_2.wav'),
    mixer.load_wav('sounds/hit_wall_3.wav'),
  },
  finish_lap = mixer.load_wav('sounds/finish_lap.wav'),
  music = mixer.load_wav('sounds/music.wav'),
  engine_loops = {
    mixer.load_wav('sounds/engine_loop_1.wav'),
    mixer.load_wav('sounds/engine_loop_2.wav'),
  },
  flash_loops = {
    assert(mixer.load_wav('sounds/flash_1.wav')),
    assert(mixer.load_wav('sounds/flash_2.wav')),
    assert(mixer.load_wav('sounds/flash_3.wav')),
    assert(mixer.load_wav('sounds/flash_4.wav')),
    --assert(mixer.load_wav('sounds/flash_1_alt.wav')),
    --assert(mixer.load_wav('sounds/flash_2_alt.wav')),
  },
  powerup = assert(mixer.load_wav('sounds/powerup.wav')),
  win = assert(mixer.load_wav('sounds/win.wav')),
}
