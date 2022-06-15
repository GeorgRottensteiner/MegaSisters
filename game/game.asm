NUM_LEVEL_ELEMENTS    = 9
NUM_DUST_ENTRIES      = 3

;first bonus stage
BONUS_STAGE_START = 34

!ifdef DISK {
TILE_DATA = $10000
}
FCM_CHARSET_FIRST_CHAR = ( TILE_DATA / 64 ) % 256

CHAR_DIAMOND_1        = FCM_CHARSET_FIRST_CHAR
CHAR_BRIDGE_1         = FCM_CHARSET_FIRST_CHAR + 109

CHAR_FIRST_BLOCKING   = FCM_CHARSET_FIRST_CHAR + 60
CHAR_EXIT             = FCM_CHARSET_FIRST_CHAR + 5
CHAR_LAST_BLOCKING    = FCM_CHARSET_FIRST_CHAR + 192

CHAR_FIRST_DEADLY     = FCM_CHARSET_FIRST_CHAR + 194

CHAR_0                = FCM_CHARSET_FIRST_CHAR + 234 + 0
CHAR_9                = FCM_CHARSET_FIRST_CHAR + 234 + 9

CHAR_STAR_1           = FCM_CHARSET_FIRST_CHAR + 82
CHAR_STAR_3           = FCM_CHARSET_FIRST_CHAR + 84

CHAR_BRICK_1          = FCM_CHARSET_FIRST_CHAR + 63
CHAR_BRICK_3          = FCM_CHARSET_FIRST_CHAR + 65

CHAR_EMPTY_BLOCK_1    = FCM_CHARSET_FIRST_CHAR + 103

CHAR_EMPTY            = FCM_CHARSET_FIRST_CHAR + 4

CHAR_DUST_1_1         = FCM_CHARSET_FIRST_CHAR + 46
CHAR_DUST_2_1         = FCM_CHARSET_FIRST_CHAR + 46 + 6

CHAR_SECRET_ENTRANCE  = FCM_CHARSET_FIRST_CHAR + 58

CHAR_WINDUP_COLUMN    = FCM_CHARSET_FIRST_CHAR + 129
CHAR_WATER_TOP_1      = FCM_CHARSET_FIRST_CHAR + 192
CHAR_WATER_TOP_2      = FCM_CHARSET_FIRST_CHAR + 193

CHAR_WARP             = FCM_CHARSET_FIRST_CHAR + 174

SCROLL_FIRST_ROW = 2

GUI_SCORE_OFFSET  = 41 + 1
GUI_BONUS_OFFSET  = 41 + 13
GUI_LIVES_OFFSET  = 41 + 20
GUI_STAGE_OFFSET  = 41 + 28
GUI_TIME_OFFSET   = 41 + 36

!zone Game
Game
          lda #80
          sta VIC4.CHARSTEP_LO

          lda #<ROW_SIZE_BYTES
          sta VIC4.CHARSTEP_LO
          lda #>ROW_SIZE_BYTES
          sta VIC4.CHARSTEP_HI

          lda #$01
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ;init global gameplay vars
          lda #CHAR_0
          sta STAGE
          sta COLLECTED_DIAMONDS
          sta COLLECTED_DIAMONDS + 1
          ;reset the score (facepalm)
          sta SCORE
          sta SCORE + 1
          sta SCORE + 2
          sta SCORE + 3
          sta SCORE + 4
          sta SCORE + 5

          lda #CHAR_0 + 1
          sta STAGE + 1


          lda #1
          ;lda #8
          sta LEVEL_NR
          lda #3
          sta PLAYER_LIVES
          lda #0
          sta SECRET_SCREEN_ACTIVE
          sta SECRET_STAGE_LEFT
          sta BONUS_COUNT

Respawn
          lda #0
          sta PLAYER_POWERED_UP
          sta GAME_FREEZE_DELAY
          sta PLAYER_IS_DEAD

!zone NextLevel
NextLevel
          lda #0
          sta REACHED_EXIT
          sta PLAYER_SHOT_ACTIVE
          sta SCROLL_SPEED
          sta SCROLL_SPEED_POS
          sta PLAYER_PLATFORM
          sta REACHED_WARP
          sta REACHED_WARP_DELAY

          jsr ClearAllObjects
          jsr GetReady

          jsr ScreenOff

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ldx #0
          ldy #0
-
          lda GUI_BAR,x
          sta SCREEN_CHAR + 2 * 41,y
          lda GUI_BAR + 40,x
          sta SCREEN_CHAR + ROW_SIZE_BYTES + 2 * 41,y

          iny
          iny
          inx
          cpx #40
          bne -

          lda LEVEL_NR
          jsr PrepareLevelDataPointer

          jsr SetupBackground

          ;find lowest possible place to stand
          ldy #24
          sty PARAM2
-
          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1
          ldy #5 * 2
          lda (ZEROPAGE_POINTER_1),y
          jsr IsCharBlocking
          beq .FoundStartHeight

          dec PARAM2
          ldy PARAM2
          jmp -

.FoundStartHeight
          lda #5
          sta PARAM1
          lda #TYPE_PLAYER
          sta PARAM3
          ldx #0
          jsr SpawnObjectInSlot

          ;init timer
          lda #CHAR_9
          sta SCREEN_CHAR + ROW_SIZE_BYTES + GUI_TIME_OFFSET * 2
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_TIME_OFFSET + 1 ) * 2
          sta TIME_VALUE_BCD
          sta TIME_VALUE_BCD + 1
          lda #0
          sta TIME_DELAY
          sta JUMP_STEPS_LEFT
          lda #99
          sta TIME_VALUE

          lda PLAYER_LIVES
          clc
          adc #CHAR_0
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_LIVES_OFFSET + 1 ) * 2

          lda STAGE
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_STAGE_OFFSET ) * 2
          lda STAGE + 1
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_STAGE_OFFSET + 1 ) * 2

          lda COLLECTED_DIAMONDS
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_BONUS_OFFSET ) * 2
          lda COLLECTED_DIAMONDS + 1
          sta SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_BONUS_OFFSET + 1 ) * 2

          ldx #0
          ldy #0
-
          lda SCORE,y
          sta SCREEN_CHAR + ROW_SIZE_BYTES + GUI_SCORE_OFFSET * 2,x

          inx
          inx
          iny
          cpy #6
          bne -

          lda #1
          sta IRQ_SCROLL_OFFSET_ACTIVE

          jsr ScreenOn
          ;fall through

!zone GameLoop
GameLoop
          lda #50 + SCROLL_FIRST_ROW * 8
          jsr WaitFrame

          lda PLAYER_IS_DEAD
          ora GAME_FREEZE_DELAY
          bne .NoTimerTick

          inc TIME_DELAY
          lda TIME_DELAY
          and #$1f
          bne ++

          lda TIME_VALUE
          bne +

          jsr PlayerKilled
          jmp ++

+
          dec TIME_VALUE

          ldx #1
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_TIME_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_TIME_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          jsr DecreaseValue

          lda SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_TIME_OFFSET + 0 ) * 2
          sta TIME_VALUE_BCD
          lda SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_TIME_OFFSET + 1 ) * 2
          sta TIME_VALUE_BCD + 1
++
.NoTimerTick

          lda #252
          jsr WaitFrame

          lda SECRET_STAGE_LEFT
          beq .NotLeavingSecretStage

          jmp LeaveSecretStage

.NotLeavingSecretStage

          lda PLAYER_ENTERED_SECRET
          beq .NoSecret

          ldy LEVEL_NR
          lda LEVEL_BONUS,y
          jmp EnterSecretScreen

.NoSecret
          lda REACHED_WARP
          beq .NoWarp

          inc REACHED_WARP_DELAY
          bne .NoWarp

          ;warp complete
          lda #1
          sta REACHED_EXIT

.NoWarp

          ;setup for top score bar
          ;lda #$07 ;#$01
          ;sta VIC4.VIC4DIS

          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          beq +

          lda #1
          sta BUTTON_RELEASED

+

          ;is the player at the right edge, scroll
          lda OBJECT_ACTIVE
          bne +

          ;player is dead
          lda JOY_VALUE
          and #JOY_FIRE
          bne .PlayerIsDead

          lda BUTTON_RELEASED
          beq .PlayerIsDead

          lda #0
          sta BUTTON_RELEASED

          jmp NextLive

+
          lda OBJECT_CHAR_POS_X
          cmp #26
          bcs .MustSpeedUp

          lda OBJECT_CHAR_POS_X
          cmp #20
          bcc +

          inc SCROLL_SPEEDUP_DELAY
          lda SCROLL_SPEEDUP_DELAY
          and #$03
          bne .SlowDown

.MustSpeedUp
          lda SCROLL_SPEED
          cmp #3
          beq .ScrollSpeedMaxed
          inc SCROLL_SPEED
.ScrollSpeedMaxed
          jmp .DoScroll

+
.PlayerIsDead
.SlowDown
          ;scroll speed slow down
          inc SCROLL_SLOWDOWN_DELAY
          lda SCROLL_SLOWDOWN_DELAY
          and #$03
          bne .DoScroll

          lda SCROLL_SPEED
          beq .DoScroll

          dec SCROLL_SPEED

.DoScroll
          lda SCROLL_SPEED
          beq +
          sta SCROLL_SPEED_POS

-
          jsr ScrollBy1Pixel
          dec SCROLL_SPEED_POS
          bne -

+

!ifdef CHEATS_ENABLED {
          lda Mega65.PRESSED_KEY
          beq .NoKey

          ldx #0
          stx Mega65.PRESSED_KEY

          ;cmp #'d'
          ;lbeq Debug

          cmp #'c'
          bne +

          ;jump to last proper level
          lda #BONUS_STAGE_START - 3
          jmp .Jump
+

          cmp #'s'
          bne +

          jsr ScrollBy1Pixel
          jmp GameLoop

+

          cmp #'b'
          bne +


          ;jump to last level (crystal)
          lda #BONUS_STAGE_START - 2
.Jump
          sta LEVEL_NR
          lda #1
          sta REACHED_EXIT
          jmp .NoKey

+
          cmp #'a'
          bne +

          lda #1
          sta REACHED_EXIT

+

.NoKey
}

          lda #0
          jsr WaitFrame

          lda #$50
          sta VIC4.TEXTXPOS

          lda GAME_FREEZE_DELAY
          beq .NoFreeze

          dec GAME_FREEZE_DELAY
          jmp .SkipObjectUpdate

.NoFreeze
          jsr ObjectControl
.SkipObjectUpdate
          jsr SetSpriteValues

          jsr AnimateChars
          jsr UpdateDust

          lda REACHED_EXIT
          beq +
          jmp BonusMode

+

          jmp GameLoop



!zone UpdateDust
UpdateDust
          ldx #0
          stx CURRENT_INDEX

-
          lda DUST_POS,x
          beq .NoDust

          inc DUST_POS_DELAY,x
          lda DUST_POS_DELAY,x
          cmp #3
          bne .NoDust

          lda #0
          sta DUST_POS_DELAY,x

          dec DUST_POS,x
          ldy DUST_Y,x
          lda SCREEN_LINE_COLLISION_OFFSET_LO,y
          sta ZEROPAGE_POINTER_2
          lda SCREEN_LINE_COLLISION_OFFSET_HI,y
          sta ZEROPAGE_POINTER_2 + 1

          ldy DUST_X,x
          lda DUST_POS,x
          tax
          cpy #0
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

          ;second line
          tya
          clc
          adc #( ROW_SIZE - 2 ) * 2
          tay
          cpy #ROW_SIZE_BYTES
          bcc .Skip3

          lda DUST_CHAR_4,x
          sta (ZEROPAGE_POINTER_2),y
.Skip3
          lda DUST_CHAR_5,x
          iny
          iny
          cpy #ROW_SIZE_BYTES
          bcc .Skip4
          sta (ZEROPAGE_POINTER_2),y

.Skip4
          lda DUST_CHAR_6,x
          iny
          iny
          sta (ZEROPAGE_POINTER_2),y

.NoDust
          inc CURRENT_INDEX
          ldx CURRENT_INDEX
          cpx #NUM_DUST_ENTRIES
          bne -

          rts


DUST_CHAR_1
          !byte CHAR_EMPTY, CHAR_DUST_2_1,     CHAR_DUST_1_1,     CHAR_EMPTY_BLOCK_1
DUST_CHAR_2
          !byte CHAR_EMPTY, CHAR_DUST_2_1 + 1, CHAR_DUST_1_1 + 1, CHAR_EMPTY_BLOCK_1 + 1
DUST_CHAR_3
          !byte CHAR_EMPTY, CHAR_DUST_2_1 + 2, CHAR_DUST_1_1 + 2, CHAR_EMPTY_BLOCK_1 + 2
DUST_CHAR_4
          !byte CHAR_EMPTY, CHAR_DUST_2_1 + 3, CHAR_DUST_1_1 + 3, CHAR_EMPTY_BLOCK_1 + 3
DUST_CHAR_5
          !byte CHAR_EMPTY, CHAR_DUST_2_1 + 4, CHAR_DUST_1_1 + 4, CHAR_EMPTY_BLOCK_1 + 4
DUST_CHAR_6
          !byte CHAR_EMPTY, CHAR_DUST_2_1 + 5, CHAR_DUST_1_1 + 5, CHAR_EMPTY_BLOCK_1 + 5


!zone ScrollBy1Pixel
ScrollBy1Pixel
          lda LEVEL_WIDTH
          ora LEVEL_WIDTH + 1
          bne .NeedToScroll

          rts

.NeedToScroll

          ;fix GOTOX offsets for upper layer
          lda SCROLL_POS
          dec
          and #$07
          sta LOCAL1

          ldx #2
-
          lda SCREEN_LINE_OFFSET_LO, x
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_HI, x
          sta ZEROPAGE_POINTER_1 + 1

          ;offset 0 so it starts at the left border
          ldy #80
          lda LOCAL1
          sta (ZEROPAGE_POINTER_1),y

          inx
          cpx #25
          bne -

          dec SCROLL_POS
          bpl .NoHardScroll

          lda SCROLL_POS
          and #$07
          sta SCROLL_POS

          ;move objects left by 8 pixel
          ldx #0
-
          lda OBJECT_ACTIVE,x
          beq +

          ldz #8
--
          jsr ObjectMoveLeft
          dez
          bne --

+

          inx
          cpx #8
          bne -

          lda LEVEL_WIDTH
          sec
          sbc #1
          sta LEVEL_WIDTH
          lda LEVEL_WIDTH + 1
          sbc #0
          sta LEVEL_WIDTH + 1

          ;move dust
          ldx #0
          stx CURRENT_INDEX

-
          lda DUST_POS,x
          beq .NoDust

          dec DUST_X,x
          dec DUST_X,x
          lda DUST_X,x
          cmp #256 - 6
          bne .NoDust

          ;dust is outside
          lda #0
          sta DUST_POS,x

.NoDust
          inx
          cpx #NUM_DUST_ENTRIES
          bne -

          jmp HardScroll

.NoHardScroll
          rts



!zone HardScroll
HardScroll
          ldx #0
-

!for SCREEN_ROW = SCROLL_FIRST_ROW to 24
          lda SCREEN_CHAR + 41 * 2 + 2 + SCREEN_ROW * ROW_SIZE_BYTES,x
          sta SCREEN_CHAR + 41 * 2 + 0 + SCREEN_ROW * ROW_SIZE_BYTES,x
!end
          inx
          inx
          cpx #78
          lbne -

          ;empty rightmost column
!for SCREEN_ROW = SCROLL_FIRST_ROW to 24
          lda #CHAR_EMPTY
          sta SCREEN_CHAR + ( ROW_SIZE_BYTES - 6 ) + SCREEN_ROW * ROW_SIZE_BYTES
!end

          ;check for new elements?
          lda CURRENT_MAP_LINE_OFFSET_TO_NEXT_ELEMENT
          beq .CheckForNewElements

          dec CURRENT_MAP_LINE_OFFSET_TO_NEXT_ELEMENT
          beq .CheckForNewElements
          jmp .SkipCheck


.CheckForNewElements
          lda CURRENT_MAP_DATA_POS
          sta ZEROPAGE_POINTER_1
          lda CURRENT_MAP_DATA_POS + 1
          sta ZEROPAGE_POINTER_1 + 1

.NextLevelDataElement
          ldy #0

          lda (ZEROPAGE_POINTER_1),y
          sta PARAM1
          and #$e0
          beq .YOffset
          cmp #LDF_ELEMENT
          lbeq .StartNewElement
          cmp #LDF_PREV_ELEMENT
          beq .StartPreviousElement
          cmp #LDF_ELEMENT_LINE
          beq .StartNewElementLine
          cmp #LDF_PREV_ELEMENT_LINE
          beq .StartPreviousElementLine
          cmp #LDF_ELEMENT_AREA
          beq .StartNewElementArea
          cmp #LD_OBJECT
          lbeq .SpawnObject
          ;end
          jmp .EndOfLevelData

.StartPreviousElement
          ;x pos
          lda PARAM1
          and #$1f
          sta PARAM1

          lda #1
          sta PARAM4
          sta PARAM5

          lda LEVEL_PREVIOUS_ELEMENT
          sta PARAM3
          jmp .AddElement


.YOffset
          lda PARAM1
          sta CURRENT_MAP_LINE_OFFSET_TO_NEXT_ELEMENT

          inc CURRENT_MAP_DATA_POS
          bne +
          inc CURRENT_MAP_DATA_POS + 1
+
          jmp .LevelDataProcessed

.StartNewElementLine
          ;x pos
          lda PARAM1
          and #$1f
          sta PARAM1

          ;count
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM4

          ;count #2
          lda #1
          sta PARAM5

          ;element
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM3
          sta LEVEL_PREVIOUS_ELEMENT

          jmp .AddElement

.StartPreviousElementLine
          ;x pos
          lda PARAM1
          and #$1f
          sta PARAM1

          ;count
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM4

          ;count #2
          lda #1
          sta PARAM5

          ;element
          lda LEVEL_PREVIOUS_ELEMENT
          sta PARAM3

          jmp .AddElement

.StartNewElementArea
          ;y pos, count x, count y (MSB of count y set means previous element)
          lda PARAM1
          and #$1f
          sta PARAM1

          ;count 1
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM4

          ;count 2
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM5
          bpl +
          and #$7f
          sta PARAM5

          lda LEVEL_PREVIOUS_ELEMENT
          sta PARAM3
          jmp .AddElement

+

          ;element
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM3
          sta LEVEL_PREVIOUS_ELEMENT

          jmp .AddElement

.SpawnObject
          ;an object
          lda PARAM1
          and #$1f
          clc
          adc #1
          sta PARAM3

          lda #39
          sta PARAM1

          ;y pos
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM2

          ;add y + 1
          tya
          sec
          adc ZEROPAGE_POINTER_1
          sta ZEROPAGE_POINTER_1
          sta CURRENT_MAP_DATA_POS
          bcc +
          inc ZEROPAGE_POINTER_1 + 1
          inc CURRENT_MAP_DATA_POS + 1
+

          lda PARAM3
          cmp #TYPE_DRAGON
          bne +


          ;force dragon at slot 1
          ldx #1
          jsr SpawnObjectInSlot

          lda #<SPRITE_DRAGON
          sta OBJECT_SPRITE,x

          ;spawn the other 2 parts
          lda #41
          sta PARAM1
          lda #TYPE_DEADLY_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_DRAGON + 1 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_DRAGON + 1 * 3 )
          sta OBJECT_SPRITE_HI,x

          lda #43
          sta PARAM1
          lda #TYPE_DEADLY_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_DRAGON + 2 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_DRAGON + 2 * 3 )
          sta OBJECT_SPRITE_HI,x

          lda #45
          sta PARAM1
          lda #TYPE_DEADLY_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_DRAGON + 3 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_DRAGON + 3 * 3 )
          sta OBJECT_SPRITE_HI,x

          lda #47
          sta PARAM1
          lda #TYPE_DEADLY_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_DRAGON + 4 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_DRAGON + 4 * 3 )
          sta OBJECT_SPRITE_HI,x

          txa
          sec
          sbc #4
          sta OBJECT_MAIN_INDEX,x
          sta OBJECT_MAIN_INDEX - 1,x
          sta OBJECT_MAIN_INDEX - 2,x
          sta OBJECT_MAIN_INDEX - 3,x

          jmp .NextLevelDataElement


+
          cmp #TYPE_CRYSTAL
          bne +

          ;force at slot 6
          ldx #6
          jsr SpawnObjectInSlot

          lda #<SPRITE_CRYSTAL
          sta OBJECT_SPRITE,x

          ;spawn the other part
          inc PARAM2
          inc PARAM2
          inc PARAM2
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_CRYSTAL + 1 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_CRYSTAL + 1 * 3 )
          sta OBJECT_SPRITE_HI,x

          jsr ObjectMoveUp
          jsr ObjectMoveUp
          jsr ObjectMoveUp

          txa
          dec
          sta OBJECT_MAIN_INDEX,x

          jmp .NextLevelDataElement

+

          cmp #TYPE_ANT
          bne +

          ;force ant at slot 1
          ldx #1
          jsr SpawnObjectInSlot

          lda #<SPRITE_ANT
          sta OBJECT_SPRITE,x

          ;spawn the other 2 parts
          lda #41
          sta PARAM1
          lda #TYPE_DEADLY_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_ANT + 1 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_ANT + 1 * 3 )
          sta OBJECT_SPRITE_HI,x

          lda #43
          sta PARAM1
          lda #TYPE_DEADLY_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda #<( SPRITE_ANT + 2 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_ANT + 2 * 3 )
          sta OBJECT_SPRITE_HI,x

          txa
          sec
          sbc #2
          sta OBJECT_MAIN_INDEX,x
          sta OBJECT_MAIN_INDEX - 1,x

          jmp .NextLevelDataElement

+
          cmp #TYPE_ELEVATOR_UP
          bne +

          ;force elevator at slot 1
          ldx #1
          jsr SpawnObjectInSlot

          ;spawn the other 3 parts
          lda #41
          sta PARAM1
          lda #TYPE_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda OBJECT_SPRITE_HI - 1,x
          sta OBJECT_SPRITE_HI,x

          lda #43
          sta PARAM1
          lda #TYPE_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot
          lda OBJECT_SPRITE_HI - 1,x
          sta OBJECT_SPRITE_HI,x

          lda #45
          sta PARAM1
          lda #TYPE_DECO
          sta PARAM3
          inx
          jsr SpawnObjectInSlot

          lda #<( SPRITE_ELEVATOR_1 + 2 * 3 )
          sta OBJECT_SPRITE,x
          lda #>( SPRITE_ELEVATOR_1 + 2 * 3 )
          sta OBJECT_SPRITE_HI,x
          jmp .NextLevelDataElement

+

          ldx #1
          jsr SpawnObjectStartingWithSlot


          jmp .NextLevelDataElement


.StartNewElement
          ;x pos
          lda PARAM1
          and #$1f
          sta PARAM1

          lda #1
          sta PARAM4
          sta PARAM5

          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM3
          sta LEVEL_PREVIOUS_ELEMENT

.AddElement
          ;find element slot
          ldx #0
-
          lda LEVEL_ELEMENT_WIDTH,x
          bne .SlotFull

          ;add y + 1
          tya
          sec
          adc ZEROPAGE_POINTER_1
          sta ZEROPAGE_POINTER_1
          sta CURRENT_MAP_DATA_POS
          bcc +
          inc ZEROPAGE_POINTER_1 + 1
          inc CURRENT_MAP_DATA_POS + 1
+

          ;a free slot
          ldy PARAM3
          lda ELEMENT_TABLE_LO,y
          sta LEVEL_ELEMENT_POS_LO,x
          sta LEVEL_ELEMENT_ORIG_POS_LO,x
          lda ELEMENT_TABLE_HI,y
          sta LEVEL_ELEMENT_POS_HI,x
          sta LEVEL_ELEMENT_ORIG_POS_HI,x
          lda ELEMENT_WIDTH_TABLE,y
          sta LEVEL_ELEMENT_WIDTH,x
          sta LEVEL_ELEMENT_ORIG_WIDTH,x
          lda ELEMENT_HEIGHT_TABLE,y
          sta LEVEL_ELEMENT_HEIGHT,x
          lda PARAM1
          sta LEVEL_ELEMENT_POS_Y,x
          lda PARAM4
          sta LEVEL_ELEMENT_RETRIES,x
          lda PARAM5
          sta LEVEL_ELEMENT_RETRIES_V,x

          jmp .ElementAdded

.SlotFull
          inx
          cpx #NUM_LEVEL_ELEMENTS
          bne -

          ;not enough element slots!!
-
          inc VIC.BORDER_COLOR
          jmp -

.ElementAdded

          jmp .NextLevelDataElement


.EndOfLevelData
.SkipCheck
.LevelDataProcessed

          ;draw element
          ldx #0
-
          lda LEVEL_ELEMENT_WIDTH,x
          beq .SkipElement


          lda LEVEL_ELEMENT_RETRIES_V,x
          sta PARAM3

          ldy LEVEL_ELEMENT_POS_Y,x

.ElementVerticalRedraw
          lda LEVEL_ELEMENT_HEIGHT,x
          sta PARAM2

          lda LEVEL_ELEMENT_POS_LO,x
          sta .ReadPos
          lda LEVEL_ELEMENT_POS_HI,x
          sta .ReadPos + 1

--
          lda SCREEN_COLUMN_POS_LO,y
          sta .WritePos
          lda SCREEN_COLUMN_POS_HI,y
          sta .WritePos + 1

.ReadPos = * + 1
          lda $ffff
.WritePos = * + 1
          sta $ffff

          inc .ReadPos
          bne +
          inc .ReadPos + 1
+
          iny
          dec PARAM2
          bne --

          dec PARAM3
          bne .ElementVerticalRedraw

          lda .ReadPos
          sta LEVEL_ELEMENT_POS_LO,x
          lda .ReadPos + 1
          sta LEVEL_ELEMENT_POS_HI,x

          dec LEVEL_ELEMENT_WIDTH,x
          bne .SkipElement

          ;retries?
          lda LEVEL_ELEMENT_RETRIES,x
          beq .SkipElement

          dec LEVEL_ELEMENT_RETRIES,x
          beq .SkipElement

          lda LEVEL_ELEMENT_ORIG_WIDTH,x
          sta LEVEL_ELEMENT_WIDTH,x
          lda LEVEL_ELEMENT_ORIG_POS_LO,x
          sta LEVEL_ELEMENT_POS_LO,x
          lda LEVEL_ELEMENT_ORIG_POS_HI,x
          sta LEVEL_ELEMENT_POS_HI,x

.SkipElement
          inx
          cpx #NUM_LEVEL_ELEMENTS
          bne -

          ;dec VIC.BORDER_COLOR
          rts


!zone AnimateChars
AnimateChars
          inc TILE_ANIMATION_DELAY
          lda TILE_ANIMATION_DELAY
          and #$03
          lbne +

          inc TILE_ANIMATION_POS
          lda TILE_ANIMATION_POS
          and #$03
          tay

          lda #<TILE_DATA
          sta ZEROPAGE_POINTER_QUAD_1
          lda #( TILE_DATA >> 8 ) & 0xff
          sta ZEROPAGE_POINTER_QUAD_1 + 1
          lda #( TILE_DATA >> 16 ) & 0xff
          sta ZEROPAGE_POINTER_QUAD_1 + 2
          sta ZEROPAGE_POINTER_QUAD_2 + 2
          lda #0
          sta ZEROPAGE_POINTER_QUAD_1 + 3
          sta ZEROPAGE_POINTER_QUAD_2 + 3

          lda TILE_ANIMATION_TABLE_LO,y
          clc
          adc #<ANIMATED_TILE_DATA
          sta .ReadPos
          sta .ReadPosB
          lda TILE_ANIMATION_TABLE_HI,y
          adc #>ANIMATED_TILE_DATA
          sta .ReadPos + 1
          sta .ReadPosB + 1

          lda .ReadPos
          clc
          adc #<( 3 * 64 )
          sta .ReadPos2
          lda .ReadPos + 1
          adc #>( 3 * 64 )
          sta .ReadPos2 + 1

          ldz #0
          ldx #0

          lda #<( ( TILE_DATA & $ffff ) + ( CHAR_STAR_1 - 3 ) * 64 )
          sta ZEROPAGE_POINTER_QUAD_1
          lda #>( ( TILE_DATA & $ffff ) + ( CHAR_STAR_1 - 3 ) * 64 )
          sta ZEROPAGE_POINTER_QUAD_1 + 1

-
.ReadPos = * + 1
          lda $ffff,x
          sta [ZEROPAGE_POINTER_QUAD_1],z
          inx
          inz
          cpz #3 * 64
          bne -

          ldz #0
          ldx #0

          lda #<( ( TILE_DATA & $ffff ) + ( CHAR_STAR_1 - 3 ) * 64 + 3 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1
          lda #>( ( TILE_DATA & $ffff ) + ( CHAR_STAR_1 - 3 ) * 64 + 3 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1 + 1

-
.ReadPos2 = * + 1
          lda $ffff,x
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inx
          inz
          cpz #3 * 64
          bne -

          ;upper right char of powerup star
          ldx #2 * 64
          ldz #2 * 64

          lda #<( ( TILE_DATA & $ffff ) + 125 * 64 - 2 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1
          lda #>( ( TILE_DATA & $ffff ) + 125 * 64 - 2 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1 + 1


-
.ReadPosB = * + 1
          lda $ffff,x
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inz
          inx
          cpx #2 * 64 + 64
          bne -

          ;windup column
          lda #2
          sta PARAM1

--
          lda PARAM1
          asl
          asl
          asl
          asl
          asl
          asl
          pha
          clc
          adc #<( ( TILE_DATA & $ffff ) + CHAR_WINDUP_COLUMN * 64 )
          sta ZEROPAGE_POINTER_QUAD_1
          lda #>( ( TILE_DATA & $ffff ) + CHAR_WINDUP_COLUMN * 64 )
          adc #0
          sta ZEROPAGE_POINTER_QUAD_1 + 1

          pla
          clc
          adc #<( ( TILE_DATA & $ffff ) + CHAR_WINDUP_COLUMN * 64 + 8 )
          sta ZEROPAGE_POINTER_QUAD_2
          lda #>( ( TILE_DATA & $ffff ) + CHAR_WINDUP_COLUMN * 64 + 8 )
          adc #0
          sta ZEROPAGE_POINTER_QUAD_2 + 1

          ldx #0
          ldz #0
-
          lda [ZEROPAGE_POINTER_QUAD_1],z
          sta .TILE_DATA_TEMP,x

          inx
          inz
          cpz #8
          bne  -

          ldz #0
-
          lda [ZEROPAGE_POINTER_QUAD_2],z
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inz
          cpz #7 * 8
          bne  -

          ldx #0
-
          lda .TILE_DATA_TEMP,x
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inx
          inz
          cpz #8 * 8
          bne  -

          dec PARAM1
          bpl --

          ;water
          lda TILE_ANIMATION_POS
          and #$07
          lsr
          asl
          asl
          asl
          asl
          asl
          asl
          tay

          ldx #0
          ldz #0

          lda #<( ( TILE_DATA & $ffff ) + CHAR_WATER_TOP_1 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1
          lda #>( ( TILE_DATA & $ffff ) + CHAR_WATER_TOP_1 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1 + 1

-
          lda ANIMATED_TILE_DATA + 18 * 64,y
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inz
          iny
          cpz #64
          bne -

          lda TILE_ANIMATION_POS
          lsr
          clc
          adc #2
          and #$03
          asl
          asl
          asl
          asl
          asl
          asl
          tay

          ldz #0
          lda #<( ( TILE_DATA & $ffff ) + CHAR_WATER_TOP_2 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1
          lda #>( ( TILE_DATA & $ffff ) + CHAR_WATER_TOP_2 * 64 )
          sta ZEROPAGE_POINTER_QUAD_1 + 1

-
          lda ANIMATED_TILE_DATA + 18 * 64,y
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inz
          iny
          cpz #64
          bne -

+

          rts

.TILE_DATA_TEMP
          !fill 8



!zone NextLive
NextLive
          dec PLAYER_LIVES

          ldx #1
          lda #<( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_LIVES_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + ROW_SIZE_BYTES + 2 * GUI_LIVES_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1
          jsr DecreaseValue


          lda PLAYER_LIVES
          bne .Respawn

          jmp GameOver

.Respawn
          ;if in secret stage respawn in parent stage
          lda SECRET_SCREEN_ACTIVE
          beq .RegularStage

          lda CURRENT_LEVEL_NR
          sta LEVEL_NR

.RegularStage
          ;store bonus and score for respawn
          ldx #0
          ldy #0
-
          lda SCREEN_CHAR + ROW_SIZE_BYTES + GUI_SCORE_OFFSET * 2,x
          sta SCORE,y

          inx
          inx
          iny
          cpy #6
          bne -


          lda SCREEN_CHAR + ROW_SIZE_BYTES + GUI_BONUS_OFFSET * 2
          sta COLLECTED_DIAMONDS
          lda SCREEN_CHAR + ROW_SIZE_BYTES + ( GUI_BONUS_OFFSET + 1 ) * 2
          sta COLLECTED_DIAMONDS + 1

          jmp Respawn


!zone PrepareLevelDataPointer
;a = level nr
PrepareLevelDataPointer
          jsr PrepareLevelDataPointerNoStartScroll

          ;init first part of level
          lda #40
          sta PARAM6
.NextScroll
          jsr HardScroll


          ;move objects left by 8 pixel
          ldx #0
-
          lda OBJECT_ACTIVE,x
          beq +

          ldz #8
--
          jsr ObjectMoveLeft
          dez
          bne --

+
          inx
          cpx #8
          bne -

          dec PARAM6
          bne .NextScroll

          rts



!zone PrepareLevelDataPointerNoStartScroll
;a = level nr
PrepareLevelDataPointerNoStartScroll
          sta LEVEL_NR

          jsr ClearAllObjects

          lda LEVEL_NR
          asl
          tay
          lda _SCREEN_DATA_TABLE,y
          sta CURRENT_MAP_DATA_POS
          sta ZEROPAGE_POINTER_1
          lda _SCREEN_DATA_TABLE + 1,y
          sta CURRENT_MAP_DATA_POS + 1
          sta ZEROPAGE_POINTER_1 + 1

          ldy #0
          lda (ZEROPAGE_POINTER_1),y
          sec
          sbc #40
          sta LEVEL_WIDTH
          iny
          lda (ZEROPAGE_POINTER_1),y
          sbc #0
          sta LEVEL_WIDTH + 1

          iny
          lda (ZEROPAGE_POINTER_1),y
          sta LEVEL_CONFIG

          lda CURRENT_MAP_DATA_POS
          clc
          adc #3
          sta CURRENT_MAP_DATA_POS
          bcc +
          inc CURRENT_MAP_DATA_POS + 1
+

          ;reset element slots
          ldx #0
          stx CURRENT_MAP_LINE_OFFSET_TO_NEXT_ELEMENT
          txa
-
          sta LEVEL_ELEMENT_WIDTH,x
          inx
          cpx #NUM_LEVEL_ELEMENTS
          bne -

          ;screen setup
          lda LEVEL_CONFIG
          and #$07
          tay
          lda LEVEL_BACKGROUND_COLOR_INDEX,y
          sta VIC.BACKGROUND_COLOR

          ldx #0

          lda #0
-
          sta DUST_POS,x
          inx
          cpx #NUM_DUST_ENTRIES
          bne -

          rts



!zone EnterSecretScreen
;a = level nr of secret
EnterSecretScreen
          sta LOCAL1

          ;backup current screen position
          lda OBJECT_CHAR_POS_X
          sta CURRENT_PLAYER_X_POS
          lda LEVEL_NR
          sta CURRENT_LEVEL_NR
          lda LEVEL_WIDTH
          sta OUTER_LEVEL_CURRENT_WIDTH
          lda LEVEL_WIDTH + 1
          sta OUTER_LEVEL_CURRENT_WIDTH + 1

          lda LOCAL1
          jsr PrepareLevelDataPointer

          jsr SetupBackground

          lda #5
          sta PARAM1
          lda #2
          sta PARAM2
          lda #TYPE_PLAYER
          sta PARAM3
          ldx #0
          jsr SpawnObjectInSlot

          lda #0
          sta REACHED_EXIT
          sta PLAYER_IS_DEAD
          sta SCROLL_SPEED
          sta SCROLL_SPEED_POS
          sta SCROLL_SLOWDOWN_DELAY
          sta SCROLL_SPEEDUP_DELAY
          sta PLAYER_ENTERED_SECRET
          sta SECRET_STAGE_LEFT

          lda #1
          sta SECRET_SCREEN_ACTIVE

          jmp GameLoop



!zone LeaveSecretStage
LeaveSecretStage
          jsr ScreenOff

          lda CURRENT_LEVEL_NR
          sta LEVEL_NR
          jsr PrepareLevelDataPointer

          jsr SetupBackground

-
          jsr HardScroll

          lda LEVEL_WIDTH
          sec
          sbc #1
          sta LEVEL_WIDTH
          lda LEVEL_WIDTH + 1
          sbc #0
          sta LEVEL_WIDTH + 1

          lda OUTER_LEVEL_CURRENT_WIDTH
          cmp LEVEL_WIDTH
          bne -

          lda OUTER_LEVEL_CURRENT_WIDTH + 1
          cmp LEVEL_WIDTH + 1
          bne -

          ;replace secret stage entry with bridge
          lda SCREEN_LINE_COLLISION_OFFSET_LO + 24
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_COLLISION_OFFSET_HI + 24
          sta ZEROPAGE_POINTER_1 + 1

          lda #CHAR_BRIDGE_1
          sta PARAM1
          ldy #0
-
          lda (ZEROPAGE_POINTER_1),y
          cmp #CHAR_SECRET_ENTRANCE
          bne +

          lda PARAM1
          eor #CHAR_BRIDGE_1 xor ( CHAR_BRIDGE_1 + 1 )
          sta PARAM1
          sta (ZEROPAGE_POINTER_1),y

+
          iny
          iny
          cpy #39 * 2
          bne -

          jsr ClearAllObjects


          lda CURRENT_PLAYER_X_POS
          sta PARAM1
          lda #20
          sta PARAM2
          lda #TYPE_PLAYER
          sta PARAM3
          ldx #0
          jsr SpawnObjectInSlot

          lda #0
          sta OBJECT_ANIM_DELAY
          sta OBJECT_ANIM_POS
          lda #1
          sta OBJECT_JUMP_POS
          lda #OF_JUMPING
          sta OBJECT_FLAGS

          lda #20
          sta JUMP_STEPS_LEFT


          lda #0
          sta REACHED_EXIT
          sta PLAYER_IS_DEAD
          sta SCROLL_SPEED
          sta SCROLL_SPEED_POS
          sta SCROLL_SLOWDOWN_DELAY
          sta SCROLL_SPEEDUP_DELAY
          sta PLAYER_ENTERED_SECRET
          sta SECRET_STAGE_LEFT
          sta SECRET_SCREEN_ACTIVE
          sta PLAYER_ON_ELEVATOR

          jsr ScreenOn

          jmp GameLoop



SCROLL_POS
          !byte 0



LEVEL_ELEMENT_WIDTH
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_ORIG_WIDTH
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_HEIGHT
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_RETRIES
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_RETRIES_V
          !fill NUM_LEVEL_ELEMENTS

LEVEL_ELEMENT_POS_Y
          !fill NUM_LEVEL_ELEMENTS

LEVEL_ELEMENT_POS_LO
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_POS_HI
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_ORIG_POS_LO
          !fill NUM_LEVEL_ELEMENTS
LEVEL_ELEMENT_ORIG_POS_HI
          !fill NUM_LEVEL_ELEMENTS



SCREEN_COLUMN_POS_LO
!for SCREEN_ROW = 0 to 24
          !byte <( SCREEN_CHAR + SCREEN_ROW * ROW_SIZE_BYTES + ROW_SIZE_BYTES - 6 )
!end

SCREEN_COLUMN_POS_HI
!for SCREEN_ROW = 0 to 24
          !byte >( SCREEN_CHAR + SCREEN_ROW * ROW_SIZE_BYTES + ROW_SIZE_BYTES - 6 )
!end


CURRENT_MAP_LINE_OFFSET_TO_NEXT_ELEMENT
          !byte 0

;position in current stage data
CURRENT_MAP_DATA_POS
          !word 0

LEVEL_PREVIOUS_ELEMENT
          !byte 0

JOY_VALUE
          !byte 0

SCROLL_SPEED
          !byte 0

SCROLL_SPEED_POS
          !byte 0

SCROLL_SLOWDOWN_DELAY
          !byte 0

SCROLL_SPEEDUP_DELAY
          !byte 0

TILE_ANIMATION_DELAY
          !byte 0

TILE_ANIMATION_POS
          !byte 0

TILE_ANIMATION_TABLE_LO
          !byte 0, <( 1 * 6 * 64 ), <( 2 * 6 * 64 ), <( 1 * 6 * 64 )

TILE_ANIMATION_TABLE_HI
          !byte 0, >( 1 * 6 * 64 ), >( 2 * 6 * 64 ), >( 1 * 6 * 64 )

;number of characters left in the current stage
LEVEL_WIDTH
          !word 0

TIME_DELAY
          !byte 0

REACHED_EXIT
          !byte 0

REACHED_WARP
          !byte 0

REACHED_WARP_DELAY
          !byte 0

SECRET_STAGE_LEFT
          !byte 0

TIME_VALUE
          !byte 0

TIME_VALUE_BCD
          !byte 0,0

SCORE
          !fill 6,CHAR_0

STAGE
          !byte 0,0

;bonus count display digits
COLLECTED_DIAMONDS
          !byte 0,0

;actual bonus count
BONUS_COUNT
          !byte 0

PLAYER_IS_DEAD
          !byte 0

PLAYER_LIVES
          !byte 0

PLAYER_ON_ELEVATOR
          !byte 0

PLAYER_SHOT_ACTIVE
          !byte 0

LEVEL_NR
          !byte 0

;xxxx x111 = level type (00 = overworld, 01 = underground, 02 = water lands, 03 = castle, 04 = bonus)
LEVEL_CONFIG
          !byte 0

BUTTON_RELEASED
          !byte 0


LEVEL_BACKGROUND_COLOR_INDEX
          !byte 41     ;overworld
          !byte 56     ;underground
          !byte 41     ;water lands
          !byte 56     ;castle
          !byte 56     ;bonus

; 2 = first, 1 = second, 0 = done
DUST_POS
          !fill NUM_DUST_ENTRIES
DUST_POS_DELAY
          !fill NUM_DUST_ENTRIES

DUST_X
          !fill NUM_DUST_ENTRIES

DUST_Y
          !fill NUM_DUST_ENTRIES

GAME_FREEZE_DELAY
          !byte 0

CURRENT_PLAYER_X_POS
          !byte 0
CURRENT_LEVEL_NR
          !byte 0
OUTER_LEVEL_CURRENT_WIDTH
          !word 0

;map from level no to bonus map
LEVEL_BONUS
          !byte 0 ;title
          !byte BONUS_STAGE_START
          !byte 0
          !byte 0
          !byte 0
          !byte BONUS_STAGE_START + 1
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte BONUS_STAGE_START + 2   ;12
          !byte 0
          !byte BONUS_STAGE_START + 3   ;14
          !byte 0
          !byte 0
          !byte BONUS_STAGE_START + 4   ;17
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte BONUS_STAGE_START + 5   ;22
          !byte 0
          !byte 0
          !byte BONUS_STAGE_START + 6   ;25
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte 0
          !byte BONUS_STAGE_START + 7   ;32
