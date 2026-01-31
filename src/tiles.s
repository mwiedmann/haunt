.ifndef TILES_S
TILES_S = 1

torch_anim_count: .byte TORCH_ANIM_COUNT
torch_frame: .byte 0

torch_anim:
    dec torch_anim_count
    lda torch_anim_count
    beq @next_torch_frame
    rts
@next_torch_frame:
    lda #TORCH_ANIM_COUNT
    sta torch_anim_count
    inc torch_frame
    lda torch_frame
    cmp #TORCH_FRAMES
    bne @next_torch_tile
    stz torch_frame
@next_torch_tile:
    lda #ANIM_BANK
    sta BANK
    lda #<TORCH_MEM_ADDR
    sta addr2
    lda #>TORCH_MEM_ADDR
    sta addr2+1
    ldx torch_frame
@check_frame:
    ; move to correct frame
    beq @frame_set
    dex
    inc addr2+1
    cpx #0
    bra @check_frame
@frame_set:
    lda #<TORCH_TILE_ADDR
    sta VERA_ADDR_LO
    lda #>TORCH_TILE_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET

    lda addr2
    sta R0L
    lda addr2 + 1
    sta R0H
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<256
    sta R2L
    lda #>256
    sta R2H
    jsr MEMCOPY
    
    rts

.endif