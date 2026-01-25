.zeropage
    addr: .res 2
    addr2: .res 2
    mapbase_addr: .res 2
    yOffset: .res 2
    xOffset: .res 2
    row_count: .res 1
    tempOffset: .res 2
    draw_bank: .res 1
    draw_offset: .res 2
    draw_count: .res 1
    xPosStart: .res 1
    xPosStartAdj: .res 1
    yPosStart: .res 1
    yPosStartAdj: .res 1
    xMid: .res 1
    xMidAdj: .res 1
    yMid: .res 1
    yMidAdj: .res 1
    xLastMid: .res 1
    yLastMid: .res 1
    
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
.include "move.s"
.include "floor.s"
.include "draw.s"
.include "loading.s"
.include "controls.s"
.include "pal.s"
.include "sprites.s"

loopCount: .byte 0

start:
    jsr config
    jsr irq_config
    jsr load_pal_to_banks
    jsr swap_pal1
    jsr load_tiles
    jsr load_ui
    jsr load_level0
    jsr load_precalc
    jsr clear_extra_vram_row
    jsr create_guy
    lda #STARTX
    sta xMid
    lda #STARTY
    sta yMid
    jsr set_xy_pos
    bra @draw_everything ; initial draw
@main_loop:
    jsr check_controls
    lda moved
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
    jsr draw_bank_to_vram_hold
@waiting:
    jsr check_wait
    jsr check_pal
    jsr scroll_layers
    jsr copy_vram_hold_to_vram
    bra @main_loop
@scroll_only:
    jsr check_wait
    jsr check_pal
    jsr scroll_layers
    bra @main_loop
    rts

check_wait:
    lda waitflag
    cmp #0
    beq check_wait
    stz waitflag
    inc loopCount
    lda loopCount
    cmp #WAIT_COUNT
    bne check_wait
    stz loopCount
    rts

check_pal:
    inc pal_count
    lda pal_count
    cmp #24
    bne @no_pal
    jsr RAND
@check_num:
    cmp #16
    bcc @num_ok
    lsr
    bra @check_num
@num_ok:
    cmp #8
    bcc @num_too_small
    bra @store_num
@num_too_small:
    lda #8
@store_num:
    sta pal_count
    jsr rotate_pal
@no_pal:
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

