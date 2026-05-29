.ifndef LOADING_S
LOADING_S = 1

floor_filename: .asciiz "l00floor.bin"
mapbase_filename: .asciiz "l00map.bin"
precalc_filename: .asciiz "l00calc.bin"
gasmap_filename: .asciiz "l00gas.bin"
tiles_filename: .asciiz "tiles.bin"
ui_filename: .asciiz "ui.bin"
torch_filename: .asciiz "torch.bin"
torch_floor_filename: .asciiz "torchflr.bin"
spikes_filename: .asciiz "spikes.bin"
pit_filename: .asciiz "pit.bin"
darth_filename: .asciiz "darth.bin"
dartv_filename: .asciiz "dartv.bin"
lava_filename: .asciiz "lava.bin"
guy_filename: .asciiz "guy.bin"
gas_filename: .asciiz "gas.bin"
acid_filename: .asciiz "acid.bin"

load_level_files:
    ; Floor data
    lda #12
    ldx #<floor_filename
    ldy #>floor_filename
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
    lda #10
    ldx #<mapbase_filename
    ldy #>mapbase_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD
    ; Level gas map into banked ram
    lda #GAS_BANK
    sta BANK
    lda #10
    ldx #<gasmap_filename
    ldy #>gasmap_filename
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
    jsr load_darth
    jsr load_dartv
    jsr load_lava
    jsr load_gas
    jsr load_acid
    jsr load_guy
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

load_darth:
    lda #ANIM_BANK
    sta BANK
    lda #9
    ldx #<darth_filename
    ldy #>darth_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<DARTH_MEM_ADDR
    ldy #>DARTH_MEM_ADDR
    jsr LOAD
    rts

load_dartv:
    lda #ANIM_BANK
    sta BANK
    lda #9
    ldx #<dartv_filename
    ldy #>dartv_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<DARTV_MEM_ADDR
    ldy #>DARTV_MEM_ADDR
    jsr LOAD
    rts

load_lava:
    lda #ANIM_BANK
    sta BANK
    lda #8
    ldx #<lava_filename
    ldy #>lava_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<LAVA_MEM_ADDR
    ldy #>LAVA_MEM_ADDR
    jsr LOAD
    rts

load_gas:
    lda #ANIM_BANK
    sta BANK
    lda #7
    ldx #<gas_filename
    ldy #>gas_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<GAS_MEM_ADDR
    ldy #>GAS_MEM_ADDR
    jsr LOAD
    rts

load_acid:
    lda #ANIM_BANK2
    sta BANK
    lda #8
    ldx #<acid_filename
    ldy #>acid_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<ACID_MEM_ADDR
    ldy #>ACID_MEM_ADDR
    jsr LOAD
    rts

load_guy:
    lda #7
    ldx #<guy_filename
    ldy #>guy_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #2 ; VRAM 1st bank
    ldx #<GUY_MEM_ADDR
    ldy #>GUY_MEM_ADDR
    jsr LOAD
    rts

.endif