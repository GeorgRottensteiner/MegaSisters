!zone ZP
  .Screen = $02
  .Color  = $06

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
          ;eor RANDOM_SEED
          eor $dc05
          eor $dd04
          adc $dd05
          eor $dd06
          eor $dd07
          ;sta RANDOM_SEED
          rts



!zone ScreenClear32bitAddr
ScreenClear32bitAddr
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
          lda #$04 ; TILE_DATA / 64 ; $01
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
          lda #$04 ; $01
          sta [ZP.Screen], z
          lda #0
          sta [ZP.Color], z

          inz
          cpz #208
          bne -

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


BIT_TABLE
          !byte 1,2,4,8,16,32,64,128