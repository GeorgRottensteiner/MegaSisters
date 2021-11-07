!zone Debug
Debug
          stx LOCAL1
          sty LOCAL2
          sta LOCAL3

          lda #32
          ldx #0
-
          sta SCREEN_CHAR,x
          sta SCREEN_CHAR + 250,x
          sta SCREEN_CHAR + 250 * 2,x
          sta SCREEN_CHAR + 250 * 3,x

          inx
          cpx #250
          bne-

          ;default graphic mode
          lda #$00
          sta VIC4.VIC4DIS
          lda #40
          sta VIC4.CHARSTEP_LO

          lda #$50
          ;$50-scroll(0-15)
          sta VIC4.TEXTXPOS

          lda #$50
          sta VIC4.SIDBDRWD

          lda #<LOCAL1
          sta ZEROPAGE_POINTER_1
          lda #>LOCAL1
          sta ZEROPAGE_POINTER_1 + 1

          lda #<SCREEN_CHAR
          sta ZEROPAGE_POINTER_2
          lda #>SCREEN_CHAR
          sta ZEROPAGE_POINTER_2 + 1

          lda #3
          sta PARAM3
          jsr DisplayHex

          lda #<OBJECT_ACTIVE
          sta ZEROPAGE_POINTER_1
          lda #>OBJECT_ACTIVE
          sta ZEROPAGE_POINTER_1 + 1

          lda #<( SCREEN_CHAR + 40 )
          sta ZEROPAGE_POINTER_2
          lda #>( SCREEN_CHAR + 40 )
          sta ZEROPAGE_POINTER_2 + 1

          lda #8
          sta PARAM3
          jsr DisplayHex

!if 0{
          lda #<OBJECT_FLAGS
          sta ZEROPAGE_POINTER_1
          lda #>OBJECT_FLAGS
          sta ZEROPAGE_POINTER_1 + 1

          lda #<( SCREEN_CHAR + 2 * 40 )
          sta ZEROPAGE_POINTER_2
          lda #>( SCREEN_CHAR + 2 * 40 )
          sta ZEROPAGE_POINTER_2 + 1

          lda #8
          sta PARAM3
          jsr DisplayHex

          lda #<PARAM5
          sta ZEROPAGE_POINTER_1
          lda #>PARAM5
          sta ZEROPAGE_POINTER_1 + 1

          lda #<( SCREEN_CHAR + 3 * 40 )
          sta ZEROPAGE_POINTER_2
          lda #>( SCREEN_CHAR + 3 * 40 )
          sta ZEROPAGE_POINTER_2 + 1

          lda #2
          sta PARAM3
          jsr DisplayHex
}
          jmp *


!zone DisplayHex
DisplayHex
          ldy #0
-
          lda (ZEROPAGE_POINTER_1),y
          pha
          lsr
          lsr
          lsr
          lsr
          tax
          lda HEX_CHAR,x
          sta (ZEROPAGE_POINTER_2),y

          inc ZEROPAGE_POINTER_2

          pla
          and #$0f
          tax
          lda HEX_CHAR,x
          sta (ZEROPAGE_POINTER_2),y

          inc ZEROPAGE_POINTER_2

          iny
          cpy PARAM3
          bne -

          rts

HEX_CHAR
          !scr "0123456789abcdef"