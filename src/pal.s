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

.endif