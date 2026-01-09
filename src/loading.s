.ifndef LOADING_S
LOADING_S = 1

level0_filename: .asciiz "level0.bin"
precalc_filename: .asciiz "precalc.bin"

load_level0:
    lda #10
    ldx #<level0_filename
    ldy #>level0_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<floor
    ldy #>floor
    jsr LOAD
    rts

load_precalc:
    stz BANK
    lda #11
    ldx #<precalc_filename
    ldy #>precalc_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD
    rts

.endif