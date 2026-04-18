.ifndef LOADING_S
LOADING_S = 1

l0_floor_filename: .asciiz "l0floor.bin"
l0_mapbase_filename: .asciiz "l0map.bin"
precalc_filename: .asciiz "precalc.bin"
tiles_filename: .asciiz "tiles.bin"
ui_filename: .asciiz "ui.bin"
torch_filename: .asciiz "torch.bin"
torch_floor_filename: .asciiz "torchflr.bin"
spikes_filename: .asciiz "spikes.bin"
pit_filename: .asciiz "pit.bin"

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
    lda #3 ; VRAM 2nd bank
    ldx #<TILEBASE_L0_ADDR
    ldy #>TILEBASE_L0_ADDR
    jsr LOAD
    rts

load_ui:
    lda #6
    ldx #<ui_filename
    ldy #>ui_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #2 ; VRAM 1st bank
    ldx #<MAPBASE_L1_ADDR
    ldy #>MAPBASE_L1_ADDR
    jsr LOAD
    rts

load_animated_tiles:
    jsr load_torch
    jsr load_torch_floor
    jsr load_spikes
    jsr load_pit
    rts

load_torch:
    lda #ANIM_BANK
    sta BANK
    lda #9
    ldx #<torch_filename
    ldy #>torch_filename
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

load_torch_floor:
    lda #ANIM_BANK
    sta BANK
    lda #12
    ldx #<torch_floor_filename
    ldy #>torch_floor_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<TORCH_FLOOR_MEM_ADDR
    ldy #>TORCH_FLOOR_MEM_ADDR
    jsr LOAD
    rts

load_spikes:
    lda #ANIM_BANK
    sta BANK
    lda #10
    ldx #<spikes_filename
    ldy #>spikes_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<SPIKES_MEM_ADDR
    ldy #>SPIKES_MEM_ADDR
    jsr LOAD
    rts

load_pit:
    lda #ANIM_BANK
    sta BANK
    lda #7
    ldx #<pit_filename
    ldy #>pit_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<PIT_MEM_ADDR
    ldy #>PIT_MEM_ADDR
    jsr LOAD
    rts

.endif