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

EDGEWIDTH_X = 6
EDGEWIDTH_Y = 12

TETRIS_PIECE_SIZE = 6

TETRIS_BOARD_COUNT_W = 10
TETRIS_BOARD_COUNT_H = 20

TETRIS_BOARD_W = TETRIS_BOARD_COUNT_W * (TETRIS_PIECE_SIZE)
TETRIS_BOARD_H = TETRIS_BOARD_COUNT_H * (TETRIS_PIECE_SIZE)

TETRIS_BOARD_X = (GAME_WIDTH / 2) - (TETRIS_BOARD_W / 2)
TETRIS_BOARD_Y = (GAME_HEIGHT / 2) - ((TETRIS_BOARD_H+EDGEWIDTH_Y) / 2)

BLACK  = {0, 0, 0}
WHITE  = {1, 1, 1}
RED    = {1, 0, 0}
BLUE   = {0, 0, 1}
CYAN   = {0, 1, 1}
GREEN  = {0, 1, 0}
ORANGE = {1, 0.45, 0}
GOLD   = {1, 0.6, 0.1}
YELLOW = {1, 1, 0}
GRAY   = {0.5, 0.5, 0.5}
GRAY_DARK = {.2,.2,.2}

TICKRATE = 60

--F_GRAVITYDELAY = 24
F_LOCKDELAY = 30
LOCKMOVELIMIT = 15

LV_GRAV = {
    60,48,37,28,21,16,11,8,6,4,3,2,1
}

REPEAT_KEYS = {["a"]=true, ["d"]=true, ["s"]=true}
REPEAT_KEYS_CLASHES = {["a"]="d", ["d"]="a"}
F_REPEAT_DELAY = 14
F_REPEAT_RATE = 3

F_ANIM_LINECLEAR_START = 15
F_ANIM_LINECLEAR_END_A = 70
F_ANIM_LINECLEAR_END_B = 90

BASE_LINE_SCORES = {100,300,500,800}

START_LEVEL = 4
LEVEL_CLEAR_LINES = 10

F_ANIM_LEVELUP_STEP = 5
F_ANIM_LEVELUP_LEN = F_ANIM_LEVELUP_STEP * 7 * 3


require "constants_pieces"