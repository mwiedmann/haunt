.ifndef FLOOR_S
FLOOR_S = 1

floor: .res 4096
current_tile: .byte 0

hit_exit: .byte 0
exit_tile: .byte EXIT_TILE

find_start:
    lda #<floor
    sta addr
    lda #>floor
    sta addr + 1
    stz xMid
    stz yMid
@next_tile_check:
    lda (addr)
    cmp exit_tile
    beq @found_start
    ; Advance to next tile
    clc
    lda addr
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    ; Advance x and y
    inc xMid
    lda xMid
    cmp #64
    bne @next_tile_check
    stz xMid
    inc yMid
    bra @next_tile_check
@found_start:
    ; Clear the start tile so we don't immediately exit
    lda #ENTRY_TILE
    sta (addr)
    ; TODO: Change the visual tile
    rts

check_floor_val:
    lda #<floor
    sta addr
    lda #>floor
    sta addr + 1
    ldy #0
@next_y:
    cpy yMid
    beq @move_x
    iny
    clc
    lda addr
    adc #64
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    bra @next_y
@move_x:
    clc
    lda addr
    adc xMid
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda (addr)
    sta current_tile
    cmp #BLOCKING_TILE_MAX
    bcc @blocked
    cmp #TRAP_TILE_MAX
    bcc @check_traps
    stz current_tile
    rts
@blocked:
    jsr check_treasure
    jsr check_exit
    rts
@check_traps:
    jsr check_traps
    rts

check_traps:
    cmp #LAVA_TILE_ID
    beq @lava
    cmp #SPIKES_TILE_ID
    beq @trap
    cmp #PIT_TILE_ID
    beq @trap
    cmp #ACID_TILE_ID
    beq @trap
    cmp #DARTH_TILE_ID
    beq @darts
    cmp #DARTH2_TILE_ID
    beq @darts
    cmp #DARTH3_TILE_ID
    beq @darts
    cmp #DARTV_TILE_ID
    beq @darts
    cmp #DARTV2_TILE_ID
    beq @darts
    cmp #DARTV3_TILE_ID
    beq @darts
    cmp #GAS_TILE_ID
    beq @gas
    cmp #WATER_TILE_ID
    beq @water
    rts
@trap:
    jsr check_if_trap_active
    stz current_tile
    rts
@darts:
    jsr check_if_darts_active
    stz current_tile
    rts
@lava:
    jsr guy_burned
    lda #LAVA_DAMAGE
    sta damage_amount
    jsr dead
    stz current_tile
    rts
@gas:
    lda #GAS_DAMAGE
    sta damage_amount
    jsr dead
    stz current_tile
    rts
@water:
    jsr guy_extinguished
    stz current_tile
    rts

check_if_trap_active:
    lda #TILE_ANIMS_COUNT+1
    sta anim_idx
    lda #<tile_animations
    sta tileanimaddr
    lda #>tile_animations
    sta tileanimaddr+1
@next_tile_anim:
    dec anim_idx
    lda anim_idx
    bne @check_tile_anim
    rts
@check_tile_anim:
    ldy #TileAnim::_tile_id
    lda (tileanimaddr), y
    cmp current_tile
    beq @found_tile_anim
    jsr inc_tileanimaddr
    bra @next_tile_anim
@found_tile_anim:
    ldy #TileAnim::_frame_current
    lda (tileanimaddr), y
    cmp #3
    beq @dead
    rts
@dead:
    lda current_tile
    cmp #PIT_TILE_ID
    beq @pit
    cmp #ACID_TILE_ID
    beq @acid
    lda #SPIKES_DAMAGE
    sta damage_amount
    jsr dead
    rts
@pit:
    lda #1
    sta guy_stunned
    rts
@acid:
    lda #ACID_DAMAGE
    sta damage_amount
    jsr dead
    rts

check_if_darts_active:
    lda #TILE_ANIMS_COUNT+1
    sta anim_idx
    lda #<tile_animations
    sta tileanimaddr
    lda #>tile_animations
    sta tileanimaddr+1
@next_tile_anim:
    dec anim_idx
    lda anim_idx
    bne @check_tile_anim
    rts
@check_tile_anim:
    ldy #TileAnim::_tile_id
    lda (tileanimaddr), y
    cmp current_tile
    beq @found_tile_anim
    jsr inc_tileanimaddr
    bra @next_tile_anim
@found_tile_anim:
    ldy #TileAnim::_frame_current
    lda (tileanimaddr), y
    cmp #0
    bne @dead
    rts
@dead:
    lda #1
    sta guy_stunned
    lda #DART_DAMAGE
    sta damage_amount
    jsr dead
    rts

check_exit:
    cmp #EXIT_TILE
    bcs @maybe_exit
    rts
@maybe_exit:
    cmp #EXIT_TILE+3
    bcc @is_exit
    rts
@is_exit:
    sta exit_tile
    stz current_tile
    inc hit_exit
    inc level
    lda level
    cmp #MAX_LEVEL+1
    bcs @back_to_level_1
    rts
@back_to_level_1:
    lda #1
    sta level
    rts

check_treasure:
    cmp #TREASURE_TILE_START
    bcs @maybe_treasure
    rts
@maybe_treasure:
    cmp #TREASURE_TILE_END+1
    bcc @is_treasure
    rts
@is_treasure:
    ; Add score for treasure
    jsr score_treasure
    ; remove treasure from map
    lda #0
    sta current_tile
    sta (addr)
    lda yMidAdj
    sta yOffset
    stz yOffset+1
    ; Multiply by 256 to get start pos
    stz mapbase_addr
    stz mapbase_addr+1
    ldy #8
@pos_y_start:
    cpy #0
    beq @end_pos_y_start
    dey
    asl yOffset
    rol yOffset+1
    bra @pos_y_start
@end_pos_y_start:
    lda mapbase_addr
    clc
    adc yOffset
    sta mapbase_addr
    lda mapbase_addr+1
    adc yOffset+1
    sta mapbase_addr+1
@check_x_offset:
    ; Map is 32k, across 4 banks
    ; Need to get the starting bank, then advance bank as address moves to next bank
    lda #<HIRAM
    clc
    adc mapbase_addr
    sta addr
    lda #>HIRAM
    adc mapbase_addr+1
    sta addr + 1
    lda #LEVEL_BANK
    sta temp_bank
    jsr check_bank_address
    ; addr should be pointing to correct y location
    ; adjust for x
    stz xOffset+1
    lda xMidAdj
    asl
    sta xOffset
    lda addr
    clc
    adc xOffset
    sta addr
    lda addr+1
    adc xOffset+1
    sta addr+1

    lda #FLOOR_TILE; replace treasure with floor tile
    sta (addr)
    rts

; y=14592
; x=90

; HIRAM=40960
; addr=55642

.endif