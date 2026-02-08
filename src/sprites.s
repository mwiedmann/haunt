.ifndef SPRITES_S
SPRITES_S = 1

active_sprite: .word 0
sprite_offset: .word 0
sprite_img_addr: .dword 0
pts_sprite_num: .byte 0

point_to_sprite:
    lda #<SPRITE_ADDR
    sta active_sprite
    lda #>SPRITE_ADDR
    sta active_sprite+1
    lda pts_sprite_num
    ldx #0
    stx sprite_offset+1 ; Clear it out for some shifting
@mult_8: ; Mult sprite num by 8 to get the memory offset of that sprite
    clc
    rol
    sta sprite_offset
    lda sprite_offset+1
    rol
    sta sprite_offset+1
    lda sprite_offset
    inx
    cpx #3
    bne @mult_8
    ; sprite_offset now ready to add to the active_sprite
    clc
    lda active_sprite
    adc sprite_offset
    sta active_sprite
    lda active_sprite+1
    adc sprite_offset+1
    sta active_sprite+1
    ; We have the address of the sprite...point to to
    lda active_sprite
    sta VERA_ADDR_LO
    lda active_sprite+1
    sta VERA_ADDR_MID
    lda #(VERA_ADDR_HI_INC_BITS+1) ; Sprites are in 2nd bank of VRAM
    sta VERA_ADDR_HI_SET
    rts

create_guy:
    lda #<(TILEBASE_L1_ADDR+(GUY_TILE*256))
    sta sprite_img_addr
    lda #>(TILEBASE_L1_ADDR+(GUY_TILE*256))
    sta sprite_img_addr+1
    stz sprite_img_addr+2
@start_shift: ; Shift the image addr bits as sprites use bits 12:5 and 16:13 (we default 16 to 0)
    clc
    lda sprite_img_addr+2
    ror
    sta sprite_img_addr+2
    lda sprite_img_addr+1
    ror
    sta sprite_img_addr+1
    lda sprite_img_addr
    ror
    sta sprite_img_addr
    inx
    cpx #5
    bne @start_shift

    lda #1
    sta pts_sprite_num
    jsr point_to_sprite

    lda sprite_img_addr ; Frame addr lo
    sta VERA_DATA0 ; Write the lo addr for the sprite frame based on ang
    lda sprite_img_addr+1 ; Frame addr hi
    ora #%10000000 ; Keep the 256 color mode on
    sta VERA_DATA0 ; Write the hi addr for the sprite frame based on ang
    lda #<GUY_PIXEL_X
    sta VERA_DATA0
    lda #>GUY_PIXEL_X
    sta VERA_DATA0
    lda #<GUY_PIXEL_Y
    sta VERA_DATA0
    lda #>GUY_PIXEL_Y
    sta VERA_DATA0
    lda #%00001000
    sta VERA_DATA0
    lda #%01010000
    sta VERA_DATA0

    rts

.endif