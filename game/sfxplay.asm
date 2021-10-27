FX_NONE               = 0
FX_SLIDE              = 1
FX_STEP               = 2
FX_SLIDE_PING_PONG    = 3

FX_WAVE_TRIANGLE      = 0
FX_WAVE_SAWTOOTH      = 1
FX_WAVE_PULSE         = 2
FX_WAVE_NOISE         = 3


ZP_ADDRESS            = $57

NUM_CHANNELS          = 3

!zone SFXPlay
;a = channel (0 to 2 )
;x = sfx address lo
;y = sfx address hi
;expect 10 bytes, (FFFFFFWW) = Effect + Waveform
;                FX lo/hi, Pulse Lo, Pulse Hi, AD, SR, Effect Delta, Effect Delay, Effect Step
SFXPlay
          stx ZP_ADDRESS
          sty ZP_ADDRESS + 1

          ;lda #0
          sta .CURRENT_CHANNEL
          tax
          lda CHANNEL_OFFSET,x
          sta .CURRENT_VOICE

          ldy #0
          lda (ZP_ADDRESS),y
          lsr
          lsr
          sta EFFECT_TYPE_SETUP,x
          sta EFFECT_TYPE,x

          lda (ZP_ADDRESS),y
          and #$03
          tay

          ;x is now 0,7,14
          ldx .CURRENT_VOICE
          lda WAVE_FORM_TABLE,y
          sta SID_MIRROR + 4,x

          lda #0
          sta SID2.FREQUENCY_LO_1 + 4,x

          txa
          clc
          adc #5
          tax
          ldy #5
          lda (ZP_ADDRESS),y
          ;lda #$98
          sta SID_MIRROR,x
          sta SID_MIRROR_SETUP,x
          sta SID2.FREQUENCY_LO_1,x

          inx
          ldy #6
          lda (ZP_ADDRESS),y
          ;lda #$b0
          sta SID_MIRROR,x
          sta SID_MIRROR_SETUP,x
          sta SID2.FREQUENCY_LO_1,x

          ;copy effect value 1 to 3 to SID registers 0 to 2
          ldx .CURRENT_VOICE
          ldy #1
-

          lda (ZP_ADDRESS),y
          sta SID_MIRROR,x
          sta SID_MIRROR_SETUP,x
          sta SID2.FREQUENCY_LO_1,x

          iny
          inx
          cpy #4
          bne -

          ;copy effect data
          ldx .CURRENT_CHANNEL
          ldy #7
          lda (ZP_ADDRESS),y
          sta EFFECT_DELTA,x
          sta EFFECT_DELTA_SETUP,x

          iny
          lda (ZP_ADDRESS),y
          sta EFFECT_DELAY,x
          sta EFFECT_DELAY_SETUP,x

          iny
          lda (ZP_ADDRESS),y
          sta EFFECT_VALUE,x
          sta EFFECT_VALUE_SETUP,x

          ;set wave form
          ldx .CURRENT_VOICE
          lda SID_MIRROR + 4,x
          sta SID_MIRROR_SETUP + 4,x
          sta SID2.FREQUENCY_LO_1 + 4,x

          rts


;0,1,2
.CURRENT_CHANNEL
          !byte 0
;0, 7, 14
.CURRENT_VOICE
          !byte 0



!zone SFXUpdate
SFXUpdate
          ldy #0
          sty SFXPlay.CURRENT_CHANNEL
.NextChannel
          ldx EFFECT_TYPE,y
          lda FX_TABLE_LO,x
          sta .JumpPos
          lda FX_TABLE_HI,x
          sta .JumpPos + 1

          ldx SFXPlay.CURRENT_CHANNEL
          ldy CHANNEL_OFFSET,x

.JumpPos = * + 1
          jsr $ffff

          inc SFXPlay.CURRENT_CHANNEL
          ldy SFXPlay.CURRENT_CHANNEL
          cpy #3
          bne .NextChannel

          rts



FX_TABLE_LO
          !byte <FXNone
          !byte <FXSlide
          !byte <FXStep
          !byte <FXPingPong

FX_TABLE_HI
          !byte >FXNone
          !byte >FXSlide
          !byte >FXStep
          !byte >FXPingPong


!zone FXSlide
FXSlide
          ;x = channel
          ;y = channel offset
          dec EFFECT_DELAY,x
          beq FXOff

          lda EFFECT_DELTA,x
          bpl .Up

          lda SID_MIRROR + 1,y
          clc
          adc EFFECT_DELTA,x
          bcc .Overflow
          jmp +


.Up
          lda SID_MIRROR + 1,y
          clc
          adc EFFECT_DELTA,x
          bcs .Overflow
+
          sta SID_MIRROR + 1,y
          sta SID2.FREQUENCY_LO_1 + 1,y
          rts

.Overflow

FXOff
          ;x = channel
          ;y = channel offset
          lda #0
          sta EFFECT_DELTA,x
          sta SID2.CONTROL_WAVE_FORM_1,y
          rts



!zone FXNone
FXNone
          ;x = channel
          ;y = channel offset
          dec EFFECT_DELAY,x
          beq FXOff
          rts



!zone FXStep
FXStep
          ;x = channel
          ;y = channel offset
          dec EFFECT_DELAY,x
          bne .NoStep

          ;step, switch to slide
          lda SID_MIRROR + 1,y
          clc
          adc EFFECT_VALUE,x
          sta SID_MIRROR + 1,y
          sta SID2.FREQUENCY_LO_1 + 1,y

          lda #0
          sta EFFECT_DELTA,x
          lda EFFECT_DELAY_SETUP,x
          sta EFFECT_DELAY,x

          lda #FX_SLIDE
          sta EFFECT_TYPE,x

.NoStep
          rts



!zone FXPingPong
FXPingPong
          ;x = channel
          ;y = channel offset
          dec EFFECT_VALUE,x
          bne .GoSlide

          lda EFFECT_VALUE_SETUP,x
          sta EFFECT_VALUE,x

          lda EFFECT_DELTA,x
          eor #$ff
          clc
          adc #1
          sta EFFECT_DELTA,x

.GoSlide
          jmp FXSlide





WAVE_FORM_TABLE
          !byte 17,33,65,129

CHANNEL_OFFSET
          !byte 0,7,14

SID_MIRROR
          !fill 7 * NUM_CHANNELS
SID_MIRROR_SETUP
          !fill 7 * NUM_CHANNELS

EFFECT_TYPE
          !fill NUM_CHANNELS
EFFECT_TYPE_SETUP
          !fill NUM_CHANNELS

EFFECT_DELTA
          !fill NUM_CHANNELS
EFFECT_DELTA_SETUP
          !fill NUM_CHANNELS

EFFECT_DELAY
          !fill NUM_CHANNELS
EFFECT_DELAY_SETUP
          !fill NUM_CHANNELS
EFFECT_VALUE
          !fill NUM_CHANNELS
EFFECT_VALUE_SETUP
          !fill NUM_CHANNELS



!zone PlaySoundEffect
PlaySoundEffectInChannel0
          lda #0

;y = SFX_...
;a = channel 0,1,2
PlaySoundEffectInChannel
          pha
          ldx SFX_TABLE_LO,y
          lda SFX_TABLE_HI,y
          tay
          pla
          jmp SFXPlay

;y = SFX_...
PlaySoundEffect
          inc .LAST_USED_CHANNEL
          lda .LAST_USED_CHANNEL
          cmp #3
          bne +

          lda #0
          sta .LAST_USED_CHANNEL
+
          jmp PlaySoundEffectInChannel



.LAST_USED_CHANNEL
          !byte 0



SFX_JUMP              = 0
SFX_PICK_DIAMOND     = 1
SFX_DISK_PUSH  = 2
SFX_BRICK_BREAK   = 3
SFX_BALL_KILLED   = 4
SFX_BONUS_BLIP    = 5
SFX_POWER_UP      = 6
SFX_FLATTEN_ENEMY = 7

SFX_TABLE_LO
          !byte <FX_BOUNCE
          !byte <FX_DISK_PUSH
          !byte <FX_COLOR_CHANGE
          !byte <FX_BRICK_BREAK
          !byte <FX_BALL_KILLED
          !byte <FX_BONUS_BLIP
          !byte <FX_POWER_UP
          !byte <FX_JUMP_AT_ENEMY

SFX_TABLE_HI
          !byte >FX_BOUNCE
          !byte >FX_DISK_PUSH
          !byte >FX_COLOR_CHANGE
          !byte >FX_BRICK_BREAK
          !byte >FX_BALL_KILLED
          !byte >FX_BONUS_BLIP
          !byte >FX_POWER_UP
          !byte >FX_JUMP_AT_ENEMY

FX_BOUNCE
          ;!byte ( FX_SLIDE_PING_PONG << 2 ) | FX_WAVE_SAWTOOTH
          ;!hex c20b2d459db50106
          ;!byte FX_STEP
          ;!byte ( FX_SLIDE << 2 ) | FX_WAVE_NOISE
          ;!hex 362c7ca48cf4e317dc

          ;FX lo/hi, Pulse Lo, Pulse Hi, AD, SR, Effect Delta, Effect Delay, Effect Step
          !byte ( FX_SLIDE_PING_PONG << 2 ) | FX_WAVE_SAWTOOTH
          !hex ff10486098b00205e8

FX_DISK_PUSH
          ;!byte ( FX_SLIDE_PING_PONG << 2 ) | FX_WAVE_TRIANGLE
          ;!hex ef163e668eb6020902
          !byte ( FX_STEP << 2 ) | FX_WAVE_TRIANGLE
          !hex 0b767b931cc3340620

FX_COLOR_CHANGE
          !byte ( FX_SLIDE << 2 ) | FX_WAVE_PULSE
          !hex 2d057d558de50306dd

FX_BRICK_BREAK
          !byte ( FX_SLIDE << 2 ) | FX_WAVE_NOISE
          ;!hex 4c2599c86b0dfc2b20
          ;!hex 580188a00d11011508
          !hex 440194fc270f0a6f77

FX_BALL_KILLED
          !byte ( FX_SLIDE << 2 ) | FX_WAVE_NOISE
          !hex b50a062e567eff2b18

FX_BONUS_BLIP
          !byte ( FX_SLIDE_PING_PONG << 2 ) | FX_WAVE_TRIANGLE
          !hex e60f375f87af1cf8d7

FX_POWER_UP
          !byte ( FX_SLIDE_PING_PONG << 2 ) | FX_WAVE_SAWTOOTH
          !hex 0a70ba82ea31122c04

FX_JUMP_AT_ENEMY
          !byte ( FX_SLIDE << 2 ) | FX_WAVE_NOISE
          !hex 8017d0075f77fc948f
