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
          sta SCREEN_CHAR + 11 * 80 + 2 * 80 + 9 * 2
          lda TIME_VALUE_BCD + 1
          sta SCREEN_CHAR + 11 * 80 + 2 * 80 + 10 * 2

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