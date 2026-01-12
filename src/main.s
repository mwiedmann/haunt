.zeropage
    addr: .res 2
    addr2: .res 2
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
.include "bres.s"
.include "pix.s"
.include "move.s"
.include "floor.s"
.include "line.s"
.include "loading.s"
.include "controls.s"
.include "pal.s"

loopCount: .byte 0

start:
    jsr config
    jsr irq_config
    jsr load_pal
    jsr load_tiles
    jsr load_level0
    jsr load_precalc
    jsr set_guy_pixeldata
    jsr clear_l1
    bra @draw_everything ; initial draw
@main_loop:
    jsr check_controls
    lda moved
    beq @waiting
    lda xMid
    cmp xLastMid
    bne @draw_everything
    lda yMid
    cmp yLastMid
    beq @waiting
@draw_everything:
    jsr check_floor_val
    cmp #0
    beq @not_blocked
    ; Blocked...move back
    lda xLastMid
    sta xMid
    lda yLastMid
    sta yMid
@not_blocked:
    lda xMid
    sta xLastMid
    lda yMid
    sta yLastMid
    jsr set_xy_pos
    jsr calc_draw_bank
    jsr draw_bank_to_pixeldata
@waiting:
    lda waitflag
    cmp #0
    beq @waiting
    stz waitflag
    inc loopCount
    lda loopCount
    cmp #3
    bne @waiting
    stz loopCount
    jsr copy_level_to_vram
    jsr copy_pixeldata_to_vram
    jsr scroll_layers
    bra @main_loop
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
    lda #16
    jsr MEMFILL
    rts
