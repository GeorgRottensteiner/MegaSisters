BONUS_SCORE_OFFSET = 26
BONUS_TIME_OFFSET = 9

!zone BonusMode
BonusMode
          lda #252
          jsr WaitFrame

          ldx #0
          ldy #0
-
          lda SCREEN_CHAR + 80 + GUI_SCORE_OFFSET * 2,x
          sta SCORE,y

          inx
          inx
          iny
          cpy #6
          bne -


          lda SCREEN_CHAR + 80 + GUI_BONUS_OFFSET * 2
          sta COLLECTED_DIAMONDS
          lda SCREEN_CHAR + 80 + ( GUI_BONUS_OFFSET + 1 ) * 2
          sta COLLECTED_DIAMONDS + 1

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.BACKGROUND_COLOR

          lda #$50 - 8
          ;clc
          ;adc PARAM1
          ;$50-scroll(0-15)
          sta VIC4.TEXTXPOS

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ldx #0
          ldy #0
-
          lda GUI_BAR + 80,x
          sta SCREEN_CHAR + 11 * 80,y

          iny
          iny
          inx
          cpx #120
          bne -

          lda TIME_VALUE_BCD
          sta SCREEN_CHAR + 13 * 80 + BONUS_TIME_OFFSET * 2
          lda TIME_VALUE_BCD + 1
          sta SCREEN_CHAR + 13 * 80 + ( BONUS_TIME_OFFSET + 1 ) * 2

          ldx #0
          ldy #0
-
          lda SCORE,y
          sta SCREEN_CHAR + 13 * 80 + 2 * BONUS_SCORE_OFFSET,x

          inx
          inx
          iny
          cpy #6
          bne -

          lda #2
          sta BONUS_TICK_DELAY

          lda #120
          sta BONUS_READY_DELAY


!zone BonusLoop
BonusLoop
          lda #252
          jsr WaitFrame

          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          bne .NoAbort

          lda BUTTON_RELEASED
          beq .ButtonNotReleased


          lda TIME_VALUE
          beq .BonusDone

-
          jsr BonusTick
          lda TIME_VALUE
          bne -

          lda #0
          sta BUTTON_RELEASED
          jmp BonusLoop

.NoAbort
          lda #1
          sta BUTTON_RELEASED
.ButtonNotReleased
          dec BONUS_TICK_DELAY
          bne BonusLoop

          lda #2
          sta BONUS_TICK_DELAY

          lda TIME_VALUE
          bne ++

          dec BONUS_READY_DELAY
          bne +

.BonusDone
          lda #0
          sta BUTTON_RELEASED

          inc STAGE + 1
          lda STAGE + 1
          cmp #CHAR_9 + 1
          bne .Overflow

          lda #CHAR_0
          sta STAGE + 1
          inc STAGE
.Overflow

          ;copy score
          ldx #0
          ldy #0
-
          lda SCREEN_CHAR + 13 * 80 + 2 * BONUS_SCORE_OFFSET,x
          sta SCORE,y

          inx
          inx
          iny
          cpy #6
          bne -


          lda LEVEL_NR
          cmp #BONUS_STAGE_START - 1
          bne .NotCompleted

          jmp CompletedGame

.NotCompleted
          inc LEVEL_NR
          jmp NextLevel

++
          jsr BonusTick


+
          jmp BonusLoop



!zone BonusTick
BonusTick
          dec TIME_VALUE

          ldy #SFX_BONUS_BLIP
          jsr PlaySoundEffect

          ldx #4
          lda #<( SCREEN_CHAR + 13 * 80 + 2 * BONUS_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + 13 * 80 + 2 * BONUS_SCORE_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          jsr IncreaseValue

          ldx #1
          lda #<( SCREEN_CHAR + 13 * 80 + 2 * BONUS_TIME_OFFSET )
          sta ZEROPAGE_POINTER_5
          lda #>( SCREEN_CHAR + 13 * 80 + 2 * BONUS_TIME_OFFSET )
          sta ZEROPAGE_POINTER_5 + 1

          jmp DecreaseValue



BONUS_TICK_DELAY
          !byte 0

BONUS_READY_DELAY
          !byte 0