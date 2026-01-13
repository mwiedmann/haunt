.ifndef VIEW_S
VIEW_S = 1

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

setup_l1_view:
    lda #(MAX_VIEW_RADIUS+MAX_VIEW_RADIUS+1)
    sta row_count
    lda #<VISIBLE_AREA_L1_MAPBASE_ADDR
    sta addr
    lda #>VISIBLE_AREA_L1_MAPBASE_ADDR
    sta addr+1
@next_row:
    lda addr
    sta VERA_ADDR_LO
    lda addr+1
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda #<VERA_DATA0
    sta R0L
    lda #>VERA_DATA0
    sta R0H
    lda #<((MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1) * 2)
    sta R1L
    lda #>((MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1) * 2)
    sta R1H
    lda #0
    jsr MEMFILL
    dec row_count
    lda row_count
    cmp #0
    beq @done
    ; Increment pixeldata address to next row
    lda addr
    clc
    adc #128
    sta addr
    lda addr+1
    adc #0
    sta addr+1
    bra @next_row
@done:
    rts
    
.endif