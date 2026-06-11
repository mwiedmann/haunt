.ifndef PAL_S
PAL_S = 1

pal_filename: .asciiz "pal.bin"
title_pal_filename: .asciiz "titlepal.bin"

load_pal:
    lda #7
    ldx #<pal_filename
    ldy #>pal_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #3 ; VRAM 2nd bank
    ldx #<PALETTE_ADDR 
    ldy #>PALETTE_ADDR
    jsr LOAD
    rts

load_title_pal:
    lda #12
    ldx #<title_pal_filename
    ldy #>title_pal_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #3 ; VRAM 2nd bank
    ldx #<PALETTE_ADDR
    ldy #>PALETTE_ADDR
    jsr LOAD
    rts

change_wall_color:
    lda level
    cmp #2
    beq @set_level_2
@set_level_1:
    lda #<(PALETTE_ADDR+(197*2))
    sta VERA_ADDR_LO
    lda #>(PALETTE_ADDR+(197*2))
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1)
    sta VERA_ADDR_HI_SET
    lda #131
    sta VERA_DATA0
    lda #15
    sta VERA_DATA0

    lda #<(PALETTE_ADDR+(135*2))
    sta VERA_ADDR_LO
    lda #>(PALETTE_ADDR+(135*2))
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1)
    sta VERA_ADDR_HI_SET
    lda #83
    sta VERA_DATA0
    lda #11
    sta VERA_DATA0
    rts
@set_level_2:
    lda #<(PALETTE_ADDR+(197*2))
    sta VERA_ADDR_LO
    lda #>(PALETTE_ADDR+(197*2))
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1)
    sta VERA_ADDR_HI_SET
    lda #%11110000
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    lda #<(PALETTE_ADDR+(135*2))
    sta VERA_ADDR_LO
    lda #>(PALETTE_ADDR+(135*2))
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1)
    sta VERA_ADDR_HI_SET
    lda #%10000000
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

.endif