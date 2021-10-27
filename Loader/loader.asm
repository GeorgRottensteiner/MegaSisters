!cpu m65

!source <c64.asm>
!source <mega65.asm>

NUM_CHARS = 244
NUM_SPRITES = 38

LOAD_CODE_LOCATION = $0400


!to "LOADER.d81",d81


* = $2001

!basic
          ;ldx #0
;-
;          lda LOADER_CODE,x
;          sta LOAD_CODE_LOCATION,x
;          lda LOADER_CODE + 256,x
;          sta LOAD_CODE_LOCATION + 256,x
;
;          inx
;          bne -

          jmp StartUp

          jmp DO_LOAD

LOADER_CODE
;!pseudopc LOAD_CODE_LOCATION

!source "mega65_io.asm"

;!realpc

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

          ;Disable C65 rom write protection
          ;$20000 - $3ffff
          lda #$70
          sta Mega65.HTRAP00
          eom

          ;bank out C65 ROM
          lda #$f8
          trb VIC3.ROMBANK


          lda #$35
          sta PROCESSOR_PORT

          cli

          DO_LOAD
          +FLOPPY_LOAD $3000, "GAME"

          bcc +

          inc VIC.BORDER_COLOR

+

          inc $0800
          ;jmp $2001
          rts



          ;lda #$00 ; DMA list exists in BANK 0
;          sta DMA.ADDRBANK
;          lda #>DMA_CHARSET ; Set MSB of DMA list address
;          sta DMA.ADDRMSB
;          lda #<DMA_CHARSET ; Set LSB of DMA list address, and execute DMA
;          sta DMA.ADDRLSB_TRIG
;
;          lda #$00 ; DMA list exists in BANK 0
;          sta DMA.ADDRBANK
;          lda #>DMA_SPRITES ; Set MSB of DMA list address
;          sta DMA.ADDRMSB
;          lda #<DMA_SPRITES ; Set LSB of DMA list address, and execute DMA
;          sta DMA.ADDRLSB_TRIG

          lda #$01
          sta $0800

          jmp DO_LOAD



          ;lda #$02
          ;sta $0800

          ;;set 40x25 mode
;          lda #$80
;          trb VIC3.VICDIS
;
;          ;Turn on FCM mode with 16bit per char
;          lda #$07
;          sta VIC4.VIC4DIS
;
;
;          lda #$00
;          sta $0800
;          lda #$04
;          sta $0801
;          lda #$01
;          sta $0802
;          lda #$04
;          sta $0803
;          lda #$81
;          sta $0802
;          lda #$04
;          sta $0803
;
;-
;          inc VIC.BORDER_COLOR
;          jmp -


;
;DMA_CHARSET
;          !byte DMA.COMMAND_COPY  ; Command low byte
;          !word ( CHARSET_END - CHARSET_SOURCE ) ; count
;          !word CHARSET_SOURCE & $ffff
;          !byte CHARSET_SOURCE >> 16        ; Source bank
;          !word CHARSET_LOCATION & $ffff    ;destination address
;          !byte CHARSET_LOCATION >> 16      ;destination mmsb
;          !byte $00 ; Command high byte
;          !word $0000 ; Modulo (ignored due to selected commmand
;
;DMA_SPRITES
;          !byte DMA.COMMAND_COPY  ; Command low byte
;          !word ( SPRITE_DATA_END - SPRITE_DATA ) ; count
;          !word SPRITE_DATA
;          !byte $00 ; Source bank
;          !word $8000 ; Destination address where screen lives
;          !byte $01 ; destination mmsb
;          !byte $00 ; Command high byte
;          !word $0000 ; Modulo (ignored due to selected commmand
;
;CHARSET_SOURCE
;          !media "../game/game.charsetproject",CHAR,0,NUM_CHARS
;CHARSET_END
;
;SPRITE_DATA
;          !media "../game/megasisters.spriteproject",SPRITE,0,NUM_SPRITES
;SPRITE_DATA_END
;
;CHARSET_LOCATION = $10000


