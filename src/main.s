.zeropage
    addr: .res 2
    x1: .byte 0
    y1: .byte 0
    x2: .byte 0
    y2: .byte 0

.segment "STARTUP"
    jmp start

.segment "ONCE"

.include "x16.inc"
.include "config.inc"

.segment "CODE"

default_irq: .word 0
waitflag: .byte 0

.include "config.s"
.include "irq.s"
.include "tiles.s"
.include "bres.s"
.include "pix.s"
.include "move.s"
.include "floor.s"
.include "line.s"
.include "loading.s"
.include "controls.s"

loopCount: .byte 0

start:
    jsr config
    jsr irq_config
    jsr create_tiles
    jsr load_level0
    jsr draw_floor
    jsr create_empty_pixeldata
    jsr clear_l1
    jsr adjust_view_radius
main_loop:
    jsr check_controls
    jsr set_xy_pos
    lda xMid
    cmp xLastMid
    bne @draw_everything
    lda yMid
    cmp yLastMid
    beq @waiting
@draw_everything:
    jsr clear_pixeldata
    jsr draw_lr_lines
    jsr draw_ud_lines
    jsr copy_pixeldata_to_vram
    jsr scroll_layers
@waiting:
    lda waitflag
    cmp #0
    beq @waiting
    stz waitflag
    ; inc loopCount
    ; lda loopCount
    ; cmp #5
    ; bne @waiting
    ; stz loopCount
    bra main_loop
    rts

point_to_mapbase_l0:
    lda #<MAPBASE_L0_ADDR
    sta VERA_ADDR_LO
    lda #>MAPBASE_L0_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    rts

point_to_mapbase_l1:
    lda #<MAPBASE_L1_ADDR
    sta VERA_ADDR_LO
    lda #>MAPBASE_L1_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    rts

point_to_tilebase_l1:
    lda #<TILEBASE_L1_ADDR
    sta VERA_ADDR_LO
    lda #>TILEBASE_L1_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    rts

floorId: .byte 0
floorCount: .byte 0

draw_floor:
    lda #<floor
    sta addr
    lda #>floor
    sta addr + 1
    jsr point_to_mapbase_l0
    ldx #0
    ldy #0
@draw_floor:
    lda (addr)
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    ; Increment floor address
    lda addr
    clc
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    ; Increment x,y index
    inx
    cpx #64
    bne @draw_floor
    ldx #0
    iny
    cpy #64
    bne @draw_floor
    rts

clear_l1:
    jsr point_to_mapbase_l1
    lda #<VERA_DATA0
    sta R0L
    lda #>VERA_DATA0
    sta R0H
    lda #<L1_MAPBASE_SIZE
    sta R1L
    lda #>L1_MAPBASE_SIZE
    sta R1H
    lda #2
    jsr MEMFILL
    rts
