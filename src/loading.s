.ifndef LOADING_S
LOADING_S = 1

l0_floor_filename: .asciiz "l0floor.bin"
l0_mapbase_filename: .asciiz "l0map.bin"
precalc_filename: .asciiz "precalc.bin"
tiles_filename: .asciiz "tiles.bin"

load_level0:
    ; Floor data
    lda #11
    ldx #<l0_floor_filename
    ldy #>l0_floor_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<floor
    ldy #>floor
    jsr LOAD
    ; Level data into banked ram
    lda #LEVEL_BANK
    sta BANK
    lda #9
    ldx #<l0_mapbase_filename
    ldy #>l0_mapbase_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD
    rts

copy_level_to_vram:
    ; Copy the level from banked ram to the L0 MAPBASE
    jsr copy_bank_1
    jsr copy_bank_2
    jsr copy_bank_3
    jsr copy_bank_4
    rts

copy_bank_1:
    lda #LEVEL_BANK
    sta BANK
    lda #<HIRAM
    sta R0L
    lda #>HIRAM
    sta R0H
    lda #<MAPBASE_L0_ADDR
    sta VERA_ADDR_LO
    lda #>MAPBASE_L0_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<8192
    sta R2L
    lda #>8192
    sta R2H
    jsr MEMCOPY
    rts

copy_bank_2:
    lda #(LEVEL_BANK+1)
    sta BANK
    lda #<HIRAM
    sta R0L
    lda #>HIRAM
    sta R0H
    lda #<(MAPBASE_L0_ADDR+8192)
    sta VERA_ADDR_LO
    lda #>(MAPBASE_L0_ADDR+8192)
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<8192
    sta R2L
    lda #>8192
    sta R2H
    jsr MEMCOPY
    rts

copy_bank_3:
    lda #(LEVEL_BANK+2)
    sta BANK
    lda #<HIRAM
    sta R0L
    lda #>HIRAM
    sta R0H
    lda #<(MAPBASE_L0_ADDR+16384)
    sta VERA_ADDR_LO
    lda #>(MAPBASE_L0_ADDR+16384)
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<8192
    sta R2L
    lda #>8192
    sta R2H
    jsr MEMCOPY
    rts

copy_bank_4:
    lda #(LEVEL_BANK+3)
    sta BANK
    lda #<HIRAM
    sta R0L
    lda #>HIRAM
    sta R0H
    lda #<(MAPBASE_L0_ADDR+24576)
    sta VERA_ADDR_LO
    lda #>(MAPBASE_L0_ADDR+24576)
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<8192
    sta R2L
    lda #>8192
    sta R2H
    jsr MEMCOPY
    rts

load_precalc:
    lda #1
    sta BANK
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

load_tiles:
    lda #9
    ldx #<tiles_filename
    ldy #>tiles_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #2 ; VRAM 1st bank
    ldx #<TILEBASE_L0_ADDR
    ldy #>TILEBASE_L0_ADDR
    jsr LOAD
    rts

.endif