!zone Credits
Credits
          lda #252
          jsr WaitFrame

          ;set credits palette
          lda #%01011001
          sta VIC4.PALSEL


          lda #80
          sta VIC4.CHARSTEP_LO

          lda #0
          sta VIC.SPRITE_ENABLE
          sta VIC.BACKGROUND_COLOR

          lda #$07
          sta VIC4.VIC4DIS

          lda #CHAR_EMPTY
          ldx #>( CHARSET_LOCATION / 64 )
          stx PARAM2
          jsr ScreenClear32bitAddrWithAlternativeHiByteNoRRB

          lda #3
          sta PARAM2

          lda #<( SCREEN_CHAR + 3 * 80 + 11 * 2 )
          sta ZEROPAGE_POINTER_1
          lda #>( SCREEN_CHAR + 3 * 80 + 11 * 2 )
          sta ZEROPAGE_POINTER_1 + 1

          ldx #0
          ldy #0
          ldz #18

--
          lda LOGO_CHARSET_SCREEN,x
          clc
          adc #<( LOGO_CHARSET_SOURCE / 64 )
          sta (ZEROPAGE_POINTER_1),y
          iny
          lda #>( LOGO_CHARSET_SOURCE / 64 )
          adc #0
          sta (ZEROPAGE_POINTER_1),y
          iny

          inx
          dez
          bne --

          ldy #0
          ldz #18
          lda ZEROPAGE_POINTER_1
          clc
          adc #80
          sta ZEROPAGE_POINTER_1
          bcc +
          inc ZEROPAGE_POINTER_1 + 1
+

          cpx #144
          bne --


          ldx #0
          ldy #0
-
          lda GUI_BAR + 14 * 40,x
          sta SCREEN_CHAR + 14  * 80,y

          lda GUI_BAR + 15 * 40,x
          sta SCREEN_CHAR + 20  * 80,y
          lda GUI_BAR + 16 * 40,x
          sta SCREEN_CHAR + 21  * 80,y
          lda GUI_BAR + 17 * 40,x
          sta SCREEN_CHAR + 22  * 80,y
          lda GUI_BAR + 18 * 40,x
          sta SCREEN_CHAR + 23  * 80,y

          iny
          iny
          inx
          cpx #40
          bne -

          jsr ScreenOn

!zone CreditsLoop
CreditsLoop
          lda #140
          jsr WaitFrame

          ;set palette for credit text
          jsr SetPalette

          lda #252
          jsr WaitFrame

          ;set palette for logo
          ;copy logo palette data (CHAR_PALETTE_ENTRY_COUNT entries),
          lda #%01011001
          sta VIC4.PALSEL

          ldx #0
          ldy #0
-

          lda LOGO_CHARSET_PALETTE, x
          sta VIC4.PALRED,y
          lda LOGO_CHARSET_PALETTE + 1 * 256, x
          sta VIC4.PALGREEN,y
          lda LOGO_CHARSET_PALETTE + 2 * 256, x
          sta VIC4.PALBLUE,y

          iny
          inx
          bne -

          lda #%10011001
          sta VIC4.PALSEL

          lda JOYSTICK_PORT_II
          sta JOY_VALUE
          and #JOY_FIRE
          bne .NoAbort

          lda BUTTON_RELEASED
          beq .ButtonNotReleased

          lda #0
          sta BUTTON_RELEASED

          jsr SetPalette

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
