.ifndef GAS_S
GAS_S = 1

gas_counter: .word GAS_START_TIME
gas_x_current: .byte 0
gas_y_current: .byte 0

gas_spread: .byte 0 ; signals if need to redraw

check_gas:
    stz gas_spread
    lda gas_counter
    sec
    sbc #1
    sta gas_counter
    lda gas_counter+1
    sbc #0
    sta gas_counter+1
    lda gas_counter
    bne @done
    lda gas_counter+1
    bne @done
@trigger_gas:
    lda #1
    sta gas_spread
    lda #GAS_SPREAD_TIME ; time to next spread
    sta gas_counter
@next_gas:
    lda #GAS_BANK
    sta BANK
    lda (gasaddr)
    cmp #GAS_DONE_MARKER
    beq @done
    cmp #GAS_ITERATION_MARKER
    beq @iteration_done
    sta gas_x_current
    jsr inc_gasaddr
    lda (gasaddr)
    sta gas_y_current
    jsr get_floor_val
    lda #GAS_TILE_ID
    sta (addr2) ; add gas to floor
    jsr add_gas_to_stored_mapbase
    jsr inc_gasaddr
    bra @next_gas
@iteration_done:
    jsr inc_gasaddr
@done:
    rts

inc_gasaddr:
    lda gasaddr
    clc
    adc #1
    sta gasaddr
    lda gasaddr + 1
    adc #0
    sta gasaddr + 1
    rts

add_gas_to_stored_mapbase:
    ; Now update the stored mapbase
    lda gas_y_current
    clc
    adc #POS_ADJUST
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
    lda gas_x_current
    clc
    adc #POS_ADJUST
    asl
    sta xOffset
    lda addr
    clc
    adc xOffset
    sta addr
    lda addr+1
    adc xOffset+1
    sta addr+1
    lda #GAS_TILE_ID ; replace with gas
    sta (addr)
    rts

get_floor_val:
    lda #<floor
    sta addr2
    lda #>floor
    sta addr2 + 1
    ldy #0
@next_y:
    cpy gas_y_current
    beq @move_x
    iny
    clc
    lda addr2
    adc #64
    sta addr2
    lda addr2 + 1
    adc #0
    sta addr2 + 1
    bra @next_y
@move_x:
    clc
    lda addr2
    adc gas_x_current
    sta addr2
    lda addr2 + 1
    adc #0
    sta addr2 + 1
    rts

.endif
