lg = love.graphics
lm = love.mouse
li = love.image
la = love.audio
lw = love.window
lf = love.filesystem
le = love.event

abs = math.abs
sin = math.sin
cos = math.cos
floor = math.floor
max = math.max
min = math.min

PI = 3.1415
TAU = PI * 2

GAME_WIDTH = 240
GAME_HEIGHT = 160
SCALE = 2

TETRIS_PIECE_SIZE = 6

TETRIS_BOARD_COUNT_W = 10
TETRIS_BOARD_COUNT_H = 20

TETRIS_BOARD_W = TETRIS_BOARD_COUNT_W * (TETRIS_PIECE_SIZE)
TETRIS_BOARD_H = TETRIS_BOARD_COUNT_H * (TETRIS_PIECE_SIZE)

TETRIS_BOARD_X = (GAME_WIDTH / 2) - (TETRIS_BOARD_W / 2)
TETRIS_BOARD_Y = (GAME_HEIGHT / 2) - (TETRIS_BOARD_H / 2)

BLACK  = {0, 0, 0}
WHITE  = {1, 1, 1}
RED    = {1, 0, 0}
BLUE   = {0, 0, 1}
ORANGE = {1, 0.45, 0}
GOLD   = {1, 0.6, 0.1}
GRAY   = {0.5, 0.5, 0.5}
GRAY_DARK = {.2,.2,.2}

TICKRATE = 60

F_GRAVITYDELAY = 24
F_LOCKDELAY = 10 + F_GRAVITYDELAY
LOCKMOVELIMIT = 15

REPEAT_KEYS = {["a"]=true, ["d"]=true, ["s"]=true}
REPEAT_KEYS_CLASHES = {["a"]="d", ["d"]="a"}
F_REPEAT_DELAY = 14
F_REPEAT_RATE = 3

F_ANIM_LINECLEAR_DURATION = TICKRATE*1
F_ANIM_LINECLEAR_PARTICLE_RANGE = 15

require "constants_pieces"