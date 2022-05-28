NUM_OBJECT_SLOTS = 8

SPRITE_BASE = ( SPRITE_LOCATION ) / 64

SPRITE_PLAYER_IDLE_R    = SPRITE_BASE + 92 * 3
SPRITE_PLAYER_RUN_R_1   = SPRITE_BASE + 95 * 3
SPRITE_PLAYER_RUN_R_2   = SPRITE_BASE + 96 * 3
SPRITE_PLAYER_JUMP_R    = SPRITE_BASE + 100 * 3
SPRITE_PLAYER_FALL_R    = SPRITE_BASE + 101 * 3
SPRITE_PLAYER_DIE_R     = SPRITE_BASE + 114 * 3
SPRITE_PLAYER_IDLE_L    = SPRITE_BASE + 103 * 3
SPRITE_PLAYER_RUN_L_1   = SPRITE_BASE + 106 * 3
SPRITE_PLAYER_RUN_L_2   = SPRITE_BASE + 107 * 3
SPRITE_PLAYER_JUMP_L    = SPRITE_BASE + 111 * 3
SPRITE_PLAYER_FALL_L    = SPRITE_BASE + 112 * 3
SPRITE_GOOMBA_1         = SPRITE_BASE + 10 * 3
SPRITE_GOOMBA_FLAT      = SPRITE_BASE + 12 * 3
SPRITE_EXTRA            = SPRITE_BASE + 2 * 3
SPRITE_DIAMOND          = SPRITE_BASE + 16 * 3
SPRITE_ELEVATOR_1       = SPRITE_BASE + 27 * 3

SPRITE_EXTRA_TIME       = SPRITE_BASE + 13 * 3
SPRITE_EXTRA_LIVE       = SPRITE_BASE + 14 * 3

SPRITE_PLAYER_RUN_R_1_EX = SPRITE_BASE + 118 * 3 ;SPRITE_BASE + 17 * 4

SPRITE_CRAB_R           = SPRITE_BASE + 30 * 3
SPRITE_CRAB_L           = SPRITE_BASE + 32 * 3
SPRITE_CRAB_FLAT        = SPRITE_BASE + 34 * 3

SPRITE_EXTRA_FLASH      = SPRITE_BASE + 35 * 3

SPRITE_PLAYER_SHOT      = SPRITE_BASE + 37 * 3

SPRITE_BEE_1            = SPRITE_BASE + 38 * 3
SPRITE_BEE_FLAT         = SPRITE_BASE + 40 * 3

SPRITE_FISH_1           = SPRITE_BASE + 41 * 3

SPRITE_EYE_1            = SPRITE_BASE + 45 * 3
SPRITE_EYE_FLAT         = SPRITE_BASE + 47 * 3
SPRITE_EYE_1_R          = SPRITE_BASE + 90 * 3

SPRITE_DRAGON           = SPRITE_BASE + 57 * 3
SPRITE_ANT              = SPRITE_BASE + 48 * 3
SPRITE_PLATFORM         = SPRITE_BASE + 72 * 3

SPRITE_EXTRA_FLASH_DOUBLE   = SPRITE_BASE + 76 * 3

SPRITE_ANT_DEAD_1       = SPRITE_BASE + 77 * 3
SPRITE_DRAGON_DEAD_1    = SPRITE_BASE + 80 * 3

SPRITE_EXPLOSION        = SPRITE_BASE + 85 * 3

SPRITE_CLOWN            = SPRITE_BASE + 86 * 3

SPRITE_CRYSTAL          = SPRITE_BASE + 0 * 3

OBJECT_HEIGHT           = 8 * 2

TYPE_NONE         = 0
TYPE_PLAYER       = 1
TYPE_GOOMBA       = 2
TYPE_PLAYER_DYING = 3
TYPE_FLAT         = 4
TYPE_EXTRA        = 5
TYPE_DIAMOND      = 6
TYPE_ELEVATOR_UP  = 7
TYPE_CRAB         = 8
TYPE_PLAYER_SHOT  = 9
TYPE_DECO         = 10
TYPE_BEE          = 11
TYPE_FISH         = 12
TYPE_EYE          = 13
TYPE_DRAGON       = 14
TYPE_ANT          = 15
TYPE_PLATFORM     = 16
TYPE_DEADLY_DECO  = 17    ;boss parts
TYPE_EXPLOSION    = 18
TYPE_CLOWN        = 19
TYPE_CRYSTAL      = 20
TYPE_EXTRA_2      = 21    ;extra with other palette

EXTRA_POWERUP       = 0
EXTRA_SHOT          = 1
EXTRA_BOUNCING_SHOT = 2
EXTRA_AIMING_SHOT   = 3
EXTRA_CLOCK         = 4
EXTRA_MAGIC_BOMB    = 5
EXTRA_WATER_DROP    = 6
EXTRA_LOLLIPOP      = 7

;offset from calculated char pos to true sprite pos
SPRITE_CENTER_OFFSET_X  = 8
SPRITE_CENTER_OFFSET_Y  = 11

DIR_NONE              = $00
DIR_L                 = $01
DIR_R                 = $02
DIR_U                 = $04
DIR_D                 = $08
DIR_STOP              = $10
DIR_UP_FAST_SLOW_DOWN = $20
DIR_NEXT_WORLD         = $40

SF_DIR_R              = $01
SF_START_PRIO         = $02


OF_ON_GROUND          = $01
OF_ON_PLATFORM        = $02
OF_JUMPING            = $80
OF_NON_BLOCKING       = $40

JOY_UP                = $01
JOY_DOWN              = $02
JOY_LEFT              = $04
JOY_RIGHT             = $08
JOY_FIRE              = $10


!zone ClearAllObjects
ClearAllObjects
          ldx #0
          lda #0
-
          sta OBJECT_ACTIVE,x
          inx
          cpx #NUM_OBJECT_SLOTS
          bne -

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.SPRITE_X_EXTEND
          sta SHADOW_VIC_SPRITE_X_EXTEND

          rts



;PARAM1 = char pos x
;PARAM2 = char pos y
;PARAM3 = type
!zone SpawnObject
SpawnObject
          ldx #0
SpawnObjectStartingWithSlot
-
          lda OBJECT_ACTIVE,x
          beq .FreeSlot

          inx
          cpx #NUM_OBJECT_SLOTS
          bne -
          rts

SpawnObjectInSlot
.FreeSlot
          ;do we override the player shot?
          lda OBJECT_ACTIVE,x
          cmp #TYPE_PLAYER_SHOT
          bne +

          lda #0
          sta PLAYER_SHOT_ACTIVE

+

          lda PARAM3
          sta OBJECT_ACTIVE,x
          lda PARAM1
          sta OBJECT_CHAR_POS_X,x
          lda PARAM2
          sta OBJECT_CHAR_POS_Y,x

          txa
          sta OBJECT_MAIN_INDEX,x

          ;init values
          ldy PARAM3
          lda TYPE_START_SPRITE,y
          sta OBJECT_SPRITE,x
          lda TYPE_START_SPRITE_HI,y
          sta OBJECT_SPRITE_HI,x
          lda TYPE_START_HP,y
          sta OBJECT_HP,x
          lda #0
          sta OBJECT_ANIM_DELAY,x
          sta OBJECT_ANIM_POS,x
          sta OBJECT_FLAGS,x
          sta OBJECT_FALL_SPEED,x
          sta OBJECT_FALL_SPEED_DELAY,x
          sta OBJECT_POS_X_DELTA,x
          sta OBJECT_POS_Y_DELTA,x
          sta OBJECT_JUMP_POS,x
          sta OBJECT_MOVE_SPEED_X,x
          sta OBJECT_MOVE_SPEED_Y,x
          sta OBJECT_STATE,x
          sta OBJECT_STATE_POS,x
          sta OBJECT_DIR,x
          sta OBJECT_DIR_Y,x
          sta OBJECT_POS_X_EX,x
          sta OBJECT_VALUE,x

          lda BIT_TABLE,x
          trb VIC.SPRITE_PRIORITY

          txa
          asl
          tay
          lda OBJECT_SPRITE,x
          sta SPRITE_POINTER_BASE,y
          lda OBJECT_SPRITE_HI,x
          sta SPRITE_POINTER_BASE + 1,y

          jsr CalcSpritePosFromCharPos

          ldy OBJECT_ACTIVE,x
          lda TYPE_SPAWN_DELTA_X,y
          clc
          adc #4
          clc
          adc OBJECT_POS_X,x
          sta OBJECT_POS_X,x
          bcc +
          inc OBJECT_POS_X_EX,x
+

          lda TYPE_SPAWN_DELTA_Y,y
          clc
          adc OBJECT_POS_Y,x
          sta OBJECT_POS_Y,x

          lda TYPE_SPRITE_WIDTH,y
          sta OBJECT_WIDTH_CHARS,x

          lda TYPE_START_SPRITE_FLAGS,y
          bit #SF_DIR_R
          beq +

          lda #1
          sta OBJECT_DIR,x

+
          ;sprite prio
          ;lda TYPE_START_SPRITE_FLAGS,y
;          and #SF_START_PRIO
;          beq +
;
;          lda BIT_TABLE,x
;          tsb VIC.SPRITE_PRIORITY
;
;+


          ;lda TYPE_START_SPRITE_FLAGS,y
          ;and #SF_EXTENDED_COLORS
          ;beq +

          lda BIT_TABLE,x
          tsb VIC4.SPR16EN
          tsb VIC4.SPRX64EN

          ;force 0 to be transparent
          lda #0
          sta VIC.SPRITE_COLOR,x

          ldy PARAM3

          ;source palette slot, type * 16
          lda TYPE_SPRITE_PALETTE,y
          ;*16
          asl
          asl
          asl
          asl
          tay

          phx

          ;target slot = sprite no * 16
          txa
          asl
          asl
          asl
          asl
          tax

          ;copy sprite palette
          lda #$cc
          trb VIC4.PALSEL
          lda #$88
          tsb VIC4.PALSEL

          ldz #0

-
          lda PALETTE_DATA_SPRITES, y
          sta VIC4.PALRED,x
          lda PALETTE_DATA_SPRITES + 1 * 16 * NUM_SPRITE_PALETTES, y
          sta VIC4.PALGREEN,x
          lda PALETTE_DATA_SPRITES + 2 * 16 * NUM_SPRITE_PALETTES, y
          sta VIC4.PALBLUE,x

          inx
          iny
          inz
          cpz #16
          bne -

          plx

          rts



;------------------------------------------------------------
;CalcSpritePosFromCharPos
;calculates the real sprite coordinates from screen char pos
;and sets them directly
;X      = object index
;Y      = sprite index
;------------------------------------------------------------
!zone CalcSpritePosFromCharPos
CalcSpritePosFromCharPos
          ;offset screen to border 24,50
          lda BIT_TABLE,x
          trb SHADOW_VIC_SPRITE_X_EXTEND

          ;need extended x bit?
          lda OBJECT_CHAR_POS_X,x
          ;sec
          ;sbc AKTUELLE_SPALTE
          sta PARAM1
          cmp #30
          bcc .NoXBit

          lda BIT_TABLE,x
          tsb SHADOW_VIC_SPRITE_X_EXTEND

          lda #1
          sta OBJECT_POS_X_EX,x

.NoXBit
          ;calculate sprite positions (offset from border)
          lda PARAM1
          asl
          asl
          asl
          clc
          adc #( 24 - SPRITE_CENTER_OFFSET_X )
          sta OBJECT_POS_X,x
          ;sta VIC_SPRITE_X_POS,y

          lda OBJECT_CHAR_POS_Y,x
          ;sec
          ;sbc AKTUELLE_ZEILE_OBEN
          asl
          asl
          asl
          clc
          ;adc #8 * ( 1 + LINE_OFFSET_TOP )  ;3 rows offset from panel
          ;adc #( 50 - SPRITE_CENTER_OFFSET_Y )
          ;adc #( 37 - SPRITE_CENTER_OFFSET_Y )
          adc #( 50 - SPRITE_CENTER_OFFSET_Y )
          sec
          sbc #2
          sta OBJECT_POS_Y,x
          ;sta VIC_SPRITE_Y_POS,y

          rts


!zone ObjectControl
ObjectControl
          ldx #0
          stx CURRENT_INDEX

.Loop
          ldy OBJECT_ACTIVE,x
          beq .NextObject

          lda TYPE_BEHAVIOUR_LO,y
          sta .JUMP_POS
          lda TYPE_BEHAVIOUR_HI,y
          sta .JUMP_POS + 1

.JUMP_POS = * + 1
          jsr $8000

.NextObject
          inc CURRENT_INDEX
          ldx CURRENT_INDEX
          cpx #NUM_OBJECT_SLOTS
          bne .Loop

          jsr CheckCollisionsForPlayer
          rts



!zone MoveInDirection
MoveInDirection
          lda OBJECT_DIR,x
          cmp #DIR_R
          beq .MoveRight
          cmp #DIR_L
          beq .MoveLeft
          cmp #DIR_U
          beq .MoveUp
          cmp #DIR_D
          beq .MoveDown
          rts

.MoveRight
          jmp ObjectMoveRight

.MoveLeft
          jmp ObjectMoveLeft

.MoveUp
          jmp ObjectMoveUp

.MoveDown
          jmp ObjectMoveDown



!zone BHDyingObject
BHDyingObject
          lda OBJECT_STATE,x
          bne +
          jsr HandleObjectJump

          lda OBJECT_JUMP_POS,x
          bne ++
          ;start falling
          inc OBJECT_STATE,x
          lda #1
          sta OBJECT_FALL_SPEED,x
          lda #0
          sta OBJECT_FALL_SPEED_DELAY,x
+
          inc OBJECT_FALL_SPEED_DELAY,x
          lda OBJECT_FALL_SPEED_DELAY,x
          and #$03
          bne .Fall
          inc OBJECT_FALL_SPEED,x
.Fall
          lda OBJECT_FALL_SPEED,x
          sta PARAM5

-
          beq .FallDone
          jsr ObjectMoveDown
          dec PARAM5
          jmp -


.FallDone
          lda OBJECT_CHAR_POS_Y,x
          cmp #26
          bcc .NotDoneYet

          jmp RemoveObject

.NotDoneYet
++
          rts



!zone BHPlayer
PlayerKilled
          lda #<SPRITE_PLAYER_DIE_R
          sta OBJECT_SPRITE
          lda #0
          sta OBJECT_ANIM_DELAY
          sta OBJECT_ANIM_POS
          lda #10
          sta OBJECT_JUMP_POS

          lda #1
          sta PLAYER_IS_DEAD

          lda #TYPE_PLAYER_DYING
          sta OBJECT_ACTIVE

          ldy #SFX_PLAYER_DIE
          jsr PlaySoundEffect
          ldx CURRENT_INDEX
          rts


BHPlayer
          lda PLAYER_ON_ELEVATOR
          beq .NotOnElevator

          rts

.NotOnElevator
          lda #JOY_FIRE
          bit JOY_VALUE
          bne .NotFire

          lda PLAYER_POWERED_UP
          cmp #EXTRA_SHOT + 1
          bcc .NotFire

          lda PLAYER_SHOT_ACTIVE
          bne .NotFire

          lda OBJECT_CHAR_POS_X
          sta PARAM1
          lda OBJECT_CHAR_POS_Y
          dec
          sta PARAM2
          lda #TYPE_PLAYER_SHOT
          sta PARAM3
          jsr SpawnObject
          cpx #NUM_OBJECT_SLOTS
          beq .NoShotSpawned

          lda OBJECT_DIR
          sta OBJECT_DIR,x

          lda #1
          sta PLAYER_SHOT_ACTIVE

.NoShotSpawned
          ldx CURRENT_INDEX

.NotFire
          lda #JOY_RIGHT
          bit JOY_VALUE
          bne .NotRight

          lda #0
          sta OBJECT_DIR,x
          lda OBJECT_MOVE_SPEED_X,x
          cmp #3
          beq .NotRight

          inc OBJECT_MOVE_SPEED_X,x
.NotRight

          lda #JOY_LEFT
          bit JOY_VALUE
          bne .NotLeft

          lda #1
          sta OBJECT_DIR,x

          lda OBJECT_MOVE_SPEED_X,x
          cmp #256 - 3
          beq .NotLeft

          dec OBJECT_MOVE_SPEED_X,x

.NotLeft

          lda OBJECT_MOVE_SPEED_X,x
          sta .MOVE_DELTA
          beq .NoXMovement

          lda #JOY_LEFT | JOY_RIGHT
          and JOY_VALUE
          cmp #JOY_LEFT | JOY_RIGHT
          bne .NoSlowdown

          inc OBJECT_MOVE_SPEED_Y,x
          lda OBJECT_MOVE_SPEED_Y,x
          cmp #2
          bne .NoSlowdown

          lda #0
          sta OBJECT_MOVE_SPEED_Y,x

          ;slow down
          lda OBJECT_MOVE_SPEED_X,x
          bpl +

          inc OBJECT_MOVE_SPEED_X,x
          jmp .NoSlowdown

+
          dec OBJECT_MOVE_SPEED_X,x


.NoSlowdown
          lda OBJECT_MOVE_SPEED_X,x
          beq .NoXMovement
          bmi .GoLeft

.GoRight
          jsr ObjectMoveRightBlocking

          ;walk off platform?
          lda OBJECT_FLAGS
          bit #OF_ON_PLATFORM
          beq .NotOnPlatform

          ldx PLAYER_PLATFORM
          jsr IsPlayerStandingOnPlatform
          bcs .StillOnPlatform

          ;walked off
          lda #OF_ON_PLATFORM
          trb OBJECT_FLAGS
          lda #0
          sta PLAYER_PLATFORM

.StillOnPlatform
          ldx #0
.NotOnPlatform
          dec .MOVE_DELTA
          bne .GoRight
          bra .XMovementDone

.GoLeft
          lda OBJECT_CHAR_POS_X,x
          beq .LeftBorder


          jsr ObjectMoveLeftBlocking

          ;walk off platform?
          lda OBJECT_FLAGS
          bit #OF_ON_PLATFORM
          beq .NotOnPlatform2

          ldx PLAYER_PLATFORM
          jsr IsPlayerStandingOnPlatform
          bcs .StillOnPlatform2

          ;walked off
          lda #OF_ON_PLATFORM
          trb OBJECT_FLAGS

.StillOnPlatform2
          ldx #0
.NotOnPlatform2

          inc .MOVE_DELTA
          bne .GoLeft

.LeftBorder
.XMovementDone
.NoXMovement
          lda OBJECT_FLAGS,x
          and #OF_JUMPING
          bne .JumpAnim

          lda OBJECT_FLAGS,x
          and #OF_ON_GROUND
          beq .FallAnim

          lda OBJECT_MOVE_SPEED_X,x
          beq .IdleAnim

          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          bne +

          ldy OBJECT_DIR,x
          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          sta OBJECT_ANIM_POS,x

          jsr MultiplyBy3

          clc
          adc PLAYER_SPRITES,y
          sta OBJECT_SPRITE,x

+
          jmp .AnimDone


.IdleAnim
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$07
          bne +

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          sta OBJECT_ANIM_POS,x
          tay
          lda PING_PONG_TABLE,y

          jsr MultiplyBy3
          clc
          ldy OBJECT_DIR,x
          adc PLAYER_SPRITES_IDLE,y
          sta OBJECT_SPRITE,x
+
          jmp .AnimDone



.MOVE_DELTA
          !byte 0

PLAYER_SPRITES_IDLE
          !byte <SPRITE_PLAYER_IDLE_R
          !byte <SPRITE_PLAYER_IDLE_L

PLAYER_SPRITES
          !byte <SPRITE_PLAYER_RUN_R_1
          !byte <SPRITE_PLAYER_RUN_L_1

PLAYER_SPRITES_JUMP
          !byte <SPRITE_PLAYER_JUMP_R
          !byte <SPRITE_PLAYER_JUMP_L

PLAYER_SPRITES_FALL
          !byte <SPRITE_PLAYER_FALL_R
          !byte <SPRITE_PLAYER_FALL_L

.JumpAnim
          ldy OBJECT_DIR,x
          lda PLAYER_SPRITES_JUMP,y
          sta OBJECT_SPRITE,x
          jmp .AnimDone

.FallAnim
          ldy OBJECT_DIR,x
          lda PLAYER_SPRITES_FALL,y
          sta OBJECT_SPRITE,x
          jmp .AnimDone

.AnimDone
          lda OBJECT_FLAGS,x
          and #( OF_JUMPING | OF_ON_GROUND )
          cmp #OF_ON_GROUND
          bne +

          ;can jump
          lda #JOY_UP
          bit JOY_VALUE
          bne +

          ;fire pressed
          lda #0
          sta OBJECT_JUMP_POS,x
          sta PLAYER_PLATFORM

          lda OBJECT_FLAGS,x
          ora #OF_JUMPING
          and #~( OF_ON_GROUND | OF_ON_PLATFORM )
          sta OBJECT_FLAGS,x

          ldy #SFX_JUMP
          jsr PlaySoundEffect

          ldx CURRENT_INDEX


+

          ;still has jump flags set?
          lda OBJECT_FLAGS,x
          and #OF_JUMPING
          beq .NotJumping

          lda JUMP_STEPS_LEFT
          beq +

          dec JUMP_STEPS_LEFT
          jmp .ForcedJump

+
          ;smaller jump curve only every 8 steps
          lda OBJECT_JUMP_POS,x
          and #$07
          bne +

          ;fire still pressed?
          lda #JOY_UP
          and JOY_VALUE
          bne .FireReleased
+
.ForcedJump
          jmp HandleObjectJump

.FireReleased
          lda OBJECT_FLAGS,x
          and #~OF_JUMPING
          sta OBJECT_FLAGS,x
          rts


.NotJumping
          lda OBJECT_FLAGS,x
          and #OF_ON_PLATFORM
          bne .OnPlatform

          lda OBJECT_FLAGS,x
          and #OF_ON_GROUND
          sta PARAM1

          jsr HandleObjectFall

          lda OBJECT_FLAGS,x
          and #OF_ON_GROUND
          beq .IsNotOnGround
          cmp PARAM1
          beq .GroundStateDidNotChange

          ;use stand sprite
          ldy OBJECT_DIR,x
          lda #$01
          eor OBJECT_ANIM_POS,x
          sta OBJECT_ANIM_POS,x

          jsr MultiplyBy3
          clc
          adc PLAYER_SPRITES,y
          sta OBJECT_SPRITE,x

.IsNotOnGround
.GroundStateDidNotChange
.OnPlatform

          ;fell too far?
          lda OBJECT_CHAR_POS_Y,x
          bmi .CameInFromBottom

          lda OBJECT_POS_Y,x
          cmp #207
          bcc +
          ;jmp PlayerKilled
+
.CameInFromBottom
          rts



!zone BHNone
BHNone
          rts



!zone BHPlayerShot
BHPlayerShot
          jsr .HandleShot

.HandleShot

          ldy CURRENT_INDEX
          jsr CheckCollisions

          ;was the shot destroyed?
          ldx CURRENT_INDEX
          lda OBJECT_ACTIVE,x
          cmp #TYPE_PLAYER_SHOT
          beq +

          rts

+

          lda #3
          sta PARAM2

--
          lda OBJECT_DIR,x
          beq .GoLeft

          jsr ObjectMoveLeftBlocking
          beq .BlockedX

          jmp .Moved

.BlockedX
          lda OBJECT_DIR,x
          eor #$01
          sta OBJECT_DIR,x

          lda PLAYER_POWERED_UP
          cmp #2
          beq .RemoveShot
          bcc .RemoveShot

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          cmp #20
          bne .Moved

          ;bounced 20 times, auto-destruct
          jmp .RemoveShot

.GoLeft
          jsr ObjectMoveRightBlocking
          beq .BlockedX
.Moved
          dec PARAM2
          bne --

          lda OBJECT_DIR_Y,x
          bne .GoDown

          jsr ObjectMoveDownBlocking
          beq .Blocked
          jmp .MovedY

.GoDown
          jsr ObjectMoveUpBlocking
          beq .Blocked
          jmp .MovedY

.Blocked
          lda OBJECT_DIR_Y,x
          eor #$01
          sta OBJECT_DIR_Y,x

.MovedY
          lda OBJECT_CHAR_POS_X,x
          beq .RemoveShot
          cmp #38
          beq .RemoveShot

          lda OBJECT_CHAR_POS_Y,x
          bmi .RemoveShot
          cmp #25
          beq .RemoveShot

          rts

.RemoveShot
          lda #0
          sta PLAYER_SHOT_ACTIVE

          jmp ExplodeObject



!zone BHFlat
BHFlat
          jmp HandleObjectFall



!zone BHGoomba
BHGoomba
          jsr HandleObjectFall

          lda OBJECT_DIR,x
          beq .GoLeft

          jsr ObjectMoveRightBlocking
          beq .Blocked
          jmp .Update

.GoLeft
          jsr ObjectMoveLeftBlocking
          bne .Update

.Blocked
          lda OBJECT_DIR,x
          eor #$01
          sta OBJECT_DIR,x

.Update
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$04
          beq +

          lda #3
+
          clc
          adc #<SPRITE_GOOMBA_1
          sta OBJECT_SPRITE,x
          rts



!zone BHBee
BHBee
          lda OBJECT_DIR,x
          beq .GoLeft

          jsr ObjectMoveRight
          jsr ObjectMoveRight
          jmp .Update

.GoLeft
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft

.Update
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$04
          beq +
          lda #3
+
          clc
          adc #<SPRITE_BEE_1
          sta OBJECT_SPRITE,x
          rts



!zone BHFish
BHFish
          ldy OBJECT_DIR_Y,x
          lda FISH_DELTA,y
          beq .UpdateTablePointer
          sta PARAM2
          bpl .GoUp

          lda #$00
          sec
          sbc PARAM2
          lsr
          beq .UpdateTablePointer
          sta PARAM2

          lda #<( SPRITE_FISH_1 + 3 * 3 )
          sta OBJECT_SPRITE,x


-
          jsr ObjectMoveDown

          dec PARAM2
          bne -

.UpdateTablePointer
          ;only update every 2nd time
          inc OBJECT_DIR,x
          lda OBJECT_DIR,x
          and #$01
          beq +

          inc OBJECT_DIR_Y,x
          lda OBJECT_DIR_Y,x
          cmp #36
          bne +

          lda #0
          sta OBJECT_DIR_Y,x

+

          rts


.GoUp
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          bne +

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          tay
          lda PING_PONG_TABLE,y
          jsr MultiplyBy3
          clc
          adc #<SPRITE_FISH_1
          sta OBJECT_SPRITE,x


+

          lsr PARAM2
          beq .UpdateTablePointer

-
          jsr ObjectMoveUp

          dec PARAM2
          bne -

          bra .UpdateTablePointer

FISH_DELTA
          !byte $0a,$0a,$0a,$09,$09,$09,$08,$08,$07,$07,$06,$05,$04,$04,$03,$02,$01,$00,$00,$ff,$fe,$fd,$fc,$fc,$fb,$fa,$f9,$f9,$f8,$f8,$f7,$f7,$f7,$f6,$f6,$f6

PING_PONG_TABLE
          !byte 0,1,2,1



!zone BHClown
BHClown
          ldy OBJECT_DIR_Y,x
          lda FISH_DELTA,y
          beq .UpdateTablePointer
          sta PARAM2
          bpl .GoUp

          lda #$00
          sec
          sbc PARAM2
          lsr
          beq .UpdateTablePointer
          sta PARAM2

          lda #<( SPRITE_CLOWN + 3 * 3 )
          sta OBJECT_SPRITE,x


-
          jsr ObjectMoveDown

          dec PARAM2
          bne -

.UpdateTablePointer
          inc OBJECT_DIR_Y,x
          lda OBJECT_DIR_Y,x
          cmp #36
          bne +

          lda #0
          sta OBJECT_DIR_Y,x

+
          rts


.GoUp
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          bne +

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          tay
          lda PING_PONG_TABLE,y
          jsr MultiplyBy3
          clc
          adc #<SPRITE_CLOWN
          sta OBJECT_SPRITE,x


+

          lsr PARAM2
          beq .UpdateTablePointer

-
          jsr ObjectMoveUp

          dec PARAM2
          bne -

          bra .UpdateTablePointer


!zone BHCrab
BHCrab
          jsr HandleObjectFall

          lda OBJECT_DIR,x
          beq .GoLeft

          jsr ObjectMoveRightBlocking
          beq .Blocked
          jmp .Update

.GoLeft
          jsr ObjectMoveLeftBlocking
          bne .Update

.Blocked
          lda OBJECT_DIR,x
          eor #$01
          sta OBJECT_DIR,x

.Update
          ldy OBJECT_DIR,x
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$04
          beq +
          lda #3
+
          clc
          adc CRAB_SPRITE,y
          sta OBJECT_SPRITE,x
          rts

CRAB_SPRITE
          !byte <SPRITE_CRAB_L, <SPRITE_CRAB_R



!zone BHExplosion
BHExplosion
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          cmp #4
          bne +
          and #$04

          jmp RemoveObject
+
          rts



!zone BHEye
BHEye
          jsr HandleObjectFall

          lda OBJECT_DIR,x
          beq .GoLeft

          jsr ObjectMoveRightBlocking
          beq .Blocked
          jmp .Update

.GoLeft
          jsr ObjectMoveLeftBlocking
          bne .Update

.Blocked
          lda OBJECT_DIR,x
          eor #$01
          sta OBJECT_DIR,x

.Update
          ldy OBJECT_DIR,x
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$04
          beq +
          lda #3
+
          clc
          adc EYE_SPRITE,y
          sta OBJECT_SPRITE,x
          lda EYE_SPRITE_HI,y
          sta OBJECT_SPRITE_HI,x
          rts

EYE_SPRITE
          !byte <SPRITE_EYE_1, <SPRITE_EYE_1_R
EYE_SPRITE_HI
          !byte >SPRITE_EYE_1, >SPRITE_EYE_1_R



!zone BHDragon
BHDragon
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          lbne .WaitDone

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          tay
          lda PING_PONG_TABLE,y
          ;* 5
          sta PARAM1
          asl
          asl
          clc
          adc PARAM1
          ;* 3 for sprite offset
          jsr MultiplyBy3
          sta PARAM1
          clc
          adc #<SPRITE_DRAGON
          sta OBJECT_SPRITE,x

          lda #>SPRITE_DRAGON
          adc #0
          sta OBJECT_SPRITE_HI,x
-
          lda OBJECT_SPRITE,x
          clc
          adc #3
          sta OBJECT_SPRITE + 1,x
          lda OBJECT_SPRITE_HI,x
          adc #0
          sta OBJECT_SPRITE_HI + 1,x

          inx
          cpx #5
          bne -

          ldx CURRENT_INDEX

          jsr DragonMove

DragonMove
          lda OBJECT_STATE_POS,x
          bne .HandleStep

          ;find next action
          ;000x xxxx = pause
          ;001x xxxx = left
          ;010x xxxx = right
          ;011x xxxx = end
          ;1xxx xxxx = double speed
          ldy OBJECT_STATE,x
          lda DRAGON_MOVE_TABLE,y
          and #$e0
          cmp #$60
          bne +

          ;end marker, restart sequence
          lda #0
          sta OBJECT_STATE,x
          tay
          lda DRAGON_MOVE_TABLE,y
+
          and #$e0
          sta OBJECT_MOVE_SPEED_X,x
          lda DRAGON_MOVE_TABLE,y
          and #$1f
          sta OBJECT_STATE_POS,x

          inc OBJECT_STATE,x

.HandleStep
          dec OBJECT_STATE_POS,x

          lda OBJECT_MOVE_SPEED_X,x
          lbeq .WaitDone
          cmp #$a0
          beq .Down
          cmp #$80
          beq .Up
          cmp #$20
          bne +

          jsr ObjectMoveLeft
          inx
          jsr ObjectMoveLeft
          inx
          jsr ObjectMoveLeft
          inx
          jsr ObjectMoveLeft
          inx
          jsr ObjectMoveLeft
          dex
          dex
          dex
          dex
          rts

+
          ;right option is left
          jsr ObjectMoveRight
          inx
          jsr ObjectMoveRight
          inx
          jsr ObjectMoveRight
          inx
          jsr ObjectMoveRight
          inx
          jsr ObjectMoveRight
          dex
          dex
          dex
          dex


.WaitDone
          rts

.Up
          jsr ObjectMoveUp
          inx
          jsr ObjectMoveUp
          inx
          jsr ObjectMoveUp
          inx
          jsr ObjectMoveUp
          inx
          jsr ObjectMoveUp
          dex
          dex
          dex
          dex
          rts

.Down
          jsr ObjectMoveDown
          inx
          jsr ObjectMoveDown
          inx
          jsr ObjectMoveDown
          inx
          jsr ObjectMoveDown
          inx
          jsr ObjectMoveDown
          dex
          dex
          dex
          dex
          rts

;000x xxxx = pause
;001x xxxx = left
;010x xxxx = right
;011x xxxx = end
;100x xxxx = up
;101x xxxx = down
DRAGON_MOVE_TABLE
          ;!byte $80 | $1f   ;up
          ;!byte $1f
          ;!byte $a0 | $1f   ;down

          !byte $1f   ;!byte 0,40
          !byte $20 | $1f   ;!byte 1,40
          !byte $0f   ; !byte 0,20
          !byte $40 | $1f   ; !byte 2,40

          !byte $2f   ;  1,20
          !byte $03   ; 0,20
          !byte $4f   ; 2,20
          !byte $0f   ; 0,20
          !byte $20 | $1f
          !byte $20 | $1f
          !byte $40 | $1f
          !byte $40 | $1f
          !byte $80 | $1f   ;up
          !byte $1f
          !byte $a0 | $1f   ;down
          !byte $60


!zone BHPlatform
BHPlatform
          inc OBJECT_DIR,x
          lda OBJECT_DIR,x
          cmp #100
          bne +

          ;toggle dir
          lda OBJECT_DIR_Y,x
          eor #1
          sta OBJECT_DIR_Y,x
          lda #0
          sta OBJECT_DIR,x

+

          ;safety check, check if player is standing on us before moving
          jsr .IsPlayerStandingOnUs
          ldx CURRENT_INDEX
          lda OBJECT_DIR_Y,x
          bne .GoDown

          jsr ObjectMoveUp
          cpx PLAYER_PLATFORM
          bne .NotPlayer

          ldx #0
          jsr ObjectMoveUp
          jmp .PlatformMoved

.GoDown
          jsr ObjectMoveDown
          cpx PLAYER_PLATFORM
          bne .NotPlayer

          ldx #0
          jsr ObjectMoveDown
.PlatformMoved
          ldx PLAYER_PLATFORM

.NotPlayer

          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          bne +

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          jsr MultiplyBy3
          clc
          adc #<SPRITE_PLATFORM
          sta OBJECT_SPRITE,x

+

.IsPlayerStandingOnUs
          ;player standing on us?
          jsr IsPlayerStandingOnPlatform
          bcc .NotOnPlatform

          ;mark player as standing on platform
          lda #OF_ON_GROUND | OF_ON_PLATFORM
          tsb OBJECT_FLAGS
          stx PLAYER_PLATFORM

.NotOnPlatform
          rts



!zone IsPlayerStandingOnAnyPlatform
;if standing on platform returns X of platform, and carry set
IsPlayerStandingOnAnyPlatform
          ldx #1
-
          lda OBJECT_ACTIVE,x
          cmp #TYPE_PLATFORM
          bne +

          jsr IsPlayerStandingOnPlatform
          bcc +

          ;yes!
          rts


+
          inx
          cpx #NUM_OBJECT_SLOTS
          bne -

          clc
          rts



!zone IsPlayerStandingOnPlatform
;X = index of platform, player expected in index 0
;carry set if on this platform
IsPlayerStandingOnPlatform
          lda OBJECT_ACTIVE
          cmp #TYPE_PLAYER
          bne .NoPlayer

          ;don't set on platform if we're jumping
          lda OBJECT_FLAGS
          and #OF_JUMPING
          bne .PlayerNotOnBoard

          lda OBJECT_POS_Y
          clc
          adc #21
          cmp OBJECT_POS_Y,x
          bne .PlayerNotOnBoard

          lda OBJECT_POS_X
          sta PARAM1
          lda OBJECT_POS_X_EX
          sta PARAM2

          lda OBJECT_POS_X,x
          sta PARAM3
          lda OBJECT_POS_X_EX,x
          sta PARAM4

          ;add #12
          lda PARAM1
          clc
          adc #12
          sta PARAM1
          bcc +
          inc PARAM2
+

          ;x pos inside?
          ;X player >= platform
          sec
          lda PARAM1
          sbc PARAM3

          lda PARAM2
          sbc PARAM4
          bmi .Outside

          ;X player < platform end
          lda PARAM3
          clc
          adc #22 ;32
          sec
          sbc PARAM1

          lda PARAM4
          sbc PARAM2
          bmi .Outside

          sec
          rts

.PlayerNotOnBoard
.Outside
.NoPlayer
          clc
          rts



!zone BHAnt
BHAnt
          lda OBJECT_STATE_POS,x
          bne .HandleStep

          ;find next action
          ;000x xxxx = pause
          ;001x xxxx = left
          ;010x xxxx = right
          ;011x xxxx = end
          ;1xxx xxxx = double speed
          ldy OBJECT_STATE,x
          lda ANT_MOVE_TABLE,y
          and #$60
          cmp #$60
          bne +

          ;end marker, restart sequence
          lda #0
          sta OBJECT_STATE,x
          tay
          lda ANT_MOVE_TABLE,y
+
          and #$e0
          sta OBJECT_MOVE_SPEED_X,x
          lda ANT_MOVE_TABLE,y
          and #$1f
          sta OBJECT_STATE_POS,x

          inc OBJECT_STATE,x

.HandleStep
          dec OBJECT_STATE_POS,x

          ;0 = wait, 1 = left, 2 = right, 3 = restart
          lda OBJECT_MOVE_SPEED_X,x
          beq .WaitDone
          cmp #$20
          bne +

          jsr ObjectMoveLeft
          inx
          jsr ObjectMoveLeft
          inx
          jsr ObjectMoveLeft
          dex
          dex
          bra .AnimateAnt

+
          ;right option is left
          jsr ObjectMoveRight
          inx
          jsr ObjectMoveRight
          inx
          jsr ObjectMoveRight
          dex
          dex

.AnimateAnt
          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          bne .WaitDone

          inc OBJECT_ANIM_POS,x
          lda OBJECT_ANIM_POS,x
          and #$03
          tay
          lda PING_PONG_TABLE,y
          ;* 3
          sta PARAM1
          asl
          clc
          adc PARAM1
          ;* 3 for sprite offset
          jsr MultiplyBy3
          clc
          adc #<SPRITE_ANT
          sta OBJECT_SPRITE,x
          clc
          adc #3
          sta OBJECT_SPRITE + 1,x
          clc
          adc #3
          sta OBJECT_SPRITE + 2,x

.WaitDone
          rts

;000x xxxx = pause
;001x xxxx = left
;010x xxxx = right
;011x xxxx = end
;1xxx xxxx = double speed
ANT_MOVE_TABLE
          !byte $1f   ;!byte 0,40
          !byte $20 | $1f   ;!byte 1,40
          !byte $0f   ; !byte 0,20
          !byte $40 | $1f   ; !byte 2,40

          !byte $2f   ;  1,20
          !byte $03   ; 0,20
          !byte $4f   ; 2,20
          !byte $0f   ; 0,20
          !byte $80 | $20 | $1f
          !byte $80 | $20 | $1f
          !byte $40 | $1f
          !byte $40 | $1f
          !byte $60



!zone BHExtra
BHExtra
          lda OBJECT_FLAGS,x
          and #OF_JUMPING
          beq .NotJumping

          jmp HandleObjectJump

.NotJumping
          jsr HandleObjectFall

          lda OBJECT_DIR,x
          beq .GoLeft

          jsr ObjectMoveRightBlocking
          beq .Blocked
          jmp .Update

.GoLeft
          jsr ObjectMoveLeftBlocking
          bne .Update

.Blocked
          lda OBJECT_DIR,x
          eor #$01
          sta OBJECT_DIR,x

.Update
          lda OBJECT_VALUE,x
          cmp #EXTRA_POWERUP
          bne .NoAnim

          lda OBJECT_DIR,x
          bne .Inc

          lda OBJECT_ANIM_DELAY,x
          bne +

          lda #8 * 4
          sta OBJECT_ANIM_DELAY,x

+
          dec OBJECT_ANIM_DELAY,x
          jmp +





.Inc
          inc OBJECT_ANIM_DELAY,x
+
          lda OBJECT_ANIM_DELAY,x
          lsr
          lsr
          cmp #$8
          bne +

          lda #0
          sta OBJECT_ANIM_DELAY,x
+
          jsr MultiplyBy3
          clc
          adc #<SPRITE_EXTRA
          sta OBJECT_SPRITE,x
.NoAnim
          rts



!zone BHDiamond
BHDiamond
          lda OBJECT_FLAGS,x
          and #OF_JUMPING
          beq .NotJumping

          lda OBJECT_CHAR_POS_Y,x
          bmi .OutsideTop

          jmp HandleObjectJump

.NotJumping
.OutsideTop
          jmp RemoveObject



!zone BHElevator
;state = 0 - waiting for player
;        1 - player on board, moving (up or down)
BHElevator
          lda OBJECT_STATE,x
          beq .WaitingForPlayer

          lda OBJECT_DIR,x
          beq .MoveUp

          jsr ObjectMoveDown
          jsr ObjectMoveDown

          lda OBJECT_POS_Y,x
          sta OBJECT_POS_Y + 1,x
          sta OBJECT_POS_Y + 2,x
          sta OBJECT_POS_Y + 3,x

          ldx #0
          jsr ObjectMoveDown
          jsr ObjectMoveDown
          ldx CURRENT_INDEX
          rts

.MoveUp
          jsr ObjectMoveUp
          jsr ObjectMoveUp

          lda OBJECT_POS_Y,x
          sta OBJECT_POS_Y + 1,x
          sta OBJECT_POS_Y + 2,x
          sta OBJECT_POS_Y + 3,x

          ldx #0
          jsr ObjectMoveUp
          jsr ObjectMoveUp
          ldx CURRENT_INDEX

          lda OBJECT_POS_Y,x
          cmp #20
          bcc .OutsideTop

          rts

.OutsideTop
          lda SECRET_SCREEN_ACTIVE
          beq .StageCompleted

          lda #1
          sta SECRET_STAGE_LEFT

          ldx #7
          stx CURRENT_INDEX
          rts

.StageCompleted
          lda #1
          sta REACHED_EXIT
          rts

.WaitingForPlayer
          lda OBJECT_ACTIVE
          cmp #TYPE_PLAYER
          bne .NoPlayer

          lda OBJECT_POS_Y
          clc
          adc #21
          cmp OBJECT_POS_Y,x

          bne .PlayerNotOnBoard

          lda OBJECT_CHAR_POS_X,x
          cmp OBJECT_CHAR_POS_X
          bcs .OutLeft

          clc
          adc #2
          cmp OBJECT_CHAR_POS_X
          bcc .OutRight

          ;player on board, start moving
          lda #1
          sta OBJECT_STATE,x
          sta PLAYER_ON_ELEVATOR

          ;set stand anim
          ldy OBJECT_DIR
          lda OBJECT_ANIM_POS,x
          asl
          asl
          clc
          adc PLAYER_SPRITES,y
          sta OBJECT_SPRITE

.OutRight
.OutLeft
.PlayerNotOnBoard
.NoPlayer
          rts





!zone IsEnemyCollidingWithObject

;x = enemy index
.CalculateSimpleXPos
          ;Returns a with simple x pos (x halved + 128 if > 256)
          ;modifies y
          lda BIT_TABLE,x
          and SHADOW_VIC_SPRITE_X_EXTEND
          beq .NoXBit

          lda OBJECT_POS_X,x
          lsr
          clc
          adc #128
          rts

.NoXBit
          lda OBJECT_POS_X,x
          lsr
          rts

;------------------------------------------------------------
;check object collision with other object (checked object in y, other object in x)
;x = enemy index
;y = player index
;return a = 1 when colliding, a = 0 when not
;------------------------------------------------------------
IsEnemyCollidingWithObject
          ;modifies X
          ;check y pos
          lda OBJECT_POS_Y,x
          sec
          sbc #( OBJECT_HEIGHT )      ;offset to bottom
          cmp OBJECT_POS_Y,y
          bcs .NotTouching
          clc
          adc #( OBJECT_HEIGHT + OBJECT_HEIGHT - 1 )
          cmp OBJECT_POS_Y,y
          bcc .NotTouching

          ;X = Index in enemy-table
          jsr .CalculateSimpleXPos
          sta PARAM1
          ;vs. player X
          tya
          tax
          jsr .CalculateSimpleXPos

          sec
          sbc #4
          ;position X-Anfang Player - 12 Pixel
          cmp PARAM1
          bcs .NotTouching
          adc #8
          cmp PARAM1
          bcc .NotTouching

          lda #1
          rts

.NotTouching
          lda #0
          rts



;check enemy collision with player
;x = player index
!zone CheckCollisions
CheckCollisionsForPlayer
          ;only collide when player is alive
          lda OBJECT_ACTIVE
          cmp #TYPE_PLAYER
          beq +
          rts
+

          ;player invincible
          lda OBJECT_STATE
          bpl +
          rts
+

          ldy #0


;y = object to check
CheckCollisions
          sty CURRENT_INDEX

          ldx #1
          stx CURRENT_SUB_INDEX
-
          ldx CURRENT_SUB_INDEX
          lda OBJECT_ACTIVE,x
          bne +

.NextObject
          inc CURRENT_SUB_INDEX
          lda CURRENT_SUB_INDEX
          cmp #8
          bne -

          ldx CURRENT_INDEX
          rts

+
          ;check for collision
          ;is in untouchable state?
          lda OBJECT_STATE,x
          bmi .NextObject

          lda OBJECT_MAIN_INDEX,x
          tax

          ldy OBJECT_ACTIVE,x
          lda TYPE_ENEMY_TYPE_FLAGS,y
          beq .NextObject

          ldy CURRENT_INDEX
          ldx CURRENT_SUB_INDEX
          jsr IsEnemyCollidingWithObject
          bne .PlayerCollidedWithEnemy

          jmp .NextObject

.PlayerCollidedWithEnemy
          ;player index in x
          ;enemy index in y
          ;player killed?
          ldx CURRENT_INDEX
          ldy CURRENT_SUB_INDEX

          cpx #0
          lbeq .IsPlayer

          ;other object
          lda OBJECT_ACTIVE,x
          cmp #TYPE_PLAYER_SHOT
          beq .IsPlayerShot

          jmp .NextObject


.IsPlayerShot
          lda OBJECT_MAIN_INDEX,y
          tay

          lda OBJECT_ACTIVE,y
          tay
          lda TYPE_ENEMY_TYPE_FLAGS,y
          beq .NextObject
          bit #ETF_SHOOTABLE
          bne .KillEnemyWithShot
          bit #ETF_DEADLY
          bne .KillShot
          ;beq .KillEnemyWithShot

          jmp .NextObject

.KillShot
          lda #0
          sta PLAYER_SHOT_ACTIVE

          ;remove shot
ExplodeObject
          lda #TYPE_EXPLOSION
          sta OBJECT_ACTIVE,x

          lda #<SPRITE_EXPLOSION
          sta OBJECT_SPRITE,x
          lda #>SPRITE_EXPLOSION
          sta OBJECT_SPRITE_HI,x
          rts

.KillEnemyWithShot
          lda #0
          sta PLAYER_SHOT_ACTIVE

          ;remove shot
          ldx CURRENT_INDEX
          jsr ExplodeObject

          ;hurt enemy
          ldy CURRENT_SUB_INDEX
          ldx OBJECT_MAIN_INDEX,y

          dec OBJECT_HP,x
          beq .Killed

          jmp .NextObject

.Killed
          ;remove enemy - flatten flattenable enemies
          ldy OBJECT_ACTIVE,x

          lda FLATTENED_ENEMY_SPRITE,y
          lbne FlattenEnemy

.KillEnemy
          ldy CURRENT_SUB_INDEX
          ldx OBJECT_MAIN_INDEX,y

          lda OBJECT_ACTIVE,x
          cmp #TYPE_ANT
          bne +

          ;kill effect
          lda #TYPE_PLAYER_DYING
          sta OBJECT_ACTIVE,x
          sta OBJECT_ACTIVE + 1,x
          sta OBJECT_ACTIVE + 2,x

          lda #0
          sta OBJECT_STATE,x
          sta OBJECT_STATE + 1,x
          sta OBJECT_STATE + 2,x

          lda #<SPRITE_ANT_DEAD_1
          sta OBJECT_SPRITE,x
          clc
          adc #3
          sta OBJECT_SPRITE + 1,x
          clc
          adc #3
          sta OBJECT_SPRITE + 2,x

          lda #>SPRITE_ANT_DEAD_1
          sta OBJECT_SPRITE_HI,x
          sta OBJECT_SPRITE_HI + 1,x
          sta OBJECT_SPRITE_HI + 2,x
          rts

+
          cmp #TYPE_DRAGON
          bne +

          ;kill effect
          lda #TYPE_PLAYER_DYING
          sta OBJECT_ACTIVE,x
          sta OBJECT_ACTIVE + 1,x
          sta OBJECT_ACTIVE + 2,x
          sta OBJECT_ACTIVE + 3,x
          sta OBJECT_ACTIVE + 4,x

          lda #0
          sta OBJECT_STATE,x
          sta OBJECT_STATE + 1,x
          sta OBJECT_STATE + 2,x
          sta OBJECT_STATE + 3,x
          sta OBJECT_STATE + 42,x

          lda #<SPRITE_DRAGON_DEAD_1
          sta OBJECT_SPRITE,x
          clc
          adc #3
          sta OBJECT_SPRITE + 1,x
          clc
          adc #3
          sta OBJECT_SPRITE + 2,x
          clc
          adc #3
          sta OBJECT_SPRITE + 3,x
          clc
          adc #3
          sta OBJECT_SPRITE + 4,x

          lda #>SPRITE_DRAGON_DEAD_1
          sta OBJECT_SPRITE_HI,x
          sta OBJECT_SPRITE_HI + 1,x
          sta OBJECT_SPRITE_HI + 2,x
          sta OBJECT_SPRITE_HI + 3,x
          sta OBJECT_SPRITE_HI + 4,x
          rts
+
          jmp RemoveObject



.IsPlayer
          lda OBJECT_ACTIVE,y
          tay
          lda TYPE_ENEMY_TYPE_FLAGS,y
          lbeq .NextObject

          bit #ETF_EXTRA
          bne .Pickup
          bit #ETF_JUMPABLE
          beq +

          ;jumpable enemy
          lda OBJECT_FLAGS
          and #OF_JUMPING | OF_ON_GROUND
          beq ++
          jmp PlayerKilled
++
          ;jumped on enemy
          ldx CURRENT_SUB_INDEX
          jsr FlattenEnemy

          ldx CURRENT_INDEX

          ;auto-jump
          lda #10
          sta JUMP_STEPS_LEFT
          lda #1
          sta OBJECT_JUMP_POS
          lda #0
          sta OBJECT_FALL_SPEED
          sta OBJECT_FALL_SPEED_DELAY
          lda #OF_JUMPING
          tsb OBJECT_FLAGS
          jmp .NextObject

+
          bit #ETF_DEADLY
          beq +

          jmp PlayerKilled
+
          jmp .NextObject

.Pickup
          ldx CURRENT_SUB_INDEX
          lda OBJECT_ACTIVE,x
          cmp #TYPE_EXTRA
          beq .PickExtra
          cmp #TYPE_EXTRA_2
          beq .PickExtra

          ;the final crystal
          lda #1
          sta REACHED_EXIT
          jmp .NextObject

.PickExtra
          lda OBJECT_VALUE,x
          sta PARAM7

          inc
          sta PLAYER_POWERED_UP
          cmp #1
          bne +

          ;first power up has freeze delay
          lda #50
          sta GAME_FREEZE_DELAY

+

          lda PARAM7
          cmp #3
          bne +

          ;clock back to 99
          lda #CHAR_9
          sta SCREEN_CHAR + ROW_SIZE_BYTES + GUI_TIME_OFFSET * 2
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_TIME_OFFSET + 1 ) * 2
          sta TIME_VALUE_BCD
          sta TIME_VALUE_BCD + 1
          lda #99
          sta TIME_VALUE

          jmp ++
+
          cmp #4
          bne +

          ;extra live
          inc PLAYER_LIVES

          ldx #1
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_LIVES_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_LIVES_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1
          jsr IncreaseValue


+
++
          ldy #SFX_POWER_UP
          jsr PlaySoundEffect

          ;score +50
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          lda #5
          ldx #4
          jsr IncreaseValueByA

          ldx CURRENT_SUB_INDEX
          jsr RemoveObject
          ldx CURRENT_INDEX
          jmp .NextObject



!zone FlattenEnemy
;x = enemy index
FlattenEnemy
          ldy OBJECT_ACTIVE,x
          lda FLATTENED_ENEMY_SPRITE,y
          sta OBJECT_SPRITE,x
          lda FLATTENED_ENEMY_SPRITE_HI,y
          sta OBJECT_SPRITE_HI,x
          lda #TYPE_FLAT
          sta OBJECT_ACTIVE,x

          lda OBJECT_FLAGS,x
          and #~OF_ON_GROUND
          sta OBJECT_FLAGS,x

          phx
          phy

          ldy #SFX_FLATTEN_ENEMY
          jsr PlaySoundEffect

          ;score +50
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          lda #5
          ldx #4
          jsr IncreaseValueByA

          ply
          plx

          rts



!zone IsCharBlocking
.X_POS
          !byte 0

;a = 0 > not blocking
;a = 1 - blocking
IsCharBlocking
          cpx #0
          lbne .NotThePlayer2

          cmp #CHAR_SECRET_ENTRANCE
          bne .NotASecretEntrance

          ldz #1
          stz PLAYER_ENTERED_SECRET
          jmp .NotBlocking

.NotASecretEntrance
          cmp #CHAR_WARP
          bcc .NotWarp
          cmp #CHAR_WARP + 2 + 1
          bcs .NotWarp

          ;can only block upwards
          ldz MOVING_DIR
          cpz #DIR_U
          lbne .NotBlocking

          jsr HitWarpBlock

          ;;detect x offset
;          ;y = x offset in screen buffer (0 is NOT left end)
;          sty .X_POS
;-
;          dey
;          lda (ZEROPAGE_POINTER_1),y
;          cmp #CHAR_WARP
;          beq -
;
;          iny
;          ;actual left side of warp



          jmp .Blocking

.NotWarp
          cmp #CHAR_BRICK_1
          bcc .NotABrickBlock
          cmp #CHAR_BRICK_3 + 1
          bcs .NotABrickBlock

          ldz MOVING_DIR
          cpz #DIR_U
          lbne .Blocking

          ldz PLAYER_POWERED_UP
          lbeq .Blocking

          jsr HitBrickBlock
          jmp .Blocking


.NotABrickBlock
          cmp #CHAR_STAR_1
          bcc .NotAStarBlock
          cmp #CHAR_STAR_3 + 1
          bcs .NotAStarBlock

          ldz MOVING_DIR
          cpz #DIR_U
          lbne .Blocking

          jsr HitStarBlock
          jmp .Blocking


.NotAStarBlock
          cmp #CHAR_BRIDGE_1
          bcc .NotBridge
          cmp #CHAR_BRIDGE_1 + 4
          bcs .NotBridge

          ldz MOVING_DIR
          cpz #DIR_D
          lbne .NotBlocking

          ;on a bridge!
          ;inc VIC.BORDER_COLOR
          clc
          adc #2
          sta (ZEROPAGE_POINTER_1),y
          jmp .Blocking

.NotBridge
          cmp #CHAR_BRIDGE_1 + 4
          bcc .NotBridge2
          cmp #CHAR_BRIDGE_1 + 6
          bcs .NotBridge2

          ldz MOVING_DIR
          cpz #DIR_D
          lbne .NotBlocking

          ;on a bridge!
          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_1),y
          jmp .Blocking

.NotBridge2
          cmp #CHAR_EXIT
          bne .NotExit

          lda #1
          sta REACHED_EXIT
          jmp .NotBlocking

.NotExit
.NotThePlayer2
          cmp #CHAR_WARP
          lbeq .NotBlocking

          cmp #CHAR_FIRST_DEADLY
          bcc .NotDeadly

          cpx #0
          lbne .NotBlocking

          ;deadly char hit
          jsr PlayerKilled
          jmp .NotBlocking

.NotDeadly
          cmp #CHAR_LAST_BLOCKING
          lbcs .NotBlocking

          cmp #CHAR_FIRST_BLOCKING
          lbcs .Blocking

          cpx #0
          lbne .NotThePlayer

          ;check for diamond
          cmp #CHAR_DIAMOND_1
          lbcc .NotBlocking
          cmp #CHAR_DIAMOND_1 + 4
          lbcs .NotBlocking

          ;diamond

          ;y = offset in x (in bytes)
          sty .X_POS

          sec
          sbc #CHAR_DIAMOND_1
          tay

          ;set ZEROPAGE_POINTER_2 to top left corner of diamond
          lda ZEROPAGE_POINTER_1
          sec
          sbc DIAMOND_OFFSET_RRB,y
          sta ZEROPAGE_POINTER_2
          lda ZEROPAGE_POINTER_1 + 1
          sbc #0
          sta ZEROPAGE_POINTER_2 + 1

          lda ZEROPAGE_POINTER_2
          clc
          adc .X_POS
          sta ZEROPAGE_POINTER_2
          bcc +
          inc ZEROPAGE_POINTER_2 + 1
+

          ;.X_POS has offset of original ZEROPAGE_POINTER_1
          lda .X_POS
          sec
          sbc DIAMOND_X_OFFSET,y
          sta .X_POS

          ;get in game x pos of diamond (RRB x - 41 * 2 ) / 2
          ;jmp Debug

          ;flag if we need to skip left char
          ldy #0
          sty PARAM2

          lda .X_POS
          lsr
          sta PARAM1

          cmp #$7f
          bne +

          ;half diamond is outside
          lda #1
          sta PARAM2
          lda #0
          sta PARAM1

          jmp ++

;+
          ;;diamond is fully outside (??) yes, it happens!
          ;cmp #$7d
          ;bne +

          ;lda #0
          ;sta PARAM1
          ;jmp .DirectSpawn

++

+
          ldy #0
          ;ldx PARAM1
          ;cpx #$7f
          lda PARAM2
          bne .CutLeftChar

          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_2),y
.CutLeftChar
          iny
          iny
          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_2),y
          tya
          clc
          adc #ROW_SIZE_BYTES - 2
          tay

          ;ldx PARAM1
          ;cpx #$7f
          lda PARAM2
          bne .CutLeftChar2

          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_2),y
.CutLeftChar2
          iny
          iny
          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_2),y

.DirectSpawn
          ;spawn diamond (and increase bonus counter)
          lda OBJECT_CHAR_POS_Y
          dec
          dec
          sta PARAM2
          jsr PickedDiamond

          ldy .X_POS
          ldx CURRENT_INDEX


.NotThePlayer
.NotBlocking
          lda #0
          rts

.Blocking
          lda #1
          rts



!zone PickedDiamond
;PARAM1, PARAM2 char pos of diamond
;returns X = sprite index of diamond
PickedDiamond
          lda #TYPE_DIAMOND
          sta PARAM3
          ldx #1
          jsr SpawnObjectStartingWithSlot
          cpx #NUM_OBJECT_SLOTS
          beq .NoDiamondSpawned

          stx LOCAL1

          lda #0
          sta OBJECT_JUMP_POS,x
          lda #OF_JUMPING | OF_NON_BLOCKING
          sta OBJECT_FLAGS,x

.NoDiamondSpawned
          ;score +25
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          lda #2
          ldx #4
          jsr IncreaseValueByA

          lda #5
          ldx #5
          jsr IncreaseValueByA

          ;bonus
          ldx #1
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_BONUS_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_BONUS_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1
          jsr IncreaseValue

          inc BONUS_COUNT
          lda BONUS_COUNT
          cmp #100
          bne +

          ;extra live
          inc PLAYER_LIVES

          lda #0
          sta BONUS_COUNT

          ldx #1
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_LIVES_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_LIVES_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1
          jsr IncreaseValue

          lda #CHAR_0
          sta SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_BONUS_OFFSET
          sta SCREEN_CHAR + ROW_SIZE_BYTES + 2 * ( GUI_BONUS_OFFSET + 1 )
+


          ldy #SFX_PICK_DIAMOND
          lda #0
          jsr PlaySoundEffect

          ldx LOCAL1
          rts



          ;offset in screen data
DIAMOND_OFFSET
          !byte ( 40 + 1 ) * 2, 40 * 2, 1 * 2,0 * 2

DIAMOND_OFFSET_RRB
          ;!byte ( ROW_SIZE + 1 ) * 2, ROW_SIZE * 2, 1 * 2,0 * 2
          !byte 0 * 2, 1 * 2, ROW_SIZE * 2, ( ROW_SIZE + 1 ) * 2

DIAMOND_X_OFFSET
          !byte 0,2,0,2


!zone HitWarpBlock
;x = player index
;y = offset (x-pos) in screen line
;ZEROPAGE_POINTER_1 is pointer to screen pos
;a = hit star block char
HitWarpBlock
          phy

          cmp #CHAR_WARP + 1
          beq .MiddleChar
          cmp #CHAR_WARP
          beq .LeftChar

          ;hit right
          dey
          dey

.MiddleChar
          dey
          dey

.LeftChar
          lda ZEROPAGE_POINTER_1
          sec
          sbc #ROW_SIZE_BYTES
          sta ZEROPAGE_POINTER_2

          lda ZEROPAGE_POINTER_1 + 1
          sbc #0
          sta ZEROPAGE_POINTER_2 + 1

          cpy #00
          bmi .Skip1

          lda #CHAR_EMPTY_BLOCK_1
          sta (ZEROPAGE_POINTER_2),y
.Skip1
          iny
          iny
          bmi .Skip2
          lda #CHAR_EMPTY_BLOCK_1 + 1
          sta (ZEROPAGE_POINTER_2),y
.Skip2
          iny
          iny
          ;remember original char, to check whether its a power up or a diamond
          lda (ZEROPAGE_POINTER_2),y
          sta PARAM1

          lda #CHAR_EMPTY_BLOCK_1 + 2
          sta (ZEROPAGE_POINTER_2),y
          tya
          clc
          adc #( ROW_SIZE - 2 ) * 2
          tay
          cpy #ROW_SIZE_BYTES
          bcc .Skip3

          lda #CHAR_EMPTY_BLOCK_1 + 3
          sta (ZEROPAGE_POINTER_2),y
.Skip3
          iny
          iny
          cpy #ROW_SIZE_BYTES
          bcc .Skip4

          lda #CHAR_EMPTY_BLOCK_1 + 4
          sta (ZEROPAGE_POINTER_2),y
.Skip4
          iny
          iny
          lda #CHAR_EMPTY_BLOCK_1 + 5
          sta (ZEROPAGE_POINTER_2),y

          lda #1
          sta REACHED_WARP
          lda #160
          sta REACHED_WARP_DELAY


          ldy #SFX_WARP
          lda #0
          jsr PlaySoundEffect

          ply
          ldx #0
          rts



!zone HitStarBlock
;x = player index
;y = offset (x-pos) in screen line
;ZEROPAGE_POINTER_1 is pointer to screen pos
;a = hit star block char
HitStarBlock
          phy

          cmp #CHAR_STAR_1 + 1
          beq .MiddleChar
          cmp #CHAR_STAR_1
          beq .LeftChar

          ;hit right
          dey
          dey

.MiddleChar
          dey
          dey

.LeftChar
          lda ZEROPAGE_POINTER_1
          sec
          sbc #ROW_SIZE_BYTES
          sta ZEROPAGE_POINTER_2

          lda ZEROPAGE_POINTER_1 + 1
          sbc #0
          sta ZEROPAGE_POINTER_2 + 1

          cpy #00
          bmi .Skip1

          lda #CHAR_EMPTY_BLOCK_1
          sta (ZEROPAGE_POINTER_2),y
.Skip1
          iny
          iny
          bmi .Skip2
          lda #CHAR_EMPTY_BLOCK_1 + 1
          sta (ZEROPAGE_POINTER_2),y
.Skip2
          iny
          iny
          ;remember original char, to check whether its a power up or a diamond
          lda (ZEROPAGE_POINTER_2),y
          sta PARAM1

          lda #CHAR_EMPTY_BLOCK_1 + 2
          sta (ZEROPAGE_POINTER_2),y
          tya
          clc
          adc #( ROW_SIZE - 2 ) * 2
          tay
          cpy #ROW_SIZE_BYTES
          bcc .Skip3

          lda #CHAR_EMPTY_BLOCK_1 + 3
          sta (ZEROPAGE_POINTER_2),y
.Skip3
          iny
          iny
          cpy #ROW_SIZE_BYTES
          bcc .Skip4

          lda #CHAR_EMPTY_BLOCK_1 + 4
          sta (ZEROPAGE_POINTER_2),y
.Skip4
          iny
          iny
          lda #CHAR_EMPTY_BLOCK_1 + 5
          sta (ZEROPAGE_POINTER_2),y

          ;power up or diamond?
          lda PARAM1
          cmp #CHAR_STAR_1 - 1
          beq .Diamond

          jsr SpawnExtra

          ldx #0
          jmp .PowerupSpawned



.Diamond
          ;spawn diamond (and increase bonus counter)
          tya
          sec
          sbc #( ROW_SIZE + 1 ) * 2
          lsr
          sta PARAM1
          cmp #$7f
          bcc +

          lda #0
          sta PARAM1
+

          lda OBJECT_CHAR_POS_Y
          dec
          dec
          sta PARAM2

          ;jmp Debug

          jsr PickedDiamond

          ;center diamond on block
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft

          ldx CURRENT_INDEX

.PowerupSpawned
          ply

          rts



!zone HitBrickBlock
;x = player index
;y = offset (x-pos) in screen line
;ZEROPAGE_POINTER_1 is pointer to screen pos
;a = hit star block char
HitBrickBlock
          phy

          cmp #CHAR_BRICK_1 + 2
          beq .RightChar
          cmp #CHAR_BRICK_1 + 1
          beq .MiddleChar
          cmp #CHAR_BRICK_1
          lbne .NotHitRight

          jmp .LeftChar

.RightChar
          dey
          dey

.MiddleChar
          dey
          dey

.LeftChar
          lda ZEROPAGE_POINTER_1
          sec
          sbc #ROW_SIZE_BYTES
          sta ZEROPAGE_POINTER_2

          lda ZEROPAGE_POINTER_1 + 1
          sbc #0
          sta ZEROPAGE_POINTER_2 + 1

          ;remember original char, to check whether its a power up or a diamond
          tya
          clc
          adc #4
          tay
          lda (ZEROPAGE_POINTER_2),y
          sta PARAM1

          tya
          sec
          sbc #4
          tay

          lda PARAM1
          cmp #CHAR_BRICK_1  - 1
          bne .HiddenDiamondBlock

          ldx #0
-
          lda DUST_POS,x
          bne +

          lda #2
          sta DUST_POS,x
          lda #0
          sta DUST_POS_DELAY,x
          sty DUST_X,x
          lda OBJECT_CHAR_POS_Y
          dec
          dec
          dec
          sta DUST_Y,x

          ;offset to brick dust
          ldx #2
          jmp .DustAdded
+
          inx
          cpx #NUM_DUST_ENTRIES
          bne -

          inc VIC.BORDER_COLOR
          jmp *

.HiddenDiamondBlock
          ;offset to empty star block
          ldx #3
.DustAdded
          cpy #00
          bmi .Skip1

          lda DUST_CHAR_1,x
          sta (ZEROPAGE_POINTER_2),y
.Skip1
          iny
          iny
          bmi .Skip2
          lda DUST_CHAR_2,x
          sta (ZEROPAGE_POINTER_2),y
.Skip2
          iny
          iny
          lda DUST_CHAR_3,x
          sta (ZEROPAGE_POINTER_2),y
          tya
          clc
          adc #( ROW_SIZE - 2 ) * 2
          tay
          cpy #ROW_SIZE_BYTES
          bcc .Skip3

          lda DUST_CHAR_4,x
          sta (ZEROPAGE_POINTER_2),y
.Skip3
          iny
          iny
          cpy #ROW_SIZE_BYTES
          bcc .Skip4

          lda DUST_CHAR_5,x
          sta (ZEROPAGE_POINTER_2),y
.Skip4
          iny
          iny
          lda DUST_CHAR_6,x
          sta (ZEROPAGE_POINTER_2),y

          ;diamond?
          lda PARAM1
          cmp #CHAR_BRICK_1 - 1
          beq .NoDiamond

          ;spawn diamond (and increase bonus counter)
          tya
          sec
          sbc #( ROW_SIZE + 1 ) * 2
          lsr
          sta PARAM1
          cmp #$7f
          bcc +

          lda #0
          sta PARAM1

+

          lda OBJECT_CHAR_POS_Y
          dec
          dec
          sta PARAM2

          jsr PickedDiamond

          ;center diamond on block
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft
          jsr ObjectMoveLeft

.NoDiamond
.NotHitRight


          ldy #SFX_BRICK_BREAK
          lda #0
          jsr PlaySoundEffect

          ply
          ldx CURRENT_INDEX

          rts



!zone SpawnExtra
;y = offset (x-pos) in screen line
;ZEROPAGE_POINTER_1 is pointer to screen pos
SpawnExtra
          tya
          sec
          sbc #( ROW_SIZE + 1 ) * 2
          lsr
          sta PARAM1

          lda OBJECT_CHAR_POS_Y
          dec
          dec
          sta PARAM2

          lda #TYPE_EXTRA
          sta PARAM3

          lda PLAYER_POWERED_UP
          beq +

          ;other extras as extra 2
          lda #TYPE_EXTRA_2
          sta PARAM3

+


          ldx #1
          jsr SpawnObjectStartingWithSlot

          ;player powered up state matches next power up

          ;max out at extra life
          lda PLAYER_POWERED_UP
          cmp #5
          bne +

          lda #4
          sta OBJECT_VALUE,x
          jmp ++
+

          lda PLAYER_POWERED_UP
          sta OBJECT_VALUE,x
++
          tay
          lda POWER_UP_SPRITE,y
          sta OBJECT_SPRITE,x
          lda POWER_UP_SPRITE_HI,y
          sta OBJECT_SPRITE_HI,x

          lda #10
          sta OBJECT_JUMP_POS,x
          lda #OF_JUMPING | OF_NON_BLOCKING
          sta OBJECT_FLAGS,x

          ldy #SFX_DISK_PUSH
          jsr PlaySoundEffect

          rts




!zone HandleObjectFall
.NUM_CHARS_TO_CHECK
          !byte 0

HandleObjectFall
          lda #DIR_D
          sta MOVING_DIR

          lda OBJECT_FALL_SPEED,x
          sta PARAM5
.OnlyCheck
          lda OBJECT_POS_Y_DELTA,x
          bne .CanFall

          ldy OBJECT_CHAR_POS_Y,x
          bmi .CanFall
          beq .CanFall
          cpy #24
          bcs .CanFall

          iny
          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ;sprite width
          lda OBJECT_WIDTH_CHARS,x
          sta .NUM_CHARS_TO_CHECK
          lda OBJECT_POS_X_DELTA,x
          beq +
          inc .NUM_CHARS_TO_CHECK
+

          lda OBJECT_CHAR_POS_X,x
          asl
          tay
-
          lda (ZEROPAGE_POINTER_1),y

          ;1st char
          jsr IsCharBlocking
          bne .Blocked

          dec .NUM_CHARS_TO_CHECK
          beq .CanFall

          ;next char
          iny
          iny
          jmp -
;          lda (ZEROPAGE_POINTER_1),y
;
;          jsr IsCharBlocking
;          bne .Blocked
;
;          ;3rd char?
;          lda OBJECT_POS_X_DELTA,x
;          beq .CanFall
;
;          iny
;          iny
;          lda (ZEROPAGE_POINTER_1),y
;
;          jsr IsCharBlocking
;          beq .CanFall
;
.Blocked
          ;blocked
          lda #0
          sta OBJECT_FALL_SPEED,x
          lda OBJECT_FLAGS,x
          ora #OF_ON_GROUND
          sta OBJECT_FLAGS,x
          rts

.CanFall
          cpx #0
          bne +

          ;stand on platform?
          jsr IsPlayerStandingOnAnyPlatform

          bcc ++

          ;yes!
          lda #OF_ON_PLATFORM
          tsb OBJECT_FLAGS
          stx PLAYER_PLATFORM
          ldx #0
          jmp .Blocked


++
          lda #OF_ON_PLATFORM
          trb OBJECT_FLAGS
          lda #0
          sta PLAYER_PLATFORM

          ldx #0
+


          lda OBJECT_FLAGS,x
          and #!OF_ON_GROUND
          sta OBJECT_FLAGS,x

          lda OBJECT_FALL_SPEED,x
          cmp #4
          beq +

          inc OBJECT_FALL_SPEED_DELAY,x
          lda OBJECT_FALL_SPEED_DELAY,x
          and #$03
          bne +
          inc OBJECT_FALL_SPEED,x
+

          inc OBJECT_POS_Y,x
          inc OBJECT_POS_Y_DELTA,x
          lda OBJECT_POS_Y_DELTA,x
          cmp #8
          bne +
          lda #0
          sta OBJECT_POS_Y_DELTA,x
          inc OBJECT_CHAR_POS_Y,x
+

          dec PARAM5
          bmi .Done
          jmp .OnlyCheck
.Done
          lda OBJECT_CHAR_POS_Y,x
          cmp #27
          bcc +

          cmp #220
          bcs +

          ;fell off
          cpx #0
          bne ++

          jmp PlayerKilled

++

          jsr RemoveObject

+

          rts



!zone ObjectMoveDownBlocking
.NUM_CHARS_TO_CHECK
          !byte 0

ObjectMoveDownBlocking
          lda #DIR_D
          sta MOVING_DIR

          lda OBJECT_POS_Y_DELTA,x
          beq .CheckCanMoveDown

.CanMoveDown
          inc OBJECT_POS_Y_DELTA,x

          lda OBJECT_POS_Y_DELTA,x
          cmp #8
          bne .NoCharStep

          lda #0
          sta OBJECT_POS_Y_DELTA,x
          inc OBJECT_CHAR_POS_Y,x

.NoCharStep
          inc OBJECT_POS_Y,x

          lda #1
          rts

.CheckCanMoveDown
          lda OBJECT_CHAR_POS_Y,x
          clc
          adc #1
          and #31
          tay

          ;in score bar?
          beq .NotBlocked
          cpy #1
          beq .NotBlocked
          cpy #25
          beq .NotBlocked
          bcs .NotBlocked


          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ;sprite width
          lda OBJECT_WIDTH_CHARS,x
          sta .NUM_CHARS_TO_CHECK
          lda OBJECT_POS_X_DELTA,x
          beq +
          inc .NUM_CHARS_TO_CHECK
+

          lda OBJECT_CHAR_POS_X,x
          asl
          tay
-
          lda (ZEROPAGE_POINTER_1),y

          ;1st char
          jsr IsCharBlocking
          bne .BlockedDown

          dec .NUM_CHARS_TO_CHECK
          beq .NotBlocked

          ;next char
          iny
          iny
          jmp -


.NotBlocked
          ;not blocked
          jmp .CanMoveDown

.BlockedDown
          lda #0
          rts



;returns 0 if blocked, 1 if moved
!zone ObjectMoveUpBlocking
.NUM_CHARS_TO_CHECK
          !byte 0

ObjectMoveUpBlocking
          lda #DIR_U
          sta MOVING_DIR

          lda OBJECT_POS_Y_DELTA,x
          bne .CanMove

          ldy OBJECT_CHAR_POS_Y,x
          dey
          dey
          ;out of screen on top?
          bmi .CanMove
          ;inside score bar?
          beq .CanMove
          cpy #1
          beq .CanMove
          cpy #25
          beq .CanMove
          bcs .CanMove


          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ;chars to test
          lda OBJECT_WIDTH_CHARS,x
          sta .NUM_CHARS_TO_CHECK
          lda OBJECT_POS_X_DELTA,x
          beq +
          inc .NUM_CHARS_TO_CHECK

+

          lda OBJECT_CHAR_POS_X,x
          asl
          tay
-
          lda (ZEROPAGE_POINTER_1),y
          jsr IsCharBlocking
          bne .Blocked

          dec .NUM_CHARS_TO_CHECK
          beq .CanMove

          iny
          iny
          jmp -

          ;;2nd char
;          iny
;          iny
;          lda (ZEROPAGE_POINTER_1),y
;          jsr IsCharBlocking
;          bne .Blocked
;
;          ;3rd char?
;          lda OBJECT_POS_X_DELTA,x
;          beq .CanMove
;
;          iny
;          iny
;          lda (ZEROPAGE_POINTER_1),y
;          jsr IsCharBlocking
;          beq .CanMove

.Blocked
          ;blocked
          lda #0
          sta OBJECT_FALL_SPEED,x
          rts

.CanMove
          dec OBJECT_POS_Y,x
          lda OBJECT_POS_Y_DELTA,x
          bne +
          lda #8
          sta OBJECT_POS_Y_DELTA,x
          dec OBJECT_CHAR_POS_Y,x
+
          dec OBJECT_POS_Y_DELTA,x

          lda #1
          rts


!zone ObjectMoveUp
ObjectMoveUp
          dec OBJECT_POS_Y,x
          lda OBJECT_POS_Y_DELTA,x
          bne +
          lda #8
          sta OBJECT_POS_Y_DELTA,x
          dec OBJECT_CHAR_POS_Y,x
+
          dec OBJECT_POS_Y_DELTA,x
          rts



!zone ObjectMoveDown
ObjectMoveDown
          inc OBJECT_POS_Y,x
          inc OBJECT_POS_Y_DELTA,x
          lda OBJECT_POS_Y_DELTA,x
          cmp #8
          bne +
          lda #0
          sta OBJECT_POS_Y_DELTA,x
          inc OBJECT_CHAR_POS_Y,x
+
          rts



!zone ObjectMoveLeft
ObjectMoveLeft
          lda OBJECT_POS_X_DELTA,x
          bne +

          lda #8
          sta OBJECT_POS_X_DELTA,x
          dec OBJECT_CHAR_POS_X,x

+
          dec OBJECT_POS_X_DELTA,x

          lda OBJECT_POS_X,x
          bne +

          ;extended x bit flip
          dec OBJECT_POS_X_EX,x

          bpl .NotOutsideLeft

          ;outside left
          lda OBJECT_ACTIVE,x
          cmp #TYPE_PLAYER_SHOT
          bne .NotPlayerShot

          lda #0
          sta PLAYER_SHOT_ACTIVE

.NotPlayerShot
          jsr RemoveObject

.NotOutsideLeft
+

          dec OBJECT_POS_X,x

          lda #1
          rts


;returns 1 if moved, 0 if blocked
!zone ObjectMoveLeftBlocking
ObjectMoveLeftBlocking
          lda #DIR_L
          sta MOVING_DIR

          lda OBJECT_POS_X_DELTA,x
          beq .CheckCanMoveLeft

.CanMoveLeft
          jsr ObjectMoveLeft

          lda #1
          rts

.CheckCanMoveLeft
          cpx #0
          bne .NotThePlayer

          lda OBJECT_CHAR_POS_X,x
          cmp BLOCK_BORDER_L
          beq .Blocked

.NotThePlayer
          ;outside left
          lda OBJECT_CHAR_POS_X,x
          bmi .CanMoveLeft

          ;check
          lda #2
          sta PARAM4
          lda OBJECT_POS_Y_DELTA,x
          beq +
          inc PARAM4
+

          ldy OBJECT_CHAR_POS_Y,x
          dey
          sty PARAM6

--
          ldy PARAM6

          ;out of screen on top?
          bmi .CheckNextY
          ;inside score bar?
          beq .CheckNextY
          cpy #1
          beq .CheckNextY
          cpy #25
          beq .CheckNextY
          bcs .CheckNextY

          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ldy OBJECT_CHAR_POS_X,x
          dey
          tya
          asl
          tay
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          beq ++

.Blocked
          lda #0
          rts

++

.CheckNextY
          dec PARAM4
          beq .CanMoveLeft

          inc PARAM6
          jmp --



;returns 1 if moved, 0 if blocked
!zone ObjectMoveRightBlocking
ObjectMoveRightBlocking
          lda #DIR_R
          sta MOVING_DIR

          lda OBJECT_POS_X_DELTA,x
          bne .CanMove

          lda OBJECT_CHAR_POS_X,x
          cmp BLOCK_BORDER_R
          beq .Blocked

          ;check
          lda #2
          sta PARAM4
          lda OBJECT_POS_Y_DELTA,x
          beq +
          inc PARAM4
+

          ldy OBJECT_CHAR_POS_Y,x
          dey
          sty PARAM6

--
          ldy PARAM6

          ;out of screen on top?
          bmi .CheckNextY
          ;inside score bar?
          beq .CheckNextY
          cpy #1
          beq .CheckNextY
          cpy #25
          beq .CheckNextY
          bcs .CheckNextY

          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          lda OBJECT_CHAR_POS_X,x
          clc
          adc OBJECT_WIDTH_CHARS,x
          ;iny
          ;iny
          ;tya
          asl
          tay
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          beq ++

.Blocked
          lda #0
          rts

++

.CheckNextY
          dec PARAM4
          beq .CanMove

          inc PARAM6
          jmp --


.CanMove
ObjectMoveRight
          inc OBJECT_POS_X_DELTA,x
          lda OBJECT_POS_X_DELTA,x
          cmp #8
          bne +
          inc OBJECT_CHAR_POS_X,x
          lda #0
          sta OBJECT_POS_X_DELTA,x
+



          inc OBJECT_POS_X,x
          bne +

          inc OBJECT_POS_X_EX,x

          lda OBJECT_POS_X_EX,x
          cmp #2
          bne +

          ;outside right!
          jsr RemoveObject

+
          lda #1
          rts



!zone HandleObjectJump
HandleObjectJump
          ldy OBJECT_JUMP_POS,x

          lda JUMP_TABLE,y
          sta PARAM5
-
          ;move up until blocked
          lda OBJECT_FLAGS,x
          and #OF_NON_BLOCKING
          bne .Up

          jsr ObjectMoveUpBlocking
          beq .JumpDone

          bra +

.Up
          jsr ObjectMoveUp

+
          dec PARAM5
          beq .Done
          bmi .Done
          jmp -


.Done
          inc OBJECT_JUMP_POS,x
          lda OBJECT_JUMP_POS,x
          cmp #JUMP_TABLE_SIZE
          beq .JumpDone
          rts




.JumpDone
          lda OBJECT_FLAGS,x
          and #~OF_JUMPING
          sta OBJECT_FLAGS,x

          lda #0
          sta OBJECT_JUMP_POS,x

          rts



!zone MoveSpriteLeft
MoveSpriteLeft
          lda OBJECT_POS_X,x
          bne +

          ;extended x bit
          lda BIT_TABLE,x
          bit SHADOW_VIC_SPRITE_X_EXTEND
          beq .OutLeftSide

          eor #$ff
          and SHADOW_VIC_SPRITE_X_EXTEND
          sta SHADOW_VIC_SPRITE_X_EXTEND

+
          dec OBJECT_POS_X,x
          rts

.OutLeftSide
          jmp RemoveObject



;removes object from slot X
!zone RemoveObject
RemoveObject
          lda BIT_TABLE,x
          eor #$ff
          and VIC.SPRITE_ENABLE
          sta VIC.SPRITE_ENABLE

          lda #0
          sta OBJECT_ACTIVE,x
          rts



!zone SetSpriteValues
SetSpriteValues
          lda #0
          sta SHADOW_VIC_SPRITE_X_EXTEND
          sta SHADOW_VIC_SPRITE_ENABLE

          ldx #0
-
          lda OBJECT_ACTIVE,x
          beq ++

          txa
          asl
          tay

          lda OBJECT_SPRITE,x
          sta SPRITE_POINTER_BASE,y
          lda OBJECT_SPRITE_HI,x
          sta SPRITE_POINTER_BASE + 1,y
          lda BIT_TABLE,x
          tsb SHADOW_VIC_SPRITE_ENABLE

          lda OBJECT_POS_X_EX,x
          beq +
          lda BIT_TABLE,x
          tsb SHADOW_VIC_SPRITE_X_EXTEND

+

          ;update sprite pos with scroll offset
          lda SCROLL_POS
          clc
          adc OBJECT_POS_X,x
          sta VIC.SPRITE_X_POS,y
          bcc +

          ;jumped over 255
          lda BIT_TABLE,x
          tsb SHADOW_VIC_SPRITE_X_EXTEND
+

          lda OBJECT_CHAR_POS_Y,x
          bpl .RegularYPos

          ;outside the top, may reappear from bottom, hide below border
          lda #0
          jmp +



.RegularYPos
          lda OBJECT_POS_Y,x
+
          sta VIC.SPRITE_Y_POS,y


++
          inx
          cpx #NUM_OBJECT_SLOTS
          bne -

          lda SHADOW_VIC_SPRITE_X_EXTEND
          sta VIC.SPRITE_X_EXTEND

          lda SHADOW_VIC_SPRITE_ENABLE
          sta VIC.SPRITE_ENABLE

          lda PLAYER_POWERED_UP
          beq +

          lda SPRITE_POINTER_BASE
          clc
          adc #<( SPRITE_PLAYER_RUN_R_1_EX - SPRITE_PLAYER_RUN_R_1 )
          sta SPRITE_POINTER_BASE
          lda SPRITE_POINTER_BASE + 1
          adc #>( SPRITE_PLAYER_RUN_R_1_EX - SPRITE_PLAYER_RUN_R_1 )
          sta SPRITE_POINTER_BASE + 1

+

          rts


TYPE_START_SPRITE = * - 1
          !byte <SPRITE_PLAYER_RUN_R_1
          !byte <SPRITE_GOOMBA_1
          !byte <SPRITE_PLAYER_FALL_R
          !byte <SPRITE_GOOMBA_FLAT
          !byte <SPRITE_EXTRA
          !byte <SPRITE_DIAMOND
          !byte <SPRITE_ELEVATOR_1
          !byte <SPRITE_CRAB_L
          !byte <SPRITE_PLAYER_SHOT
          !byte <SPRITE_ELEVATOR_1 + 3
          !byte <SPRITE_BEE_1
          !byte <SPRITE_FISH_1
          !byte <SPRITE_EYE_1
          !byte <SPRITE_DRAGON
          !byte <SPRITE_ANT
          !byte <SPRITE_PLATFORM
          !byte <SPRITE_ANT
          !byte <SPRITE_EXPLOSION
          !byte <SPRITE_CLOWN
          !byte <SPRITE_CRYSTAL
          !byte <SPRITE_EXTRA

TYPE_START_SPRITE_HI = * - 1
          !byte >SPRITE_PLAYER_RUN_R_1
          !byte >SPRITE_GOOMBA_1
          !byte >SPRITE_PLAYER_FALL_R
          !byte >SPRITE_GOOMBA_FLAT
          !byte >SPRITE_EXTRA
          !byte >SPRITE_DIAMOND
          !byte >SPRITE_ELEVATOR_1
          !byte >SPRITE_CRAB_L
          !byte >SPRITE_PLAYER_SHOT
          !byte >SPRITE_ELEVATOR_1 + 3
          !byte >SPRITE_BEE_1
          !byte >SPRITE_FISH_1
          !byte >SPRITE_EYE_1
          !byte >SPRITE_DRAGON
          !byte >SPRITE_ANT
          !byte >SPRITE_PLATFORM
          !byte >SPRITE_ANT
          !byte >SPRITE_EXPLOSION
          !byte >SPRITE_CLOWN
          !byte >SPRITE_CRYSTAL
          !byte >SPRITE_EXTRA

;0 = player
;xxxx xxx1 = enemy

;1 = jumpable enemy
;2 = deadly enemy
;3 = extra
;4 = platform
;5 = floating platform

;flags ->
ETF_JUMPABLE            = $01
ETF_DEADLY              = $02
ETF_EXTRA               = $04
ETF_PLATFORM            = $08
ETF_FLOATING_PLATFORM   = $10
ETF_SHOOTABLE           = $20

TYPE_ENEMY_TYPE_FLAGS = * - 1
          !byte 0     ;mario
          !byte ETF_JUMPABLE | ETF_DEADLY | ETF_SHOOTABLE     ;goomba
          !byte 0     ;player dying
          !byte 0     ;flat
          !byte ETF_EXTRA     ;extra
          !byte 0     ;diamond
          !byte ETF_PLATFORM     ;elevator up
          !byte ETF_JUMPABLE | ETF_DEADLY | ETF_SHOOTABLE     ;crab
          !byte 0     ;player shot
          !byte 0     ;deco
          !byte ETF_JUMPABLE | ETF_DEADLY | ETF_SHOOTABLE     ;bee
          !byte ETF_DEADLY     ;fish
          !byte ETF_DEADLY | ETF_SHOOTABLE     ;eye
          !byte ETF_DEADLY | ETF_SHOOTABLE     ;dragon
          !byte ETF_DEADLY | ETF_SHOOTABLE     ;ant
          !byte ETF_FLOATING_PLATFORM     ;platform
          !byte ETF_DEADLY ;deadly deco
          !byte 0     ;explosion
          !byte ETF_DEADLY     ;clown
          !byte ETF_EXTRA     ;crystal
          !byte ETF_EXTRA     ;extra 2

TYPE_BEHAVIOUR_LO = * - 1
          !byte <BHPlayer
          !byte <BHGoomba
          !byte <BHDyingObject
          !byte <BHFlat
          !byte <BHExtra
          !byte <BHDiamond
          !byte <BHElevator
          !byte <BHCrab
          !byte <BHPlayerShot
          !byte <BHNone
          !byte <BHBee
          !byte <BHFish
          !byte <BHEye
          !byte <BHDragon
          !byte <BHAnt
          !byte <BHPlatform
          !byte <BHNone
          !byte <BHExplosion
          !byte <BHClown
          !byte <BHNone
          !byte <BHExtra

TYPE_BEHAVIOUR_HI = * - 1
          !byte >BHPlayer
          !byte >BHGoomba
          !byte >BHDyingObject
          !byte >BHFlat
          !byte >BHExtra
          !byte >BHDiamond
          !byte >BHElevator
          !byte >BHCrab
          !byte >BHPlayerShot
          !byte >BHNone
          !byte >BHBee
          !byte >BHFish
          !byte >BHEye
          !byte >BHDragon
          !byte >BHAnt
          !byte >BHPlatform
          !byte >BHNone
          !byte >BHExplosion
          !byte >BHClown
          !byte >BHNone
          !byte >BHExtra

TYPE_START_SPRITE_FLAGS = * - 1
          !byte 0         ;player
          !byte 0         ;goomba
          !byte 0         ;player dying
          !byte 0         ;flat
          !byte SF_DIR_R | SF_START_PRIO  ;extra
          !byte 0         ;diamond
          !byte 0         ;elevator
          !byte 0         ;crab
          !byte 0         ;player shot
          !byte 0         ;deco
          !byte 0         ;bee
          !byte 0         ;fish
          !byte 0         ;eye
          !byte 0         ;dragon
          !byte 0         ;ant
          !byte 0         ;platform
          !byte 0         ;deadly deco
          !byte 0         ;explosion
          !byte 0         ;clown
          !byte 0         ;crystal
          !byte SF_DIR_R | SF_START_PRIO  ;extra 2


TYPE_SPAWN_DELTA_X = * - 1
          !byte 0         ;player
          !byte 0         ;goomba
          !byte 0         ;player dying
          !byte 0         ;flat
          !byte 4         ;extra
          !byte 4         ;diamond
          !byte 4         ;elevator
          !byte 0         ;crab
          !byte 0         ;player shot
          !byte 4         ;deco
          !byte 0         ;bee
          !byte 4         ;fish
          !byte 0         ;eye
          !byte 4         ;dragon
          !byte 4         ;ant
          !byte 4         ;platform
          !byte 4         ;deadly deco
          !byte 0         ;explosion
          !byte 0         ;clown
          !byte 0         ;crystal
          !byte 4         ;extra 2

;offset added onto Y
TYPE_SPAWN_DELTA_Y = * - 1
          !byte 0         ;player
          !byte 3         ;goomba
          !byte 0         ;player dying
          !byte 0         ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 5         ;elevator
          !byte 3         ;crab
          !byte 0         ;player shot
          !byte 5         ;deco
          !byte 1         ;bee
          !byte 1         ;fish
          !byte 3         ;eye
          !byte 3         ;dragon
          !byte 3         ;ant
          !byte 5         ;platform
          !byte 3         ;deadly deco (ant/dragon parts)
          !byte 0         ;explosion
          !byte 0         ;clown
          !byte 0         ;crystal
          !byte 0         ;extra 2

TYPE_SPRITE_PALETTE = * - 1
          !byte 3         ;player
          !byte 0         ;goomba
          !byte 3         ;player dying
          !byte 0         ;flat
          !byte 1         ;extra
          !byte 7         ;diamond
          !byte 0         ;elevator
          !byte 0         ;crab
          !byte 0         ;player shot
          !byte 0         ;deco
          !byte 6         ;bee
          !byte 0         ;fish
          !byte 0         ;eye
          !byte 0         ;dragon
          !byte 0         ;ant
          !byte 0         ;platform
          !byte 0         ;deadly deco
          !byte 0         ;explosion
          !byte 2         ;clown
          !byte 4         ;crystal
          !byte 5         ;extra 2

FLATTENED_ENEMY_SPRITE = * - 1
          !byte 0   ;player
          !byte <SPRITE_GOOMBA_FLAT
          !byte 0   ;player dying
          !byte 0   ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 0         ;elevator
          !byte <SPRITE_CRAB_FLAT
          !byte 0         ;player shot
          !byte 0         ;deco
          !byte <SPRITE_BEE_FLAT
          !byte 0         ;fish
          !byte <SPRITE_EYE_FLAT
          !byte 0         ;dragon
          !byte 0         ;ant
          !byte 0         ;platform
          !byte 0         ;deadly deco
          !byte 0         ;explosion
          !byte 0         ;clown
          !byte 0         ;crystal
          !byte 0         ;extra 2

FLATTENED_ENEMY_SPRITE_HI = * - 1
          !byte 0   ;player
          !byte >SPRITE_GOOMBA_FLAT
          !byte 0   ;player dying
          !byte 0   ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 0         ;elevator
          !byte >SPRITE_CRAB_FLAT
          !byte 0         ;player shot
          !byte 0         ;deco
          !byte >SPRITE_BEE_FLAT
          !byte 0         ;fish
          !byte >SPRITE_EYE_FLAT
          !byte 0         ;dragon
          !byte 0         ;ant
          !byte 0         ;platform
          !byte 0         ;deadly deco
          !byte 0         ;explosion
          !byte 0         ;clown
          !byte 0         ;crystal
          !byte 0         ;extra 2

TYPE_START_HP = * - 1
          !byte 0   ;player
          !byte 1   ;goomba
          !byte 0   ;player dying
          !byte 0   ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 0         ;elevator
          !byte 1         ;crab
          !byte 0         ;player shot
          !byte 0         ;deco
          !byte 1         ;bee
          !byte 0         ;fish
          !byte 1         ;eye
          !byte 25        ;dragon
          !byte 20        ;ant
          !byte 0         ;platform
          !byte 0         ;deadly deco
          !byte 0         ;explosion
          !byte 0         ;clown
          !byte 0         ;crystal
          !byte 0         ;extra 2

TYPE_SPRITE_WIDTH = * - 1
          !byte 1   ;player
          !byte 2   ;goomba
          !byte 1   ;player dying
          !byte 2   ;flat
          !byte 2         ;extra
          !byte 2         ;diamond
          !byte 2         ;elevator
          !byte 2         ;crab
          !byte 1         ;player shot
          !byte 1         ;deco
          !byte 1         ;bee
          !byte 2         ;fish
          !byte 2         ;eye
          !byte 9         ;dragon
          !byte 7         ;ant
          !byte 2         ;platform
          !byte 2         ;deadly deco
          !byte 1         ;explosion
          !byte 1         ;clown
          !byte 2         ;crystal
          !byte 2         ;extra 2

JUMP_TABLE
          !byte 6,6,5,5,4,4,4,4,3,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,0
JUMP_TABLE_SIZE = * - JUMP_TABLE



OBJECT_ACTIVE
          !fill NUM_OBJECT_SLOTS,0

OBJECT_CHAR_POS_X
          !fill NUM_OBJECT_SLOTS,0
OBJECT_CHAR_POS_Y
          !fill NUM_OBJECT_SLOTS,0
OBJECT_POS_X
          !fill NUM_OBJECT_SLOTS,0
;the 9th bit
OBJECT_POS_X_EX
          !fill NUM_OBJECT_SLOTS,0
OBJECT_POS_X_DELTA
          !fill NUM_OBJECT_SLOTS,0
OBJECT_POS_Y
          !fill NUM_OBJECT_SLOTS,0
OBJECT_POS_Y_DELTA
          !fill NUM_OBJECT_SLOTS,0
OBJECT_COLOR
          !fill NUM_OBJECT_SLOTS,0
OBJECT_SPRITE
          !fill NUM_OBJECT_SLOTS,0
OBJECT_SPRITE_HI
          !fill NUM_OBJECT_SLOTS,0
OBJECT_ANIM_DELAY
          !fill NUM_OBJECT_SLOTS,0
OBJECT_ANIM_POS
          !fill NUM_OBJECT_SLOTS,0
OBJECT_HP
          !fill NUM_OBJECT_SLOTS,0

;$00 = left, $01 = right
OBJECT_DIR
          !fill NUM_OBJECT_SLOTS,0
;$00 = down, $01 = up
OBJECT_DIR_Y
          !fill NUM_OBJECT_SLOTS,0
OBJECT_FLAGS
          !fill NUM_OBJECT_SLOTS,0
OBJECT_STATE
          !fill NUM_OBJECT_SLOTS,0
OBJECT_STATE_POS
          !fill NUM_OBJECT_SLOTS,0
OBJECT_FALL_SPEED
          !fill NUM_OBJECT_SLOTS,0
OBJECT_FALL_SPEED_DELAY
          !fill NUM_OBJECT_SLOTS,0
OBJECT_JUMP_POS
          !fill NUM_OBJECT_SLOTS,0
OBJECT_MOVE_SPEED_X
          !fill NUM_OBJECT_SLOTS,0
OBJECT_MOVE_SPEED_Y
          !fill NUM_OBJECT_SLOTS,0
OBJECT_VALUE
          !fill NUM_OBJECT_SLOTS,0
OBJECT_MAIN_INDEX
          !fill NUM_OBJECT_SLOTS,0
OBJECT_WIDTH_CHARS
          !fill NUM_OBJECT_SLOTS,1

JUMP_STEPS_LEFT
          !byte 0

BLOCK_BORDER_L
          !byte 0
BLOCK_BORDER_R
          !byte 38

SCREEN_LINE_OFFSET_LO
!for SCREEN_ROW = 0 to 24
          !byte <( SCREEN_CHAR + SCREEN_ROW * ROW_SIZE_BYTES )
!end

SCREEN_LINE_OFFSET_HI
!for SCREEN_ROW = 0 to 24
          !byte >( SCREEN_CHAR + SCREEN_ROW * ROW_SIZE_BYTES )
!end

SCREEN_LINE_COLLISION_OFFSET_LO
!for SCREEN_ROW = 0 to 24
          !byte <( SCREEN_CHAR + 2 * 41 + SCREEN_ROW * ROW_SIZE_BYTES )
!end

SCREEN_LINE_COLLISION_OFFSET_HI
!for SCREEN_ROW = 0 to 24
          !byte >( SCREEN_CHAR + 2 * 41 + SCREEN_ROW * ROW_SIZE_BYTES )
!end


;0 = no powerup
;1 = headbutt
;2 = shot
;3 = bouncing shot
;4 = clock
;5 = extra live
PLAYER_POWERED_UP
          !byte 0

POWER_UP_SPRITE
          !byte <SPRITE_EXTRA
          !byte <SPRITE_EXTRA_FLASH
          !byte <SPRITE_EXTRA_FLASH_DOUBLE
          !byte <SPRITE_EXTRA_TIME
          !byte <SPRITE_EXTRA_LIVE

POWER_UP_SPRITE_HI
          !byte >SPRITE_EXTRA
          !byte >SPRITE_EXTRA_FLASH
          !byte >SPRITE_EXTRA_FLASH_DOUBLE
          !byte >SPRITE_EXTRA_TIME
          !byte >SPRITE_EXTRA_LIVE

PLAYER_ENTERED_SECRET
          !byte 0

SECRET_SCREEN_ACTIVE
          !byte 0


SHADOW_VIC_SPRITE_X_EXTEND
          !byte 0

SHADOW_VIC_SPRITE_ENABLE
          !byte 0

MOVING_DIR
          !byte 0

PLAYER_PLATFORM
          !byte 0