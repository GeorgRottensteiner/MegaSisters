!zone Title
Title
          jsr ScreenOff

          lda #80
          sta VIC4.CHARSTEP_LO

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          lda #16
          sta VIC.BACKGROUND_COLOR

          ;set 38 columns with Sideborderwidth
          lda #$58
          sta VIC4.SIDBDRWD

          lda #0
          sta TITLE_LEVEL_NR

          ;level 0
          lda TITLE_LEVEL_NR
          jsr PrepareLevelDataPointer

          jsr ScreenOn

!zone TitleLoop
TitleLoop
          lda #51 + SCROLL_FIRST_ROW * 8
          jsr WaitFrame

          ;set up display for game area
          lda SCROLL_POS
          asl
          sta PARAM1

          lda #$50 - 8
          clc
          adc PARAM1
          ;$50-scroll(0-15)
          sta VIC4.TEXTXPOS

          lda #252
          jsr WaitFrame

          jsr AnimateChars
          jsr ObjectControl
          jsr SetSpriteValues

          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          bne .NotFire

          lda BUTTON_RELEASED
          beq .KeepGoing

          lda #0
          sta BUTTON_RELEASED
          jmp Game

.NotFire
          lda #1
          sta BUTTON_RELEASED

.KeepGoing
          jsr .DoScroll
          jsr .DoScroll
          jmp TitleLoop

.DoScroll
          lda LEVEL_WIDTH
          ora LEVEL_WIDTH + 1
          bne .NeedToScroll

          ;wrap around
          lda TITLE_LEVEL_NR
          jsr PrepareLevelDataPointerNoStartScroll

.NeedToScroll
          jsr ScrollBy1Pixel
          rts





TITLE_LEVEL_NR
          !byte 0
