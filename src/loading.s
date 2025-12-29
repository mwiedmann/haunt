.ifndef LOADING_S
LOADING_S = 1

level0_filename: .asciiz "level0.bin"
rad10_filename: .asciiz "rad10.bin"

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

load_rad10:
    lda #9
    ldx #<rad10_filename
    ldy #>rad10_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<rad_coords
    ldy #>rad_coords
    jsr LOAD
    rts

.endif