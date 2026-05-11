.ifndef GAS_S
GAS_S = 1

gas_counter: .byte GAS_START_TIME
gas_x_start: .byte STARTX-1
gas_y_start: .byte STARTY-1
gas_x_end: .byte STARTX+2
gas_y_end: .byte STARTY+2

gas_x_current: .byte 0
gas_y_current: .byte 0

gas_spread: .byte 0

check_gas:
    stz gas_spread
    dec gas_counter
    lda gas_counter
    beq @next_gas
    rts
@next_gas:
    lda #1
    sta gas_spread
    lda #GAS_SPREAD_TIME ; time to next spread
    sta gas_counter
    lda gas_x_start
    sta gas_x_current
    lda gas_y_start
    sta gas_y_current
    jsr get_floor_val
    ; Add gas to the floor
@next_x:
    lda gas_x_current
    cmp gas_x_end
    beq @next_y
    jsr add_gas_to_floor
    inc gas_x_current
    lda addr2
    clc
    adc #1
    sta addr2
    lda addr2 + 1
    adc #0
    sta addr2 + 1
    bra @next_x
@next_y:
    lda gas_x_start
    sta gas_x_current
    inc gas_y_current
    lda gas_y_current
    cmp gas_y_end
    beq @done_gas
    jsr get_floor_val
    bra @next_x
@done_gas:
    lda gas_x_start
    cmp #1
    beq @x_min
    dec gas_x_start
@x_min:
    lda gas_x_end
    cmp #63
    beq @x_max
    inc gas_x_end
@x_max:
    lda gas_y_start
    cmp #1
    beq @y_min
    dec gas_y_start
@y_min:
    lda gas_y_end
    cmp #63
    beq @y_max
    inc gas_y_end
@y_max:
    rts

add_gas_to_floor:
    ; Only need to add the outside edges of the gas, since the inside will already be gas
    lda gas_x_current
    cmp gas_x_start
    beq @add_gas
    inc
    cmp gas_x_end
    beq @add_gas
    ; also the entire top and bottom rows
    lda gas_y_current
    cmp gas_y_start
    beq @add_gas
    inc
    cmp gas_y_end
    beq @add_gas
    rts
@add_gas:
    ; Don't replace walls
    lda (addr2)
    cmp #GAS_MAX_TILE_ID
    bcc @wall
    lda #GAS_TILE_ID
    sta (addr2) ; add gas to floor
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
@wall:
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
