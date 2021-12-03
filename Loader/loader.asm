!cpu m65

!source <c64.asm>
!source <mega65.asm>

NUM_CHARS = 244
NUM_SPRITES = 138

LOAD_CODE_LOCATION  = $0400

SPRITE_LOCATION       = $14000

!to "loader.prg",cbm


* = $2001

!basic

          ldx #0
-
          lda LOADER_CODE,x
          sta LOAD_CODE_LOCATION,x
          lda LOADER_CODE + 256,x
          sta LOAD_CODE_LOCATION + 256,x
          ;lda LOADER_CODE + 256 * 2,x
          ;sta LOAD_CODE_LOCATION + 256 * 2,x

          inx
          bne -

          jmp StartUp

          ;jmp DO_LOAD

LOADER_CODE
!pseudopc LOAD_CODE_LOCATION

!source "mega65_io.asm"
;!source "mega65_iodebug.asm"

DO_LOAD
+FLOPPY_LOAD $2040, "GAME"

          bcc +
          inc VIC.BORDER_COLOR
+
          jmp $2040 ;ENTRY_POINT

!realpc

LOAD_CODE_END

LOAD_CODE_SIZE = LOAD_CODE_END - LOADER_CODE

!if LOAD_CODE_SIZE > ( 2 * 256 ) {
!error "Loadercode > ", 2 * 256, " bytes! ", LOAD_CODE_SIZE, " bytes"
}

StartUp
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

          +DisableC65ROM

          ;lda #%00000111
          ;trb $d016


          ;lda #$37
          ;sta PROCESSOR_PORT

          cli

          lda #$00 ; DMA list exists in BANK 0
          sta DMA.ADDRBANK
          lda #>DMA_CHARSET ; Set MSB of DMA list address
          sta DMA.ADDRMSB
          lda #<DMA_CHARSET ; Set LSB of DMA list address, and execute DMA
          sta DMA.ADDRLSB_TRIG

          lda #$00 ; DMA list exists in BANK 0
          sta DMA.ADDRBANK
          lda #>DMA_SPRITES ; Set MSB of DMA list address
          sta DMA.ADDRMSB
          lda #<DMA_SPRITES ; Set LSB of DMA list address, and execute DMA
          sta DMA.ADDRLSB_TRIG

          jmp DO_LOAD



DMA_CHARSET
          !byte DMA.COMMAND_COPY  ; Command low byte
          !word ( CHARSET_END - CHARSET_SOURCE ) ; count
          !word CHARSET_SOURCE & $ffff
          !byte CHARSET_SOURCE >> 16        ; Source bank
          !word CHARSET_LOCATION & $ffff    ;destination address
          !byte CHARSET_LOCATION >> 16      ;destination mmsb
          !byte $00 ; Command high byte
          !word $0000 ; Modulo (ignored due to selected commmand

DMA_SPRITES
          !byte DMA.COMMAND_COPY  ; Command low byte
          !word ( SPRITE_DATA_END - SPRITE_DATA ) ; count
          !word SPRITE_DATA
          !byte $00 ; Source bank
          !word SPRITE_LOCATION & $ffff ; Destination address
          !byte SPRITE_LOCATION >> 16   ; destination mmsb
          !byte $00 ; Command high byte
          !word $0000 ; Modulo (ignored due to selected commmand

CHARSET_SOURCE
          !media "../game/game.charsetproject",CHAR,0,NUM_CHARS
CHARSET_END

SPRITE_DATA
          !media "../game/megasisters.spriteproject",SPRITE,0,NUM_SPRITES
SPRITE_DATA_END

CHARSET_LOCATION = $10000


!if 0 {

!zone WaitForKey
WaitForKey
          lda JOYSTICK_PORT_II
          and #$10
          bne WaitForKey

WaitForKey2
          lda JOYSTICK_PORT_II
          and #$10
          beq WaitForKey2

          rts

!zone HexOut
;source data in .Source
HexOut
          lda #0
          sta PARAM1
          sta PARAM2
-
          ldy PARAM1

.Source = *  + 1
          lda $ffff,y
          pha
          lsr
          lsr
          lsr
          lsr
          tax
          lda HEX_CHARS,x
          ldy PARAM2
          sta $0800,y

          pla
          and #$0f
          tax
          lda HEX_CHARS,x
          iny
          sta $0800,y

          inc PARAM1
          inc PARAM2
          inc PARAM2

          ldy PARAM1
          cpy #80
          bne -

          rts


DumpBuffer
          lda #<FILE_BUFFER
          sta HexOut.Source
          lda #>FILE_BUFFER
          sta HexOut.Source + 1

          jsr HexOut
          jsr WaitForKey
          rts

EndLoop
-
          inc VIC.BORDER_COLOR
          jmp -


HEX_CHARS
          !scr "0123456789abcdef"
          }


