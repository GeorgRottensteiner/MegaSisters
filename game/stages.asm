EL__BRICK = 0
EL__GROUND.C = 1
EL__STAR = 2
EL__PIPEPIECE = 3
EL__DIAMOND = 4
EL__BLOCKSMALL = 5
EL__BLOCK3X2 = 6
EL__BRIDGE = 7
EL__GROUND.R = 8
EL__GROUND.L = 9
EL__EXIT = 10
EL__STAREXTRA = 11
EL__STYLE = 12
EL__BUSH.1 = 13
EL__BUSH.2 = 14
EL__MUSHROOM = 15
EL__BRICK_DIAMOND = 16
EL__GROUND.BRICK = 17
EL__SECRET = 18
EL__COLUMN = 19
EL__UNDERGROUNDBRICK = 20
EL__WATER.TOP = 21
EL__WATER = 22
EL__VINES = 23

ELEMENT_WIDTH_TABLE
!byte 3,4,3,6,2,2,3,2,2,2,2,3,5,6,6,4,3,2,2,3,2,2,2,2
ELEMENT_HEIGHT_TABLE
!byte 2,3,2,3,2,2,2,1,3,3,2,2,1,2,3,3,2,2,1,1,2,1,2,2
ELEMENT_TABLE_LO
!byte <( DATA_EL__BRICK )
!byte <( DATA_EL__GROUND.C )
!byte <( DATA_EL__STAR )
!byte <( DATA_EL__PIPEPIECE )
!byte <( DATA_EL__DIAMOND )
!byte <( DATA_EL__BLOCKSMALL )
!byte <( DATA_EL__BLOCK3X2 )
!byte <( DATA_EL__BRIDGE )
!byte <( DATA_EL__GROUND.R )
!byte <( DATA_EL__GROUND.L )
!byte <( DATA_EL__EXIT )
!byte <( DATA_EL__STAREXTRA )
!byte <( DATA_EL__STYLE )
!byte <( DATA_EL__BUSH.1 )
!byte <( DATA_EL__BUSH.2 )
!byte <( DATA_EL__MUSHROOM )
!byte <( DATA_EL__BRICK_DIAMOND )
!byte <( DATA_EL__GROUND.BRICK )
!byte <( DATA_EL__SECRET )
!byte <( DATA_EL__COLUMN )
!byte <( DATA_EL__UNDERGROUNDBRICK )
!byte <( DATA_EL__WATER.TOP )
!byte <( DATA_EL__WATER )
!byte <( DATA_EL__VINES )

ELEMENT_TABLE_HI
!byte >( DATA_EL__BRICK )
!byte >( DATA_EL__GROUND.C )
!byte >( DATA_EL__STAR )
!byte >( DATA_EL__PIPEPIECE )
!byte >( DATA_EL__DIAMOND )
!byte >( DATA_EL__BLOCKSMALL )
!byte >( DATA_EL__BLOCK3X2 )
!byte >( DATA_EL__BRIDGE )
!byte >( DATA_EL__GROUND.R )
!byte >( DATA_EL__GROUND.L )
!byte >( DATA_EL__EXIT )
!byte >( DATA_EL__STAREXTRA )
!byte >( DATA_EL__STYLE )
!byte >( DATA_EL__BUSH.1 )
!byte >( DATA_EL__BUSH.2 )
!byte >( DATA_EL__MUSHROOM )
!byte >( DATA_EL__BRICK_DIAMOND )
!byte >( DATA_EL__GROUND.BRICK )
!byte >( DATA_EL__SECRET )
!byte >( DATA_EL__COLUMN )
!byte >( DATA_EL__UNDERGROUNDBRICK )
!byte >( DATA_EL__WATER.TOP )
!byte >( DATA_EL__WATER )
!byte >( DATA_EL__VINES )

DATA_EL__BRICK
!byte 60,63,61,64,62,65
DATA_EL__GROUND.C
!byte 67,71,75,68,72,76,69,73,77,70,74,78
DATA_EL__STAR
!byte 79,82,80,83,81,84
DATA_EL__PIPEPIECE
!byte 85,91,97,86,92,98,87,93,99,88,94,100,89,95,101,90,96,102
DATA_EL__DIAMOND
!byte 0,2,1,3
DATA_EL__BLOCKSMALL
!byte 103,106,105,108
DATA_EL__BLOCK3X2
!byte 103,106,104,107,105,108
DATA_EL__BRIDGE
!byte 109,110
DATA_EL__GROUND.R
!byte 115,117,119,116,118,4
DATA_EL__GROUND.L
!byte 120,122,4,121,123,124
DATA_EL__EXIT
!byte 5,5,5,5
DATA_EL__STAREXTRA
!byte 79,82,80,83,125,84
DATA_EL__STYLE
!byte 226,227,232,219,212
DATA_EL__BUSH.1
!byte 6,12,7,13,8,14,9,15,10,16,11,17
DATA_EL__BUSH.2
!byte 18,24,30,19,25,31,20,26,32,21,27,33,22,28,34,23,29,35
DATA_EL__MUSHROOM
!byte 36,40,4,37,41,44,38,42,45,39,43,4
DATA_EL__BRICK_DIAMOND
!byte 60,63,61,64,126,65
DATA_EL__GROUND.BRICK
!byte 127,128,128,127
DATA_EL__SECRET
!byte 58,58
DATA_EL__COLUMN
!byte 129,130,131
DATA_EL__UNDERGROUNDBRICK
!byte 132,133,133,132
DATA_EL__WATER.TOP
!byte 192,193
DATA_EL__WATER
!byte 194,194,194,194
DATA_EL__VINES
!byte 134,136,135,137


_SCREEN_DATA_TABLE
          !word _LEVEL_1
          !word _LEVEL_2
          !word _LEVEL_3
          !word _LEVEL_4
          !word _LEVEL_5
          !word 0


_LEVEL_1 ;Title
          !word 290
          !byte 0
          !byte LDF_ELEMENT_LINE + 22,28,EL__GROUND.C
          !byte LDF_X_POS + 15; 15
          !byte LDF_ELEMENT_LINE + 19,1,EL__MUSHROOM
          !byte LDF_X_POS + 11; 26
          !byte LDF_ELEMENT_AREA + 7,1,10,EL__COLUMN
          !byte LDF_X_POS + 13; 39
          !byte LDF_ELEMENT_LINE + 5,3,EL__BRICK
          !byte LDF_X_POS + 3; 42
          !byte LDF_ELEMENT_AREA + 7,1,10,EL__COLUMN
          !byte LDF_X_POS + 3; 45
          !byte LDF_ELEMENT_LINE + 20,1,EL__BUSH.1
          !byte LDF_X_POS + 4; 49
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BRICK
          !byte LDF_X_POS + 3; 52
          !byte LDF_PREV_ELEMENT_LINE + 10,1
          !byte LDF_X_POS + 3; 55
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 4; 59
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 2; 61
          !byte LDF_ELEMENT_LINE + 2,1,EL__BUSH.2
          !byte LDF_X_POS + 1; 62
          !byte LDF_ELEMENT_LINE + 5,2,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_PREV_ELEMENT_LINE + 10,1
          !byte LDF_X_POS + 9; 71
          !byte LDF_ELEMENT_LINE + 16,1,EL__PIPEPIECE
          !byte LDF_PREV_ELEMENT_LINE + 19,1
          !byte LDF_X_POS + 2; 73
          !byte LD_OBJECT | 1, 15
          !byte LDF_X_POS + 8; 81
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BRICK
          !byte LDF_X_POS + 3; 84
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 2; 86
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 1; 87
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_PREV_ELEMENT_AREA + 11, 1,130
          !byte LDF_X_POS + 4; 91
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BLOCK3X2
          !byte LDF_X_POS + 3; 94
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 1; 95
          !byte LDF_PREV_ELEMENT_LINE + 11,1
          !byte LDF_X_POS + 2; 97
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,131
          !byte LDF_PREV_ELEMENT_AREA + 13, 1,130
          !byte LDF_X_POS + 4; 101
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 3; 104
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 2; 106
          !byte LDF_ELEMENT_LINE + 20,1,EL__BUSH.1
          !byte LDF_X_POS + 5; 111
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BLOCK3X2
          !byte LDF_X_POS + 1; 112
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 2; 114
          !byte LDF_ELEMENT_LINE + 5,1,EL__BLOCK3X2
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 3; 117
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 4; 121
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_ELEMENT_LINE + 5,3,EL__BLOCK3X2
          !byte LDF_X_POS + 2; 123
          !byte LDF_ELEMENT_LINE + 22,9,EL__GROUND.C
          !byte LDF_X_POS + 1; 124
          !byte LDF_ELEMENT_AREA + 7, 1,5,EL__BLOCK3X2
          !byte LDF_ELEMENT_LINE + 19,1,EL__BUSH.2
          !byte LDF_X_POS + 11; 135
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BRICK
          !byte LDF_X_POS + 3; 138
          !byte LDF_PREV_ELEMENT_LINE + 6,1
          !byte LDF_X_POS + 3; 141
          !byte LDF_ELEMENT_LINE + 7,1,EL__STAR
          !byte LDF_X_POS + 3; 144
          !byte LDF_ELEMENT_LINE + 6,1,EL__BRICK
          !byte LDF_X_POS + 3; 147
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 4; 151
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 3; 154
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 4; 158
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 3; 161
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BRICK
          !byte LDF_X_POS + 1; 162
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 164
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_ELEMENT_LINE + 5,2,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 2; 166
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 1; 167
          !byte LDF_PREV_ELEMENT_AREA + 9, 1,131
          !byte LDF_X_POS + 1; 168
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 170
          !byte LDF_ELEMENT_LINE + 22,18,EL__GROUND.C
          !byte LDF_X_POS + 1; 171
          !byte LDF_ELEMENT_AREA + 5, 1,6,EL__BRICK
          !byte LDF_X_POS + 3; 174
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 3; 177
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 1; 178
          !byte LDF_ELEMENT_LINE + 17,1,EL__STYLE
          !byte LDF_X_POS + 7; 185
          !byte LDF_ELEMENT_LINE + 15,2,EL__BRICK
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,131
          !byte LDF_X_POS + 3; 188
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 3; 191
          !byte LDF_PREV_ELEMENT_AREA + 9, 1,132
          !byte LDF_X_POS + 4; 195
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 4; 199
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,131
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 3; 202
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 3; 205
          !byte LDF_PREV_ELEMENT_AREA + 9, 1,132
          !byte LDF_X_POS + 1; 206
          !byte LD_OBJECT | 1, 21
          !byte LDF_X_POS + 3; 209
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_X_POS + 3; 212
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 3; 215
          !byte LD_OBJECT | 1, 21
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_X_POS + 4; 219
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 3; 222
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 7; 229
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,134
          !byte LDF_X_POS + 3; 232
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_X_POS + 2; 234
          !byte LDF_PREV_ELEMENT_LINE + 11,1
          !byte LDF_X_POS + 1; 235
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,131
          !byte LDF_PREV_ELEMENT_AREA + 13, 1,130
          !byte LDF_X_POS + 4; 239
          !byte LDF_PREV_ELEMENT_AREA + 5, 1,131
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 1; 240
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 2; 242
          !byte LDF_ELEMENT_LINE + 9,1,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 5,2
          !byte LDF_X_POS + 3; 245
          !byte LDF_PREV_ELEMENT_AREA + 9, 1,132
          !byte LDF_X_POS + 1; 246
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 248
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 1; 249
          !byte LDF_ELEMENT_LINE + 9,1,EL__DIAMOND
          !byte LDF_X_POS + 2; 251
          !byte LDF_PREV_ELEMENT_LINE + 7,1
          !byte LDF_X_POS + 2; 253
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_X_POS + 1; 254
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 256
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 5; 261
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 263
          !byte LDF_ELEMENT_LINE + 22,7,EL__GROUND.C
          !byte LD_END


_LEVEL_2 ;Stage 1
          !word 290
          !byte 0
          !byte LDF_ELEMENT_LINE + 22,28,EL__GROUND.C
          !byte LDF_X_POS + 1; 1
          !byte LDF_ELEMENT_LINE + 19,1,EL__BUSH.2
          !byte LDF_X_POS + 23; 24
          !byte LDF_ELEMENT_LINE + 20,1,EL__BUSH.1
          !byte LDF_X_POS + 9; 33
          !byte LDF_ELEMENT_LINE + 16,1,EL__BRICK_DIAMOND
          !byte LDF_X_POS + 9; 42
          !byte LDF_ELEMENT_LINE + 16,1,EL__BRICK
          !byte LDF_X_POS + 1; 43
          !byte LD_OBJECT | 1, 21
          !byte LDF_X_POS + 2; 45
          !byte LDF_PREV_ELEMENT_LINE + 9,1
          !byte LDF_ELEMENT_LINE + 16,1,EL__STAR
          !byte LDF_X_POS + 3; 48
          !byte LDF_ELEMENT_LINE + 16,1,EL__BRICK
          !byte LDF_ELEMENT_LINE + 9,1,EL__STAREXTRA
          !byte LDF_X_POS + 3; 51
          !byte LDF_ELEMENT_LINE + 16,2,EL__STAR
          !byte LDF_ELEMENT_LINE + 9,1,EL__BRICK
          !byte LDF_X_POS + 6; 57
          !byte LDF_PREV_ELEMENT_LINE + 16,1
          !byte LDF_X_POS + 18; 75
          !byte LDF_ELEMENT_LINE + 16,1,EL__PIPEPIECE
          !byte LDF_PREV_ELEMENT_LINE + 19,1
          !byte LDF_X_POS + 2; 77
          !byte LD_OBJECT | 1, 15
          !byte LDF_X_POS + 9; 86
          !byte LDF_ELEMENT_LINE + 10,3,EL__BRICK
          !byte LDF_X_POS + 2; 88
          !byte LDF_ELEMENT_LINE + 6,1,EL__DIAMOND
          !byte LDF_X_POS + 3; 91
          !byte LDF_PREV_ELEMENT_LINE + 6,1
          !byte LDF_X_POS + 9; 100
          !byte LDF_ELEMENT_LINE + 16,1,EL__PIPEPIECE
          !byte LDF_PREV_ELEMENT_LINE + 19,1
          !byte LDF_X_POS + 2; 102
          !byte LD_OBJECT | 1, 15
          !byte LDF_X_POS + 10; 112
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 1; 113
          !byte LDF_ELEMENT_LINE + 24,6,EL__SECRET
          !byte LDF_X_POS + 12; 125
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 1; 126
          !byte LDF_ELEMENT_LINE + 22,8,EL__GROUND.C
          !byte LDF_X_POS + 26; 152
          !byte LDF_ELEMENT_LINE + 20,4,EL__BLOCKSMALL
          !byte LDF_X_POS + 2; 154
          !byte LDF_PREV_ELEMENT_LINE + 18,3
          !byte LDF_X_POS + 2; 156
          !byte LDF_PREV_ELEMENT_LINE + 16,2
          !byte LDF_X_POS + 2; 158
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 2; 160
          !byte LDF_ELEMENT_LINE + 8,1,EL__BRICK
          !byte LDF_ELEMENT_LINE + 16,2,EL__BRIDGE
          !byte LDF_X_POS + 3; 163
          !byte LDF_ELEMENT_LINE + 8,1,EL__STAREXTRA
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 1; 164
          !byte LDF_ELEMENT_AREA + 16, 1,3,EL__BLOCKSMALL
          !byte LDF_ELEMENT_LINE + 14,1,EL__DIAMOND
          !byte LDF_X_POS + 1; 165
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 1; 166
          !byte LDF_ELEMENT_LINE + 8,1,EL__BRICK
          !byte LDF_ELEMENT_LINE + 16,2,EL__BRIDGE
          !byte LDF_X_POS + 4; 170
          !byte LDF_ELEMENT_LINE + 16,1,EL__BLOCKSMALL
          !byte LDF_PREV_ELEMENT_LINE + 18,2
          !byte LDF_PREV_ELEMENT_LINE + 20,3
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 172
          !byte LDF_ELEMENT_LINE + 22,17,EL__GROUND.C
          !byte LDF_X_POS + 18; 190
          !byte LDF_ELEMENT_LINE + 15,1,EL__STAR
          !byte LDF_PREV_ELEMENT_LINE + 7,1
          !byte LDF_X_POS + 3; 193
          !byte LDF_ELEMENT_LINE + 7,1,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 15,2
          !byte LDF_X_POS + 3; 196
          !byte LDF_ELEMENT_LINE + 7,1,EL__BRICK_DIAMOND
          !byte LDF_X_POS + 3; 199
          !byte LDF_ELEMENT_LINE + 7,2,EL__STAR
          !byte LDF_PREV_ELEMENT_LINE + 15,1
          !byte LDF_X_POS + 6; 205
          !byte LDF_ELEMENT_LINE + 15,1,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 7,1
          !byte LDF_X_POS + 1; 206
          !byte LD_OBJECT | 1, 21
          !byte LDF_X_POS + 9; 215
          !byte LD_OBJECT | 1, 21
          !byte LDF_X_POS + 9; 224
          !byte LDF_ELEMENT_AREA + 16,4,3,EL__BLOCK3X2
          !byte LDF_X_POS + 3; 227
          !byte LDF_PREV_ELEMENT_LINE + 14,3
          !byte LDF_X_POS + 3; 230
          !byte LDF_PREV_ELEMENT_LINE + 12,2
          !byte LDF_X_POS + 3; 233
          !byte LDF_PREV_ELEMENT_LINE + 10,1
          !byte LDF_X_POS + 6; 239
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 6; 245
          !byte LDF_ELEMENT_LINE + 13,1,EL__DIAMOND
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 247
          !byte LDF_ELEMENT_LINE + 11,1,EL__DIAMOND
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 2; 249
          !byte LDF_ELEMENT_LINE + 9,1,EL__DIAMOND
          !byte LDF_X_POS + 2; 251
          !byte LDF_PREV_ELEMENT_LINE + 7,1
          !byte LDF_X_POS + 2; 253
          !byte LDF_PREV_ELEMENT_LINE + 5,1
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 255
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.R
          !byte LDF_X_POS + 6; 261
          !byte LDF_ELEMENT_LINE + 22,1,EL__GROUND.L
          !byte LDF_X_POS + 2; 263
          !byte LDF_ELEMENT_LINE + 22,7,EL__GROUND.C
          !byte LDF_X_POS + 21; 284
          !byte LDF_ELEMENT_LINE + 16,2,EL__BLOCK3X2
          !byte LDF_PREV_ELEMENT_LINE + 14,2
          !byte LDF_X_POS + 1; 285
          !byte LDF_ELEMENT_AREA + 18,1,2,EL__EXIT
          !byte LDF_X_POS + 2; 287
          !byte LDF_ELEMENT_LINE + 20,1,EL__BLOCK3X2
          !byte LDF_PREV_ELEMENT_LINE + 18,1
          !byte LD_END


_LEVEL_3 ;Stage 2
          !word 239
          !byte 1
          !byte LDF_ELEMENT_AREA + 21,69,2,EL__GROUND.BRICK
          !byte LDF_ELEMENT_AREA + 3, 1,9,EL__BRICK
          !byte LDF_X_POS + 7; 7
          !byte LDF_PREV_ELEMENT_LINE + 3,44
          !byte LDF_X_POS + 20; 27
          !byte LDF_PREV_ELEMENT_LINE + 10,3
          !byte LDF_ELEMENT_LINE + 9,5,EL__WATER.TOP
          !byte LDF_X_POS + 6; 33
          !byte LDF_ELEMENT_AREA + 12, 1,2,EL__BRICK
          !byte LDF_X_POS + 3; 36
          !byte LDF_PREV_ELEMENT_LINE + 14,4
          !byte LDF_X_POS + 1; 37
          !byte LDF_ELEMENT_LINE + 12,4,EL__DIAMOND
          !byte LDF_X_POS + 9; 46
          !byte LDF_ELEMENT_LINE + 10,3,EL__BRICK
          !byte LDF_PREV_ELEMENT_AREA + 12, 1,130
          !byte LDF_X_POS + 24; 70
          !byte LDF_PREV_ELEMENT_AREA + 13, 1,132
          !byte LDF_X_POS + 6; 76
          !byte LDF_PREV_ELEMENT_AREA + 15, 1,131
          !byte LDF_X_POS + 7; 83
          !byte LD_OBJECT | 1, 20
          !byte LDF_X_POS + 3; 86
          !byte LDF_PREV_ELEMENT_AREA + 15, 1,131
          !byte LDF_X_POS + 6; 92
          !byte LDF_PREV_ELEMENT_AREA + 13, 1,132
          !byte LDF_X_POS + 8; 100
          !byte LDF_ELEMENT + 15,EL__STAREXTRA
          !byte LDF_X_POS + 8; 108
          !byte LDF_ELEMENT_AREA + 5, 1,5,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 15,7
          !byte LDF_X_POS + 4; 112
          !byte LD_OBJECT | 7, 14
          !byte LDF_X_POS + 1; 113
          !byte LDF_ELEMENT_LINE + 7,2,EL__DIAMOND
          !byte LDF_X_POS + 7; 120
          !byte LDF_PREV_ELEMENT_LINE + 7,2
          !byte LDF_X_POS + 4; 124
          !byte LD_OBJECT | 7, 14
          !byte LDF_X_POS + 2; 126
          !byte LDF_ELEMENT_AREA + 5, 1,5,EL__BRICK
          !byte LDF_X_POS + 18; 144
          !byte LDF_ELEMENT_LINE + 21,8,EL__BRIDGE
          !byte LDF_PREV_ELEMENT_LINE + 14,8
          !byte LDF_PREV_ELEMENT_LINE + 7,8
          !byte LDF_X_POS + 14; 158
          !byte LD_OBJECT | 1, 13
          !byte LDF_X_POS + 6; 164
          !byte LDF_ELEMENT_AREA + 21,16,2,EL__GROUND.BRICK
          !byte LDF_ELEMENT_LINE + 2,11,EL__BRICK
          !byte LDF_X_POS + 31; 200
          !byte LDF_X_POS + 5; 200
          !byte LDF_ELEMENT_LINE + 21,8,EL__BRIDGE
          !byte LDF_PREV_ELEMENT_LINE + 14,8
          !byte LDF_PREV_ELEMENT_LINE + 7,8
          !byte LDF_X_POS + 21; 221
          !byte LDF_ELEMENT_LINE + 3,6,EL__BRICK
          !byte LDF_ELEMENT_AREA + 21,9,2,EL__GROUND.BRICK
          !byte LDF_X_POS + 12; 233
          !byte LDF_ELEMENT_AREA + 5, 1,2,EL__BRICK
          !byte LDF_PREV_ELEMENT_AREA + 13, 1,130
          !byte LDF_X_POS + 2; 235
          !byte LDF_ELEMENT_AREA + 17, 1,2,EL__EXIT
          !byte LDF_PREV_ELEMENT_AREA + 9, 1,130
          !byte LDF_X_POS + 1; 236
          !byte LDF_ELEMENT_AREA + 5, 1,8,EL__BRICK
          !byte LD_END


_LEVEL_4 ;Stage 3
          !word 240
          !byte 0
          !byte LDF_ELEMENT_LINE + 2,69,EL__UNDERGROUNDBRICK
          !byte LDF_PREV_ELEMENT_AREA + 9,3,136
          !byte LDF_X_POS + 6; 6
          !byte LDF_PREV_ELEMENT_AREA + 11, 1,135
          !byte LDF_X_POS + 2; 8
          !byte LDF_PREV_ELEMENT_AREA + 13, 1,134
          !byte LDF_X_POS + 2; 10
          !byte LDF_PREV_ELEMENT_AREA + 15, 1,133
          !byte LDF_X_POS + 2; 12
          !byte LDF_PREV_ELEMENT_AREA + 17,3,132
          !byte LDF_X_POS + 6; 18
          !byte LDF_ELEMENT_LINE + 24,5,EL__WATER.TOP
          !byte LDF_X_POS + 10; 28
          !byte LDF_ELEMENT_AREA + 17,3,4,EL__UNDERGROUNDBRICK
          !byte LDF_X_POS + 6; 34
          !byte LDF_ELEMENT_LINE + 24,5,EL__WATER.TOP
          !byte LDF_X_POS + 10; 44
          !byte LDF_ELEMENT_AREA + 17,3,4,EL__UNDERGROUNDBRICK
          !byte LDF_X_POS + 6; 50
          !byte LDF_ELEMENT_LINE + 24,11,EL__WATER.TOP
          !byte LDF_X_POS + 8; 58
          !byte LDF_ELEMENT_LINE + 17,3,EL__UNDERGROUNDBRICK
          !byte LDF_ELEMENT + 9,EL__STAREXTRA
          !byte LDF_X_POS + 3; 61
          !byte LDF_ELEMENT + 9,EL__STAR
          !byte LDF_X_POS + 11; 72
          !byte LDF_ELEMENT_AREA + 17,15,4,EL__UNDERGROUNDBRICK
          !byte LDF_X_POS + 6; 78
          !byte LDF_PREV_ELEMENT_AREA + 4,12,132
          !byte LDF_X_POS + 24; 102
          !byte LDF_PREV_ELEMENT_AREA + 21,15,130
          !byte LD_END


_LEVEL_5 ;Bonus #1
          !word 40
          !byte 0
          !byte LDF_ELEMENT_AREA + 2, 1,11,EL__BRICK
          !byte LDF_PREV_ELEMENT_LINE + 23,13
          !byte LDF_X_POS + 10; 10
          !byte LDF_PREV_ELEMENT_AREA + 2,6,130
          !byte LDF_ELEMENT_LINE + 15,6,EL__STAR
          !byte LDF_ELEMENT_LINE + 17,6,EL__BRICK
          !byte LDF_X_POS + 1; 11
          !byte LDF_ELEMENT_LINE + 9,8,EL__DIAMOND
          !byte LDF_PREV_ELEMENT_LINE + 11,8
          !byte LDF_PREV_ELEMENT_LINE + 21,8
          !byte LDF_PREV_ELEMENT_LINE + 19,8
          !byte LDF_X_POS + 20; 31
          !byte LD_OBJECT | 6, 24
          !byte LDF_X_POS + 2; 33
          !byte LDF_ELEMENT_AREA + 2, 1,21,EL__COLUMN
          !byte LD_END



