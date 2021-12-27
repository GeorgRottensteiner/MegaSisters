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
          jsr ScreenClear32bitAddrWithAlternativeHiByteNoRRB

          lda #<( LOGO_CHARSET_SOURCE / 64 )
          sta .LO
          lda #>( LOGO_CHARSET_SOURCE / 64 )
          sta .HI


          lda #3
          sta PARAM2

          lda #<( SCREEN_CHAR + 3 * 80 )
          sta ZEROPAGE_POINTER_1
          lda #>( SCREEN_CHAR + 3 * 80 )
          sta ZEROPAGE_POINTER_1 + 1


--
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

          lda ZEROPAGE_POINTER_1
          clc
          adc #80
          sta ZEROPAGE_POINTER_1
          bcc +
          inc ZEROPAGE_POINTER_1 + 1
+

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

          jmp TitleSetup

.NoAbort
          lda #1
          sta BUTTON_RELEASED
.ButtonNotReleased
          jmp CreditsLoop




COLOR_SETUP
          ;40 16bit chars = 80 bytes
          !fill 40, [0, 0] ;layer 1

          ;+4
          ;Set bit 4 of color ram byte 0 to enable gotox flag
          ;set bit 7 additionally to enable transparency

          !byte GOTOX | TRANSPARENT, $00

          ;second layer colors
          !fill 40, [0, 0] ;layer 1

          !byte GOTOX | TRANSPARENT, $00
          !byte 0,0
