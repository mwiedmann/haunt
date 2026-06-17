.ifndef PAL_S
PAL_S = 1

pal_filename: .asciiz "pal.bin"
title_pal_filename: .asciiz "titlepal.bin"
gameover_pal_filename: .asciiz "overpal.bin"

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

load_gameover_pal:
    lda #11
    ldx #<gameover_pal_filename
    ldy #>gameover_pal_filename
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

load_color1_addr:
    lda #<(PALETTE_ADDR+(197*2))
    sta VERA_ADDR_LO
    lda #>(PALETTE_ADDR+(197*2))
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1)
    sta VERA_ADDR_HI_SET
    rts

load_color2_addr:
    lda #<(PALETTE_ADDR+(135*2))
    sta VERA_ADDR_LO
    lda #>(PALETTE_ADDR+(135*2))
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1)
    sta VERA_ADDR_HI_SET
    rts

change_wall_color:
    lda level
    cmp #2
    beq @set_level_2
    cmp #3
    beq @set_level_3
    cmp #4
    beq @set_level_4
    cmp #5
    beq @set_level_5
    cmp #6
    beq @set_level_6
@set_level_1:
    jsr level_1_colors
    rts
@set_level_2:
    jsr level_2_colors
    rts
@set_level_3:
    jsr level_3_colors
    rts
@set_level_4:
    jsr level_4_colors
    rts
@set_level_5:
    jsr level_5_colors
    rts
@set_level_6:
    jsr level_6_colors
    rts


level_1_colors:
    ; Orange walls
    jsr load_color1_addr
    lda #131
    sta VERA_DATA0
    lda #15
    sta VERA_DATA0

    jsr load_color2_addr
    lda #83
    sta VERA_DATA0
    lda #11
    sta VERA_DATA0
    rts

level_2_colors:
    ; Green walls
    jsr load_color1_addr
    lda #%11110000
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    jsr load_color2_addr
    lda #%10000000
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

level_3_colors:
    ; Blue walls
    jsr load_color1_addr
    lda #%1111
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    jsr load_color2_addr
    lda #%1000
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

level_4_colors:
    ; Red walls
    jsr load_color1_addr
    lda #0
    sta VERA_DATA0
    lda #%1111
    sta VERA_DATA0

    jsr load_color2_addr
    lda #0
    sta VERA_DATA0
    lda #%1000
    sta VERA_DATA0
    rts

level_5_colors:
    ; Grey walls
    jsr load_color1_addr
    lda #%11001100
    sta VERA_DATA0
    lda #%1100
    sta VERA_DATA0

    jsr load_color2_addr
    lda #%10001000
    sta VERA_DATA0
    lda #%1000
    sta VERA_DATA0
    rts

level_6_colors:
    ; Purple walls
    jsr load_color1_addr
    lda #%00111111
    sta VERA_DATA0
    lda #%1111
    sta VERA_DATA0

    jsr load_color2_addr
    lda #%00001000
    sta VERA_DATA0
    lda #%1000
    sta VERA_DATA0
    rts

.endif