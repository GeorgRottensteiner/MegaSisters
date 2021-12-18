!zone Credits
Credits
          lda #252
          jsr WaitFrame

          lda #80
          sta VIC4.CHARSTEP_LO

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.BACKGROUND_COLOR

          ;lda #$50 - 8
          ;sta VIC4.TEXTXPOS

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          ldx #>( CHARSET_LOCATION / 64 )
          stx PARAM2
          jsr ScreenClear32bitAddrWithAlternativeHiByte

          lda #<( LOGO_CHARSET_SOURCE / 64 )
          sta .LO
          lda #>( LOGO_CHARSET_SOURCE / 64 )
          sta .HI


          lda #3
          sta PARAM2

--
          ldy PARAM2
          lda SCREEN_LINE_OFFSET_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ldy #2 * 4
          ldx #0

-
.LO = * + 1
          lda #$ff
          sta (ZEROPAGE_POINTER_1),y
          iny
.HI = * + 1
          lda #$ff
          sta (ZEROPAGE_POINTER_1),y
          iny

          inc .LO
          bne +
          inc .HI
+

          cpy #2 * 36
          bne -

          inc PARAM2
          lda PARAM2
          cmp #9
          bne --

          ldx #0
          ldy #0
-
          lda GUI_BAR + 14 * 40,x
          sta SCREEN_CHAR + 12  * 80,y

          lda GUI_BAR + 15 * 40,x
          sta SCREEN_CHAR + 20  * 80,y
          lda GUI_BAR + 16 * 40,x
          sta SCREEN_CHAR + 21  * 80,y
          lda GUI_BAR + 17 * 40,x
          sta SCREEN_CHAR + 22  * 80,y

          iny
          iny
          inx
          cpx #40
          bne -


          jsr ScreenOn

!zone CreditsLoop
CreditsLoop
          lda #252
          jsr WaitFrame

          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          bne .NoAbort

          lda BUTTON_RELEASED
          beq .ButtonNotReleased

          lda #0
          sta BUTTON_RELEASED

					jsr SetPalette
          jmp Title

.NoAbort
          lda #1
          sta BUTTON_RELEASED
.ButtonNotReleased
          jmp CreditsLoop



