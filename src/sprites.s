.ifndef SPRITES_S
SPRITES_S = 1

active_sprite: .word 0
sprite_offset: .word 0
sprite_img_addr: .dword 0
pts_sprite_num: .byte 0

guy_anim_frame: .byte 0
guy_anim_frame_count: .byte GUY_ANIM_COUNT
guy_image_addr_adjusted: .word 0
guyfire_image_addr_adjusted: .word 0
guy_left: .byte 0

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
    lda #<GUY_MEM_ADDR
    sta sprite_img_addr
    lda #>GUY_MEM_ADDR
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
    ora #%10000000 ; Keep the 256 color mode on, plus bank 1 in VRAM
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

    lda sprite_img_addr
    sta guy_image_addr_adjusted
    lda sprite_img_addr+1
    sta guy_image_addr_adjusted+1

    lda sprite_img_addr
    clc
    adc #72
    sta guyfire_image_addr_adjusted
    lda sprite_img_addr+1
    adc #0
    sta guyfire_image_addr_adjusted+1
    
    rts

guy_still:
    lda #1
    sta pts_sprite_num
    jsr point_to_sprite
    lda guy_on_fire
    bne @on_fire
    lda #<GUY_STILL_ADDR_ADJUSTED
    sta VERA_DATA0
    lda #>GUY_STILL_ADDR_ADJUSTED
    ora #%10000000 ; Keep the 256 color mode on, plus bank 1 in VRAM
    sta VERA_DATA0 ; Write the hi addr for the sprite frame based on ang
    rts
@on_fire:
    lda #<GUYFIRE_STILL_ADDR_ADJUSTED
    sta VERA_DATA0
    lda #>GUYFIRE_STILL_ADDR_ADJUSTED
    ora #%10000000 ; Keep the 256 color mode on, plus bank 1 in VRAM
    sta VERA_DATA0 ; Write the hi addr for the sprite frame based on ang
    rts

guy_reset_frames:
    lda #GUY_ANIM_COUNT
    sta guy_anim_frame_count
    stz guy_anim_frame
    rts

move_guy_sprite:
    dec guy_anim_frame_count
    lda guy_anim_frame_count
    bne @done

    ; Next frame
    lda sprite_img_addr
    clc
    adc #%1000
    sta sprite_img_addr
    lda sprite_img_addr+1
    adc #0
    sta sprite_img_addr+1

    lda #GUY_ANIM_COUNT
    sta guy_anim_frame_count
    inc guy_anim_frame
    lda guy_anim_frame
    cmp #GUY_FRAMES
    bne @update_frame
    stz guy_anim_frame
    ; Reset to first frame
    lda guy_on_fire
    bne @on_fire
    lda guy_image_addr_adjusted
    sta sprite_img_addr
    lda guy_image_addr_adjusted+1
    sta sprite_img_addr+1
    stz sprite_img_addr+2
    bra @update_frame
@on_fire:
    lda guyfire_image_addr_adjusted
    sta sprite_img_addr
    lda guyfire_image_addr_adjusted+1
    sta sprite_img_addr+1
    stz sprite_img_addr+2
@update_frame:
    lda #1
    sta pts_sprite_num
    jsr point_to_sprite
    
    ; We have the new address of the sprite frame...point to to
    lda sprite_img_addr
    sta VERA_DATA0 ; Write the lo addr for the sprite frame based on ang
    lda sprite_img_addr+1
    ora #%10000000 ; Keep the 256 color mode on, plus bank 1 in VRAM
    sta VERA_DATA0 ; Write the hi addr for the sprite frame based on ang

    ; Skip the x/y attribs
    lda VERA_DATA0
    lda VERA_DATA0
    lda VERA_DATA0
    lda VERA_DATA0

    lda guy_left
    beq @not_left
    lda #%00001001
    sta VERA_DATA0
    bra @done
@not_left:
    lda #%00001000
    sta VERA_DATA0
@done:
    rts

.endif