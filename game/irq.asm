!zone InitIrq
InitIrq
          sei
          lda #<IRQMusic
          ldx #>IRQMusic
          sta $fffe
          stx $ffff

          ldx #120
          stx VIC.RASTER_POS

          lda #$01
          sta VIC.IRQ_MASK
          sta VIC.IRQ_REQUEST; ACK any raster IRQs

          cli
          rts



!zone IRQMusic
IRQMusic
          pha
          phx
          phy

          jsr MUSIC_PLAYER + 3
          jsr SFXUpdate

          ;wait for line #120 to be finished to avoid triggering again
          lda #120
-
          cmp VIC.RASTER_POS
          beq -

          lda IRQ_SCROLL_OFFSET_ACTIVE
          beq .NoScrollIRQ

          ldx #50 + SCROLL_FIRST_ROW * 8
          stx VIC.RASTER_POS

          lda #<IRQScrollOffset
          ldx #>IRQScrollOffset
          sta $fffe
          stx $ffff


.NoScrollIRQ
          ;ACK IRQs
          lda #$01
          sta VIC.IRQ_REQUEST

          ply
          plx
          pla
          rti


!zone IRQScrollOffset
IRQScrollOffset
          pha
          phx
          phy

          ;set up display for game area
          lda SCROLL_POS
          asl
          sta PARAM1

          lda #$50 ; - 8
          clc
          ;adc #4 ;PARAM1
          ;$50-scroll(0-15)
          sta VIC4.TEXTXPOS

          lda #$07
          sta VIC4.VIC4DIS

          lda #<IRQMusic
          ldx #>IRQMusic
          sta $fffe
          stx $ffff

          ldx #120
          stx VIC.RASTER_POS

          ;ACK IRQs
          lda #$01
          sta VIC.IRQ_REQUEST

          ply
          plx
          pla
          rti


IRQ_SCROLL_OFFSET_ACTIVE
          !byte 0