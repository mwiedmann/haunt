.ifndef LINE_S
LINE_S = 1

temp_bank: .byte 0

check_bank_address:
    ; subtract 8192 and increase bank each time we can
    ; We have the high byte loaded, see if it is >=8192
@check_bank_address:
    lda addr+1
    cmp #>(HIRAM+8192)
    bcs @next_bank
    bra @done
@next_bank:
    ; subtract 8192 from the address and inc the bank
    lda addr
    sec
    sbc #<8192
    sta addr
    lda addr+1
    sbc #>8192
    sta addr+1
    inc temp_bank
    bra @check_bank_address
@done:
    lda temp_bank
    sta BANK
    rts

; Copy the area of the map we are about to view
; This gives us a fresh copy of the tiles that we can then hide as needed
copy_map_to_vram:
    lda #LEVEL_BANK
    sta temp_bank
    ; Map is 32k, across 4 banks
    ; Need to get the starting bank, then advance bank as address moves to next bank
    ; This part only works because mapbase starts at address 0
    lda mapbase_addr
    sta addr2
    lda mapbase_addr+1
    sta addr2+1
    lda #(MAX_VIEW_RADIUS+MAX_VIEW_RADIUS+1)
    sta row_count
    ; Set the pixeldata source address
    lda #<HIRAM
    clc
    adc addr2
    sta addr
    lda #>HIRAM
    adc addr2+1
    sta addr + 1
    jsr check_bank_address
    ; Set VRAM address
@next_row:
    lda addr2
    sta VERA_ADDR_LO
    lda addr2+1
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda addr
    sta R0L
    lda addr + 1
    sta R0H
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<((MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1) * 2)
    sta R2L
    lda #>((MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1) * 2)
    sta R2H
    jsr MEMCOPY
    dec row_count
    lda row_count
    cmp #0
    beq @done
    ; Increment mapbase address to next row
    lda addr2
    clc
    adc #<L0_MB_ROW_SIZE
    sta addr2
    lda addr2+1
    adc #>L0_MB_ROW_SIZE
    sta addr2+1
    ; change the pixeldata source address
    lda addr
    clc
    adc #<L0_MB_ROW_SIZE
    sta addr
    lda addr+1
    adc #>L0_MB_ROW_SIZE
    sta addr+1
    jsr check_bank_address
    bra @next_row
@done:
    rts

; This is the precalced view data
calc_draw_bank:
    stz tempOffset
    stz draw_offset
    stz draw_offset+1
    lda #1
    sta draw_bank
    ldx yMid
@next_y:
    dex
    cpx #0
    beq @x_offset
    clc
    lda tempOffset
    adc #62
    sta tempOffset
    lda tempOffset+1
    adc #0
    sta tempOffset+1
    bra @next_y
@x_offset:
    lda xMid
    dec
    clc
    adc tempOffset
    sta tempOffset
    lda tempOffset+1
    adc #0
    sta tempOffset+1
    ; now find the bank and bank offset
    ; see if we are <128
@next_bank:
    lda tempOffset+1
    beq @hi_zero
    ; hi is not zero so we are still >=128
    bra @sub_128
@hi_zero:
    lda tempOffset
    cmp #128
    bcs @sub_128
    ; found bank
    ; now get memory offset
@next_mem_offset:
    lda tempOffset
    beq @done
    dec tempOffset
    clc
    lda draw_offset
    adc #64
    sta draw_offset
    lda draw_offset+1
    adc #0
    sta draw_offset+1
    bra @next_mem_offset
@sub_128:
    ; subtract 128
    sec
    lda tempOffset
    sbc #128
    sta tempOffset
    lda tempOffset+1
    sbc #0
    sta tempOffset+1
    inc draw_bank
    bra @next_bank
@done:
    ; draw_bank has bank
    ; draw_offset has the mem offset in this bank
    rts

; Bank data has a 1 bit per tile representation
; Turn this into 2 bytes
draw_bank_to_vram:
    lda yPosStartAdj
    sta yOffset
    stz yOffset+1
    ; Multiply by 256 to get start pos
    lda #<MAPBASE_L0_ADDR
    sta mapbase_addr
    lda #>MAPBASE_L0_ADDR
    sta mapbase_addr+1
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
    ; mapbase_addr should be pointing to correct y location
    ; adjust for x
    stz xOffset+1
    lda xPosStartAdj
    asl
    sta xOffset
    lda mapbase_addr
    clc
    adc xOffset
    sta mapbase_addr
    lda mapbase_addr+1
    adc xOffset+1
    sta mapbase_addr+1
    bra @end_x_pos
@end_x_pos:
    jsr copy_map_to_vram
    stz draw_count
    ; Set bank
    lda draw_bank
    sta BANK
    ; Point addr to Banked RAM
    lda #<HIRAM
    sta addr
    lda #>HIRAM
    sta addr + 1
    ; Add the offset for the x/y precalced data
    clc
    lda addr
    adc draw_offset
    sta addr
    lda addr+1
    adc draw_offset+1
    sta addr+1
    ; Point to the mapbase
    lda mapbase_addr
    sta VERA_ADDR_LO
    lda mapbase_addr+1
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC2_BITS
    sta VERA_ADDR_HI_SET
    stz write_count
    stz tile_count
@next_byte:
    ; Get a byte then pull out the 8 bits
    ldy #8
    lda (addr)
@next_bit:
    inc tile_count
    asl
    tax ; hold the rest of the bits
    lda #0
    adc #0
    beq @zero_tile
    lda #16 ; Tile 16 for hiding tiles
    sta VERA_DATA0
    bra @move_addr
@zero_tile:
    lda tile_count
    cmp #221
    bne @no_guy
    lda #17
    sta VERA_DATA0
    bra @move_addr
@no_guy:
    lda VERA_DATA0 ; Skip overwriting this tile...just read it to advance
@move_addr:
    inc write_count
    lda write_count
    cmp #(MAX_VIEW_RADIUS+MAX_VIEW_RADIUS+1)
    bne @continue_writes
    ; end of mapbase row, go to next row
    stz write_count
    lda mapbase_addr
    clc
    adc #<L0_MB_ROW_SIZE
    sta mapbase_addr
    lda mapbase_addr+1
    adc #>L0_MB_ROW_SIZE
    sta mapbase_addr+1
    lda mapbase_addr
    sta VERA_ADDR_LO
    lda mapbase_addr+1
    sta VERA_ADDR_MID
@continue_writes:
    clc
    lda addr2
    adc #2
    sta addr2
    lda addr2+1
    adc #0
    sta addr2+1
    txa ; restore the rest of the bits
    dey
    cpy #0
    bne @next_bit ; 8 bits done
    ; go to the next byte
    inc draw_count
    lda draw_count
    cmp #56
    beq @done
    ; More bytes
    ; Go to next source byte
    clc
    lda addr
    adc #1
    sta addr
    lda addr+1
    adc #0
    sta addr+1
    bra @next_byte
@done:
    rts

.endif