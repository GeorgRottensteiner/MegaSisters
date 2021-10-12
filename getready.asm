﻿GETREADY_STAGE_OFFSET = 22

!zone GetReady
GetReady
          jsr ScreenOff

          lda #252
          jsr WaitFrame

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.BACKGROUND_COLOR
          sta VIC.SPRITE_X_EXTEND

          lda #$50 - 8
          sta VIC4.TEXTXPOS

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ldx #0
          ldy #0
-
          lda GUI_BAR + 5 * 40,x
          sta SCREEN_CHAR + 9 * 80,y
          lda GUI_BAR + 5 * 40 + 5 * 20,x
          sta SCREEN_CHAR + 9 * 80 + 5 * 40,y

          iny
          iny
          inx
          cpx #5 * 20
          bne -

          lda STAGE
          sta SCREEN_CHAR + 9 * 80 + 4 * 80 + GETREADY_STAGE_OFFSET * 2
          lda STAGE + 1
          sta SCREEN_CHAR + 9 * 80 + 4 * 80 + ( GETREADY_STAGE_OFFSET + 1 ) * 2

          lda #120
          sta GET_READY_DELAY

          jsr ScreenOn


!zone GetReadyLoop
GetReadyLoop
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
          dec GET_READY_DELAY
          bne GetReadyLoop

.Abort
          lda #0
          sta BUTTON_RELEASED
          rts


GET_READY_DELAY
          !byte 0