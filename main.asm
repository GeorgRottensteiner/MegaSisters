﻿!cpu m65

!source <c64.asm>
!source <mega65.asm>


BORDER_WIDTH = $58    ;38 column border width

SCREEN_CHAR = $0800
SCREEN_COLOR = $d800

NUM_SPRITES = 30

PARAM1    = $67
PARAM2    = $68
PARAM3    = $69
PARAM4    = $6A
PARAM5    = $6B
PARAM6    = $05
PARAM7    = $08

LOCAL1    = $02
LOCAL2    = $03
LOCAL3    = $04
CURRENT_INDEX = $06
CURRENT_SUB_INDEX = $07

ZEROPAGE_POINTER_1 = $6C
ZEROPAGE_POINTER_2 = $6E
ZEROPAGE_POINTER_3 = $70
ZEROPAGE_POINTER_4 = $C1
ZEROPAGE_POINTER_5 = $C3

;ttt y yyyy
;T = Type, y = y pos
LDF_X_POS             = $00
LDF_ELEMENT_LINE      = $20
LDF_PREV_ELEMENT      = $40
LDF_PREV_ELEMENT_LINE = $60
LDF_ELEMENT           = $80
LD_END                = $a0
LD_OBJECT             = $c0
LDF_ELEMENT_AREA      = $e0
LDF_PREV_ELEMENT_AREA = $e0   ;y repeat MSB means previous element
;not yet used  $e0


SPRITE_POINTER_BASE   = $ff0


* = $2001
          !basic

          sei

          +EnableVIC4Registers
          +Enable40Mhz

          ;Turn off CIA interrupts
          lda #$7f
          sta CIA1.IRQ_CONTROL
          sta CIA2.NMI_CONTROL

          ;Turn off raster interrupts, used by C65 rom
          lda #$00
          sta VIC.IRQ_MASK

          ;;Disable C65 rom write protection
          ;;$20000 - $3ffff
          lda #$70
          sta $d640
          eom

          ;bank out C65 ROM
          lda #$f8
          trb VIC3.ROMBANK

          lda #$35
          sta PROCESSOR_PORT

          cli

          ;;set chargen to GUI charset
;          lda #<GUI_CHARSET
;          sta VIC4.CHARPTR
;          lda #>GUI_CHARSET
;          sta VIC4.CHARPTR + 1
;          lda #0
;          sta VIC4.CHARPTR + 2
;
;          jmp *


          ;set 40x25 mode
          lda #$80
          trb VIC3.VICDIS

          ;Turn on FCM mode with 16bit per char
          lda #$07
          sta VIC4.VIC4DIS

          lda #$08
          sta VIC.CONTROL_2

          jsr ScreenOff

          lda #16
          sta VIC.BACKGROUND_COLOR

          lda #<SPRITE_POINTER_BASE
          sta VIC4.SPRPTRADR_LO
          lda #>SPRITE_POINTER_BASE
          sta VIC4.SPRPTRADR_HI

          ;enable 16bit sprite pointers (plus upper 7bits of sprite pointer list address)
          lda #$80
          sta VIC4.SPRPTR16

          ;set all hi bytes to bank 3
          lda #$02
          sta SPRITE_POINTER_BASE + 1
          sta SPRITE_POINTER_BASE + 3
          sta SPRITE_POINTER_BASE + 5
          sta SPRITE_POINTER_BASE + 7
          sta SPRITE_POINTER_BASE + 9
          sta SPRITE_POINTER_BASE + 11
          sta SPRITE_POINTER_BASE + 13
          sta SPRITE_POINTER_BASE + 15

          jsr SetPalette

          jmp Title



!zone SetPalette
SetPalette
          ;Bit 6-7 = Mapped Palette
          ;bit 0-1 = Char palette index
          lda #%01011001
          sta VIC4.PALSEL


          ;copy palette data (32 entries),
          ldx #0
-

          lda PALETTE_DATA, x
          sta VIC4.PALRED,y
          lda PALETTE_DATA + 1 * 32, x
          sta VIC4.PALGREEN,y
          lda PALETTE_DATA + 2 * 32, x
          sta VIC4.PALBLUE,y

          iny
          inx
          cpx #32
          bne -

          ;duplicate sprite palettes
          ;sprite palettes have 16 entries per sprite for 16 color mode
          ;use palette bank 1
          lda #%10011001
          sta VIC4.PALSEL

          ldx #$00
          ldy #0
-
          lda PALETTE_DATA, x
          sta VIC4.PALRED,y
          lda PALETTE_DATA + 1 * 32, x
          sta VIC4.PALGREEN,y
          lda PALETTE_DATA + 2 * 32, x
          sta VIC4.PALBLUE,y

          iny

          inx
          cpx #16
          bne -

          ldx #0
          cpy #16 * 8
          bne -

          ;set sprite pal to bank 1
          lda #%01011001
          sta VIC4.PALSEL

          rts



!source "game.asm"
!source "util.asm"
!source "bonus.asm"
!source "getready.asm"
!source "debugout.asm"
!source "stages.asm"
!source "objects.asm"
!source "gameover.asm"
!source "title.asm"


PALETTE_DATA
          !media "tiles.charscreen",PALETTESWIZZLED,0,32

* = $4000
TILE_DATA
          !media "tiles.charscreen",CHARSET,0,244

;GUI_CHARSET
;          !media "gui.charscreen",CHARSET,0,64

* = $8000
;!realign 64
SPRITE_DATA
          !media "megasisters.spriteproject",SPRITE,0,NUM_SPRITES


ANIMATED_TILE_DATA
          !media "tilesanimations.charscreen",CHARSET,0,18

GUI_BAR
          !media "gui.charscreen",CHAR

