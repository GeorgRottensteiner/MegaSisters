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

          ;ACK IRQs
          lda #$01
          sta VIC.IRQ_REQUEST

          lda #120
-
          cmp VIC.RASTER_POS
          beq -

          ply
          plx
          pla
          rti
