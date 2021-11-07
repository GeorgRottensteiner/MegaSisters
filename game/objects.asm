NUM_OBJECT_SLOTS = 8

SPRITE_BASE = ( SPRITE_LOCATION % 16384 ) / 64

SPRITE_PLAYER_RUN_R_1   = SPRITE_BASE + 0 * 4
SPRITE_PLAYER_RUN_R_2   = SPRITE_BASE + 1 * 4
SPRITE_PLAYER_JUMP_R    = SPRITE_BASE + 2 * 4
SPRITE_PLAYER_FALL_R    = SPRITE_BASE + 3 * 4
SPRITE_PLAYER_DIE_R     = SPRITE_BASE + 4 * 4
SPRITE_PLAYER_RUN_L_1   = SPRITE_BASE + 5 * 4
SPRITE_PLAYER_RUN_L_2   = SPRITE_BASE + 6 * 4
SPRITE_PLAYER_JUMP_L    = SPRITE_BASE + 7 * 4
SPRITE_PLAYER_FALL_L    = SPRITE_BASE + 8 * 4
SPRITE_GOOMBA_1         = SPRITE_BASE + 10 * 4
SPRITE_GOOMBA_FLAT      = SPRITE_BASE + 12 * 4
SPRITE_EXTRA            = SPRITE_BASE + 13 * 4
SPRITE_DIAMOND          = SPRITE_BASE + 16 * 4
SPRITE_ELEVATOR_1       = SPRITE_BASE + 27 * 4

SPRITE_PLAYER_RUN_R_1_EX = SPRITE_BASE + 17 * 4

SPRITE_CRAB_R           = SPRITE_BASE + 30 * 4
SPRITE_CRAB_L           = SPRITE_BASE + 32 * 4
SPRITE_CRAB_FLAT        = SPRITE_BASE + 34 * 4

SPRITE_EXTRA_FLASH      = SPRITE_BASE + 35 * 4

SPRITE_PLAYER_SHOT      = SPRITE_BASE + 37 * 4

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
          lda PARAM3
          sta OBJECT_ACTIVE,x
          lda PARAM1
          sta OBJECT_CHAR_POS_X,x
          lda PARAM2
          sta OBJECT_CHAR_POS_Y,x

          ;init values
          ldy PARAM3
          lda TYPE_START_SPRITE,y
          sta OBJECT_SPRITE,x
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
          lda #SPRITE_LOCATION / 16384
          sta SPRITE_POINTER_BASE + 1,y

          ;TODO calc sprite pos
          jsr CalcSpritePosFromCharPos

          ldy OBJECT_ACTIVE,x
          lda TYPE_SPAWN_DELTA_X,y
          clc
          adc OBJECT_POS_X,x
          sta OBJECT_POS_X,x

          lda TYPE_SPAWN_DELTA_Y,y
          clc
          adc OBJECT_POS_Y,x
          sta OBJECT_POS_Y,x

          lda BIT_TABLE,x
          tsb VIC.SPRITE_ENABLE
          ;tsb VIC.SPRITE_MULTICOLOR

          ;lda OBJECT_SPRITE,x
          ;sta SPRITE_POINTER_BASE,y
          ;sta SPRITE_POINTER_BASE_2,y
          lda OBJECT_COLOR,x
          sta VIC.SPRITE_COLOR,x

          lda TYPE_START_SPRITE_FLAGS,y
          bit #SF_DIR_R
          beq +

          lda #1
          sta OBJECT_DIR,x

+
          ;
          lda TYPE_START_SPRITE_FLAGS,y
          and #SF_START_PRIO
          beq +

          lda BIT_TABLE,x
          tsb VIC.SPRITE_PRIORITY

+


          ;lda TYPE_START_SPRITE_FLAGS,y
          ;and #SF_EXTENDED_COLORS
          ;beq +

          lda BIT_TABLE,x
          tsb VIC4.SPR16EN
          tsb VIC4.SPRX64EN

          ;force 0 to be transparent
          lda #0
          sta VIC.SPRITE_COLOR,x

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



!zone BHPlayerDying
BHPlayerDying
          lda OBJECT_STATE,x
          bne +
          jsr HandleObjectJump

          lda OBJECT_JUMP_POS,x
          bne ++
          ;start falling
          inc OBJECT_STATE,x
          lda #1
          sta OBJECT_FALL_SPEED
          lda #0
          sta OBJECT_FALL_SPEED_DELAY
+
          inc OBJECT_FALL_SPEED_DELAY
          lda OBJECT_FALL_SPEED_DELAY
          and #$03
          bne .Fall
          inc OBJECT_FALL_SPEED
.Fall
          lda OBJECT_FALL_SPEED
          sta PARAM5

-
          beq .FallDone
          jsr ObjectMoveDown
          dec PARAM5
          jmp -


.FallDone
          lda OBJECT_POS_Y
          cmp #200
          bcc .NotDoneYet

          jmp RemoveObject

.NotDoneYet
          ;inc OBJECT_ANIM_POS,x
          ;lda OBJECT_ANIM_POS,x
          ;lsr
          ;lsr
          ;and #$03
          ;clc
          ;adc #SPRITE_PLAYER_DYING_1
          ;sta OBJECT_SPRITE,x
++
          rts



!zone BHPlayer
PlayerKilled
          lda #SPRITE_PLAYER_DIE_R
          sta SPRITE_POINTER_BASE
          lda #0
          sta OBJECT_ANIM_DELAY
          sta OBJECT_ANIM_POS
          lda #10
          sta OBJECT_JUMP_POS

          lda #1
          sta PLAYER_IS_DEAD

          lda #TYPE_PLAYER_DYING
          sta OBJECT_ACTIVE
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

          lda OBJECT_DIR
          sta OBJECT_DIR,x

          lda #1
          sta PLAYER_SHOT_ACTIVE

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
          dec .MOVE_DELTA
          bne .GoRight
          bra .XMovementDone

.GoLeft
          lda OBJECT_CHAR_POS_X,x
          beq .LeftBorder


          jsr ObjectMoveLeftBlocking
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
          beq .NoAnimUpdate

          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          and #$03
          bne +

          ldy OBJECT_DIR,x
          lda #$01
          eor OBJECT_ANIM_POS,x
          sta OBJECT_ANIM_POS,x

          asl
          asl
          clc
          adc PLAYER_SPRITES,y
          sta OBJECT_SPRITE,x

+
.NoAnimUpdate
          jmp .AnimDone

.MOVE_DELTA
          !byte 0

PLAYER_SPRITES
          !byte SPRITE_PLAYER_RUN_R_1
          !byte SPRITE_PLAYER_RUN_L_1

PLAYER_SPRITES_JUMP
          !byte SPRITE_PLAYER_JUMP_R
          !byte SPRITE_PLAYER_JUMP_L

PLAYER_SPRITES_FALL
          !byte SPRITE_PLAYER_FALL_R
          !byte SPRITE_PLAYER_FALL_L

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
          lda OBJECT_FLAGS,x
          ora #OF_JUMPING
          and #!OF_ON_GROUND
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
          jsr HandleObjectFall

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
          jmp .Moved

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
          jmp RemoveObject



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
          ora #SPRITE_GOOMBA_1
          sta OBJECT_SPRITE,x
          rts



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
          clc
          adc CRAB_SPRITE,y
          sta OBJECT_SPRITE,x
          rts

CRAB_SPRITE
          !byte SPRITE_CRAB_L, SPRITE_CRAB_R



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

          inc OBJECT_ANIM_DELAY,x
          lda OBJECT_ANIM_DELAY,x
          lsr
          lsr
          cmp #$3
          bne +

          lda #0
          sta OBJECT_ANIM_DELAY,x
+
          asl
          asl
          clc
          adc #SPRITE_EXTRA
          sta OBJECT_SPRITE,x
.NoAnim
          rts



!zone BHDiamond
BHDiamond
          lda OBJECT_FLAGS,x
          and #OF_JUMPING
          beq .NotJumping

          jmp HandleObjectJump

.NotJumping
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
        adc #16
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



;------------------------------------------------------------
;check object collision with player (object in y)
;x = enemy index
;y = player index
;return a = 1 when colliding, a = 0 when not
;------------------------------------------------------------

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

          ;is an enemy?
          lda OBJECT_ACTIVE,x
          tay
          lda TYPE_ENEMY_TYPE,y
          beq .NextObject

          ldy CURRENT_INDEX
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
          beq .IsPlayer

          ;other object
          lda OBJECT_ACTIVE,x
          cmp #TYPE_PLAYER_SHOT
          beq .IsPlayerShot

          jmp .NextObject


.IsPlayerShot
          lda OBJECT_ACTIVE,y
          tay
          lda TYPE_ENEMY_TYPE,y
          beq .NextObject
          cmp #1
          beq .KillEnemyWithShot
          cmp #2
          beq .KillEnemyWithShot

          jmp .NextObject

.KillEnemyWithShot
          lda #0
          sta PLAYER_SHOT_ACTIVE

          ;remove shot
          jsr RemoveObject

          ;remove enemy TODO - flatten flattenable enemies
          ldx CURRENT_SUB_INDEX
          ldy OBJECT_ACTIVE,x
          lda TYPE_ENEMY_TYPE,y
          cmp #1
          bne .KillEnemy

          jmp FlattenEnemy

.KillEnemy
          ldx CURRENT_SUB_INDEX
          jmp RemoveObject



.IsPlayer
          lda OBJECT_ACTIVE,y
          tay
          lda TYPE_ENEMY_TYPE,y
          beq .NextObject
          cmp #3
          beq .Pickup
          cmp #1
          bne +

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
          sta OBJECT_JUMP_POS
          lda #0
          sta OBJECT_FALL_SPEED
          sta OBJECT_FALL_SPEED_DELAY
          lda #OF_JUMPING
          tsb OBJECT_FLAGS
          jmp .NextObject

+

          cmp #2
          bne +

          jmp PlayerKilled
+
          jmp .NextObject

.Pickup
          ldx CURRENT_SUB_INDEX
          lda OBJECT_VALUE,x
          inc
          sta PLAYER_POWERED_UP
          cmp #1
          bne +

          ;first power up has freeze delay
          lda #50
          sta GAME_FREEZE_DELAY

+

          ldy #SFX_POWER_UP
          jsr PlaySoundEffect

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
          lda #TYPE_FLAT
          sta OBJECT_ACTIVE,x

          lda OBJECT_FLAGS,x
          and #~OF_ON_GROUND
          sta OBJECT_FLAGS,x

          phx
          phy

          ldy #SFX_FLATTEN_ENEMY
          jsr PlaySoundEffect

          ply
          plx

          rts



;a = 0 > not blocking
;a = 1 - blocking
!zone IsCharBlocking
.X_POS
          !byte 0

IsCharBlocking
          cpx #0
          bne .NotThePlayer2

          cmp #CHAR_SECRET_ENTRANCE
          bne .NotASecretEntrance

          ldz #1
          stz PLAYER_ENTERED_SECRET
          jmp .NotBlocking

.NotASecretEntrance
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

          ;on a bridge!
          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_1),y
          jmp .Blocking

.NotBridge2
          cmp #CHAR_EXIT
          bne .NotExit

          lda #1
          sta REACHED_EXIT

.NotExit
.NotThePlayer2
          cmp #CHAR_FIRST_DEADLY
          bcc .NotDeadly

          cpx #0
          bne .NotBlocking

          lda MOVING_DIR
          jmp Debug

          jsr PlayerKilled
          jmp .NotBlocking

.NotDeadly
          cmp #CHAR_LAST_BLOCKING
          bcs .NotBlocking

          cmp #CHAR_FIRST_BLOCKING
          lbcs .Blocking

          cpx #0
          bne .NotThePlayer

          ;check for diamond
          cmp #CHAR_DIAMOND_1
          bcc .NotBlocking
          cmp #CHAR_DIAMOND_1 + 4
          bcs .NotBlocking

          ;diamond
          sty .X_POS

          sec
          sbc #CHAR_DIAMOND_1
          tay

          lda DIAMOND_OFFSET,y
          clc
          adc .X_POS
          tay
          sty PARAM1
          lsr PARAM1

          lda PARAM1
          cmp #40
          bcc +
          sec
          sbc #40
          sta PARAM1
+
          dec PARAM1

          lda ZEROPAGE_POINTER_1
          sec
          sbc #41 * 2
          sta ZEROPAGE_POINTER_2
          lda ZEROPAGE_POINTER_1 + 1
          sbc #0
          sta ZEROPAGE_POINTER_2 + 1

          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_2),y
          iny
          iny
          sta (ZEROPAGE_POINTER_2),y
          tya
          clc
          adc #39 * 2
          tay
          lda #CHAR_EMPTY
          sta (ZEROPAGE_POINTER_2),y
          iny
          iny
          sta (ZEROPAGE_POINTER_2),y

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
          stx LOCAL1

          lda #0
          sta OBJECT_JUMP_POS,x
          lda #OF_JUMPING | OF_NON_BLOCKING
          sta OBJECT_FLAGS,x

          ;score
          ldx #5
          lda #<( SCREEN_CHAR + 80 + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + 80 + 2 * GUI_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          jsr IncreaseValue

          ;bonus
          ldx #1
          lda #<( SCREEN_CHAR + 80 + 2 * GUI_BONUS_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + 80 + 2 * GUI_BONUS_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          jsr IncreaseValue

          ldy #SFX_PICK_DIAMOND
          lda #0
          jsr PlaySoundEffect

          ldx LOCAL1
          rts



          ;offset in screen data
DIAMOND_OFFSET
          !byte 41 * 2,40 * 2,1 * 2,0 * 2




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
          sbc #80
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
          adc #38 * 2
          tay
          cpy #80
          bcc .Skip3

          lda #CHAR_EMPTY_BLOCK_1 + 3
          sta (ZEROPAGE_POINTER_2),y
.Skip3
          iny
          iny
          cpy #80
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
          sbc #41 * 2
          lsr
          sta PARAM1

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
          sbc #80
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
          adc #38 * 2
          tay
          cpy #80
          bcc .Skip3

          lda DUST_CHAR_4,x
          sta (ZEROPAGE_POINTER_2),y
.Skip3
          iny
          iny
          cpy #80
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
          sbc #41 * 2
          lsr
          sta PARAM1

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
          sbc #41 * 2
          lsr
          sta PARAM1

          lda OBJECT_CHAR_POS_Y
          dec
          dec
          sta PARAM2

          lda #TYPE_EXTRA
          sta PARAM3
          ldx #1
          jsr SpawnObjectStartingWithSlot

          ;player powered up state matches next power up
          lda PLAYER_POWERED_UP
          sta OBJECT_VALUE,x

          tay
          lda POWER_UP_SPRITE,y
          sta OBJECT_SPRITE,x

          lda #10
          sta OBJECT_JUMP_POS,x
          lda #OF_JUMPING | OF_NON_BLOCKING
          sta OBJECT_FLAGS,x

          ldy #SFX_DISK_PUSH
          jsr PlaySoundEffect

          rts




!zone HandleObjectFall
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
          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          lda OBJECT_CHAR_POS_X,x
          asl
          tay
          lda (ZEROPAGE_POINTER_1),y

          ;1st char
          jsr IsCharBlocking
          bne .Blocked

          ;2nd char
          iny
          iny
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          bne .Blocked

          ;3rd char?
          lda OBJECT_POS_X_DELTA,x
          beq .CanFall

          iny
          iny
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          beq .CanFall

.Blocked
          ;blocked
          lda #0
          sta OBJECT_FALL_SPEED,x
          lda OBJECT_FLAGS,x
          ora #OF_ON_GROUND
          sta OBJECT_FLAGS,x
          rts

.CanFall
;
;          lda OBJECT_CHAR_POS_Y,x
;          bmi .CameInFromBottom
;          lda OBJECT_POS_Y,x
;          cmp #207
;          bcc +
;          rts
;+
;.CameInFromBottom
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
          lda #0
          sta PARAM2

          lda OBJECT_POS_X_DELTA,x
          beq .NoSecondCharCheckNeeded

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


          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          inc PARAM2

          ldy OBJECT_CHAR_POS_X,x
          iny
          tya
          asl
          tay
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          bne .BlockedDown

.NoSecondCharCheckNeeded
          inc PARAM2

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

          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          lda OBJECT_CHAR_POS_X,x
          asl
          tay
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          bne .BlockedDown

.NotBlocked
          ;not blocked
          jmp .CanMoveDown

.BlockedDown
          lda #0
          rts



;returns 0 if blocked, 1 if moved
!zone ObjectMoveUpBlocking
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


          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          lda OBJECT_CHAR_POS_X,x
          asl
          tay
          lda (ZEROPAGE_POINTER_1),y

          jsr IsCharBlocking
          bne .Blocked

          ;2nd char
          iny
          iny
          lda (ZEROPAGE_POINTER_1),y
          jsr IsCharBlocking
          bne .Blocked

          ;3rd char?
          lda OBJECT_POS_X_DELTA,x
          beq .CanMove

          iny
          iny
          lda (ZEROPAGE_POINTER_1),y
          jsr IsCharBlocking
          beq .CanMove

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

          ;yes!
          jsr RemoveObject
          ;inc VIC.BORDER_COLOR
          ;jmp *

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
          lda OBJECT_CHAR_POS_X,x
          cmp BLOCK_BORDER_L
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

          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_OFFSET_HI,y
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

          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1

          ;current screen high
          lda SCREEN_LINE_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ldy OBJECT_CHAR_POS_X,x
          iny
          iny
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

          ldx #0
-
          lda OBJECT_ACTIVE,x
          beq ++

          txa
          asl
          tay

          lda OBJECT_SPRITE,x
          sta SPRITE_POINTER_BASE,y

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
          lda OBJECT_POS_Y,x
          sta VIC.SPRITE_Y_POS,y
++
          inx
          cpx #NUM_OBJECT_SLOTS
          bne -

          lda SHADOW_VIC_SPRITE_X_EXTEND
          sta VIC.SPRITE_X_EXTEND

          lda PLAYER_POWERED_UP
          beq +

          lda SPRITE_POINTER_BASE
          clc
          adc #SPRITE_PLAYER_RUN_R_1_EX - SPRITE_PLAYER_RUN_R_1
          sta SPRITE_POINTER_BASE

+

          rts





TYPE_START_SPRITE = * - 1
          !byte SPRITE_PLAYER_RUN_R_1
          !byte SPRITE_GOOMBA_1
          !byte SPRITE_PLAYER_FALL_R
          !byte SPRITE_GOOMBA_FLAT
          !byte SPRITE_EXTRA
          !byte SPRITE_DIAMOND
          !byte SPRITE_ELEVATOR_1
          !byte SPRITE_CRAB_L
          !byte SPRITE_PLAYER_SHOT
          !byte SPRITE_ELEVATOR_1 + 4

;0 = player
;xxxx xxx1 = enemy

;1 = jumpable enemy
;2 = deadly enemy
;3 = extra
;4 = platform
TYPE_ENEMY_TYPE = * - 1
          !byte 0     ;mario
          !byte 1     ;goomba
          !byte 0     ;player dying
          !byte 0     ;flat
          !byte 3     ;extra
          !byte 0     ;diamond
          !byte 4     ;elevator up
          !byte 1     ;crab
          !byte 0     ;player shot
          !byte 0     ;deco

TYPE_BEHAVIOUR_LO = * - 1
          !byte <BHPlayer
          !byte <BHGoomba
          !byte <BHPlayerDying
          !byte <BHFlat
          !byte <BHExtra
          !byte <BHDiamond
          !byte <BHElevator
          !byte <BHCrab
          !byte <BHPlayerShot
          !byte <BHNone

TYPE_BEHAVIOUR_HI = * - 1
          !byte >BHPlayer
          !byte >BHGoomba
          !byte >BHPlayerDying
          !byte >BHFlat
          !byte >BHExtra
          !byte >BHDiamond
          !byte >BHElevator
          !byte >BHCrab
          !byte >BHPlayerShot
          !byte >BHNone

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


TYPE_SPAWN_DELTA_X = * - 1
          !byte 0         ;player
          !byte 0         ;goomba
          !byte 0         ;player dying
          !byte 0         ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 4         ;elevator
          !byte 0         ;crab
          !byte 0         ;player shot
          !byte 4         ;deco

;offset added onto Y
TYPE_SPAWN_DELTA_Y = * - 1
          !byte 3         ;player
          !byte 1         ;goomba
          !byte 0         ;player dying
          !byte 0         ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 3         ;elevator
          !byte 0         ;crab
          !byte 0         ;player shot
          !byte 3         ;deco

FLATTENED_ENEMY_SPRITE = * - 1
          !byte 0   ;player
          !byte SPRITE_GOOMBA_FLAT
          !byte 0   ;player dying
          !byte 0   ;flat
          !byte 0         ;extra
          !byte 0         ;diamond
          !byte 0         ;elevator
          !byte SPRITE_CRAB_FLAT
          !byte 0         ;player shot
          !byte 0         ;deco

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
OBJECT_ANIM_DELAY
          !fill NUM_OBJECT_SLOTS,0
OBJECT_ANIM_POS
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

JUMP_STEPS_LEFT
          !byte 0

BLOCK_BORDER_L
          !byte 0
BLOCK_BORDER_R
          !byte 38

SCREEN_LINE_OFFSET_LO
!for SCREEN_ROW = 0 to 24
          !byte <( SCREEN_CHAR + SCREEN_ROW * 80 )
!end

SCREEN_LINE_OFFSET_HI
!for SCREEN_ROW = 0 to 24
          !byte >( SCREEN_CHAR + SCREEN_ROW * 80 )
!end


;0 = no powerup
;1 = headbutt
;2 = shot
;3 = bouncing shot
;4 = homing shot
;5 = clock
;6 = magic bomb
;7 = water drop
;8 = lollipop
PLAYER_POWERED_UP
          !byte 0

POWER_UP_SPRITE
          !byte SPRITE_EXTRA
          !byte SPRITE_EXTRA_FLASH

PLAYER_ENTERED_SECRET
          !byte 0

SECRET_SCREEN_ACTIVE
          !byte 0


SHADOW_VIC_SPRITE_X_EXTEND
          !byte 0

MOVING_DIR
          !byte 0