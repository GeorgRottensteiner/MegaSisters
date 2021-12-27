!zone TitleSetup
TitleSetup
          jsr SetPalette

!zone Title
Title
          jsr ScreenOff

          ;lda #80
          ;sta VIC4.CHARSTEP_LO

          lda #CHAR_EMPTY
          jsr ScreenClear32bitAddr

          ;Set logical row width
          ;bytes per screen row (16 bit value in $d058-$d059)
          lda #<ROW_SIZE_BYTES
          sta VIC4.CHARSTEP_LO
          lda #>ROW_SIZE_BYTES
          sta VIC4.CHARSTEP_HI

          ;Set number of chars per row
          lda #ROW_SIZE
          sta VIC4.CHRCOUNT

          ;fix GOTOX offsets for upper layer
          ldx #0
-
          lda SCREEN_LINE_OFFSET_LO, x
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_HI, x
          sta ZEROPAGE_POINTER_1 + 1

          ;offset 0 so it starts at the left border
          ldy #80
          lda #<0
          sta (ZEROPAGE_POINTER_1),y
          iny
          lda #>0
          sta (ZEROPAGE_POINTER_1),y

          ;offset 320 for the last pseudo character so it ends at the right border
          ldy #162
          lda #<320
          sta (ZEROPAGE_POINTER_1),y
          iny
          lda #>320
          sta (ZEROPAGE_POINTER_1),y

          inx
          cpx #25
          bne -

          ;set up color RAM, target COLOR_RAM
          ldy #0

          lda #<COLOR_RAM
          sta ZEROPAGE_POINTER_QUAD_1
          lda #( COLOR_RAM >> 8 ) & $ff
          sta ZEROPAGE_POINTER_QUAD_1 + 1
          lda #( COLOR_RAM >> 16 ) & $ff
          sta ZEROPAGE_POINTER_QUAD_1 + 2
          lda #( COLOR_RAM >> 24 ) & $0f
          sta ZEROPAGE_POINTER_QUAD_1 + 3
--
          ldx #0
          ldz #0
-
          lda COLOR_RAM_DATA_GAME,x
          sta [ZEROPAGE_POINTER_QUAD_1],z

          inx
          inz
          cpz #ROW_SIZE_BYTES
          bne -

          lda ZEROPAGE_POINTER_QUAD_1
          clc
          adc #ROW_SIZE_BYTES
          sta ZEROPAGE_POINTER_QUAD_1
          bcc +
          inc ZEROPAGE_POINTER_QUAD_1 + 1
+
          iny
          cpy #25
          bne --

          lda #$07
          sta VIC4.VIC4DIS

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
          ;jsr PrepareLevelDataPointerNoStartScroll

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


COLOR_RAM_DATA_GAME
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


TITLE_LEVEL_NR
          !byte 0
