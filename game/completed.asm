!zone CompletedGame
CompletedGame
          lda #252
          jsr WaitFrame

          lda #2
          jsr MUSIC_PLAYER

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.BACKGROUND_COLOR
          lda #$ff
          sta JINGLE_ABORT_DELAY

          lda #$50 - 8
          sta VIC4.TEXTXPOS

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ldx #0
          ldy #0
-
          lda GUI_BAR + 11 * 40,x
          sta SCREEN_CHAR + 9  * ROW_SIZE_BYTES,y
          lda GUI_BAR + 12 * 40,x
          sta SCREEN_CHAR + 11 * ROW_SIZE_BYTES,y
          lda GUI_BAR + 13 * 40,x
          sta SCREEN_CHAR + 13 * ROW_SIZE_BYTES,y

          iny
          iny
          inx
          cpx #40
          bne -

!zone CompletedLoop
CompletedLoop
          lda #252
          jsr WaitFrame

          lda JINGLE_ABORT_DELAY
          beq .CanAbort

          dec JINGLE_ABORT_DELAY
          jmp .CantAbort

.CanAbort
          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          bne .NoAbort

          lda BUTTON_RELEASED
          beq .ButtonNotReleased

          lda #0
          sta BUTTON_RELEASED

          lda #0
          jsr MUSIC_PLAYER

          jmp Title

.NoAbort
          lda #1
          sta BUTTON_RELEASED

.ButtonNotReleased
.CantAbort
          jmp CompletedLoop



JINGLE_ABORT_DELAY
          !byte 0