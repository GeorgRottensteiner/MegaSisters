!zone ZP
  .Screen = $02
  .Color  = $06
  .ScreenL = $0a

COLOR_RAM   = $ff80000


;wait for raster A
!zone WaitFrame
WaitFrame
          cmp VIC.RASTER_POS
          beq WaitFrame

-
          cmp VIC.RASTER_POS
          bne -
          rts



!zone GenerateRandomNumber
GenerateRandomNumber
          lda $dc04
          eor $dc05
          eor $dd04
          adc $dd05
          eor $dd06
          eor $dd07
          rts



!zone ScreenClear32bitAddrNoRRB
;a = clear char (lo byte)
ScreenClear32bitAddrNoRRB
          ldx #>( CHARSET_LOCATION / 64 )
          stx PARAM2

;a = clear char (lo byte)
;PARAM2 = clear char (hi byte)
ScreenClear32bitAddrWithAlternativeHiByteNoRRB
          sta PARAM1
          ldx #7

          lda #<COLOR_RAM
          sta ZP.Color + 0
          lda #>COLOR_RAM
          sta ZP.Color + 1
          lda #( COLOR_RAM >> 16 ) & $ff
          sta ZP.Color + 2
          lda #( COLOR_RAM >> 24 )
          sta ZP.Color + 3

          lda #<SCREEN_CHAR
          sta ZP.Screen + 0
          lda #>SCREEN_CHAR
          sta ZP.Screen + 1
          lda #SCREEN_CHAR >> 16
          sta ZP.Screen + 2
          lda #$00
          sta ZP.Screen + 3

--
          ldz #$00
-
          ;lo byte
          lda PARAM1
          sta [ZP.Screen], z
          lda #$00
          sta [ZP.Color], z
          inz

          ;hi byte
          ;force chars to $100!
          lda PARAM2
          sta [ZP.Screen], z
          lda #0
          sta [ZP.Color], z

          inz
          bne -

          dex
          bmi +

          inc ZP.Screen + 1
          inc ZP.Color + 1
          bra --

+
-
          ;lo byte
          lda PARAM1
          sta [ZP.Screen], z
          lda #$00
          sta [ZP.Color], z
          inz

          ;hi byte
          ;force chars to $100!
          lda PARAM2
          sta [ZP.Screen], z
          lda #0
          sta [ZP.Color], z

          inz
          cpz #208
          bne -

          rts



!zone ScreenClear32bitAddr
;a = clear char (lo byte)
ScreenClear32bitAddr
          ldx #>( CHARSET_LOCATION / 64 )
          stx PARAM2

;a = clear char (lo byte)
;PARAM2 = clear char (hi byte)
ScreenClear32bitAddrWithAlternativeHiByte
          sta PARAM1
          ldx #25

          lda #<( COLOR_RAM + 41 * 2 )
          sta ZP.Color + 0
          lda #>( COLOR_RAM + 41 * 2 )
          sta ZP.Color + 1
          lda #( ( COLOR_RAM + 41 * 2 ) >> 16 ) & $ff
          sta ZP.Color + 2
          lda #( ( COLOR_RAM + 41 * 2 ) >> 24 )
          sta ZP.Color + 3

          lda #<( SCREEN_CHAR + 41 * 2 )
          sta ZP.Screen + 0
          lda #>( SCREEN_CHAR + 41 * 2 )
          sta ZP.Screen + 1
          lda #( SCREEN_CHAR + 41 * 2 ) >> 16
          sta ZP.Screen + 2
          lda #$00
          sta ZP.Screen + 3

          lda #<( SCREEN_CHAR )
          sta ZP.ScreenL + 0
          lda #>( SCREEN_CHAR )
          sta ZP.ScreenL + 1
          lda #( SCREEN_CHAR ) >> 16
          sta ZP.ScreenL + 2
          lda #$00
          sta ZP.ScreenL + 3

--
          ldz #$00
-
          ;lo byte
          lda PARAM1
          sta [ZP.Screen], z
          sta [ZP.ScreenL], z
          lda #$00
          sta [ZP.Color], z
          inz

          ;hi byte
          ;force chars to $100!
          lda PARAM2
          sta [ZP.Screen], z
          sta [ZP.ScreenL], z
          lda #0
          sta [ZP.Color], z

          inz
          cpz #80
          bne -

          lda ZP.Screen
          clc
          adc #ROW_SIZE_BYTES
          sta ZP.Screen
          bcc +
          inc ZP.Screen + 1
+

          lda ZP.ScreenL
          clc
          adc #ROW_SIZE_BYTES
          sta ZP.ScreenL
          bcc +
          inc ZP.ScreenL + 1
+


          lda ZP.Color
          clc
          adc #ROW_SIZE_BYTES
          sta ZP.Color
          bcc +
          inc ZP.Color + 1
+


          dex
          bne --

          rts



!zone DecreaseValue
;x = index in on screen counter
;ZEROPAGE_POINTER_5 = pointer to screen
DecreaseValue
          txa
          asl
          tay
-
          lda (ZEROPAGE_POINTER_5),y
          cmp #CHAR_0
          bne +

          cpx #0
          beq .Done

          lda #CHAR_9
          sta (ZEROPAGE_POINTER_5),y

          dey
          dey
          dex
          jmp -

+
          dec
          sta (ZEROPAGE_POINTER_5),y

.Done
          rts



!zone IncreaseValueByA
;x = index in on screen counter
;ZEROPAGE_POINTER_5 = pointer to screen
;a = value to add
IncreaseValueByA
          sta .DecCount
-
          dec .DecCount

          phx
          jsr IncreaseValue
          plx

.DecCount = * + 1
          lda #$ff
          bne -

          rts



!zone IncreaseValue
;x = index in on screen counter
;ZEROPAGE_POINTER_5 = pointer to screen
IncreaseValue
          txa
          asl
          tay
-
          lda (ZEROPAGE_POINTER_5),y
          cmp #CHAR_9
          bne +

          lda #CHAR_0
          sta (ZEROPAGE_POINTER_5),y

          cpx #0
          beq .Done

          dey
          dey
          dex
          jmp -

+
          inc
          sta (ZEROPAGE_POINTER_5),y

.Done
          rts


!zone ScreenOff
ScreenOff
          lda #20
          jsr WaitFrame

          ;full border width
          lda #$ff
          sta VIC4.SIDBDRWD

          lda VIC4.HOTREG
          and #$c0
          ora #$07
          sta VIC4.HOTREG

          rts



!zone ScreenOn
ScreenOn
          lda #20
          jsr WaitFrame

          lda #BORDER_WIDTH
          sta VIC4.SIDBDRWD

          lda VIC4.HOTREG
          and #$c0
          sta VIC4.HOTREG

          rts



!zone MultiplyBy3
;returns A * 3
MultiplyBy3
          sta .TEMP
          asl
          clc
          adc .TEMP
          rts


.TEMP
          !byte 0




BIT_TABLE
          !byte 1,2,4,8,16,32,64,128