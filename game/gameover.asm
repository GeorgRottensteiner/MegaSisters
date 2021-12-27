!zone GameOver
GameOver
          lda #252
          jsr WaitFrame

          lda #1
          jsr MUSIC_PLAYER

          ;lda #80
          ;sta VIC4.CHARSTEP_LO

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.BACKGROUND_COLOR

          lda #$50 - 8
          clc
          adc PARAM1
          ;$50-scroll(0-15)
          sta VIC4.TEXTXPOS

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ldx #0
          ldy #0
-
          lda GUI_BAR + 10 * 40,x
          sta SCREEN_CHAR + 11 * ROW_SIZE_BYTES,y

          iny
          iny
          inx
          cpx #40
          bne -

          lda #240
          sta GAME_OVER_DELAY

          lda #0
          sta BUTTON_RELEASED

!zone GameOverLoop
GameOverLoop
          lda #252
          jsr WaitFrame

          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          bne .NotFire

          lda BUTTON_RELEASED
          beq .KeepGoing

          jmp .Abort

.NotFire
          lda #1
          sta BUTTON_RELEASED

.KeepGoing
          dec GAME_OVER_DELAY
          bne GameOverLoop

.Abort
          lda #0
          sta BUTTON_RELEASED

          lda #0
          jsr MUSIC_PLAYER

          jmp Title


GAME_OVER_DELAY
          !byte 0