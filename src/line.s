.ifndef LINE_S
LINE_S = 1

pixelTileId: .byte 0
pixel_spot: .word 0
row_count: .byte 0

copy_pixeldata_to_vram:
    lda #(MAX_VIEW_RADIUS+MAX_VIEW_RADIUS+1)
    sta row_count
    lda #<VISIBLE_AREA_L1_MAPBASE_ADDR
    sta pixel_spot
    lda #>VISIBLE_AREA_L1_MAPBASE_ADDR
    sta pixel_spot+1
    ; Set the pixeldata source address
    lda #<pixeldata
    sta addr
    lda #>pixeldata
    sta addr + 1
    ; Set VRAM address
@next_row:
    lda pixel_spot
    sta VERA_ADDR_LO
    lda pixel_spot+1
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
    ; Increment pixeldata address to next row
    lda pixel_spot
    clc
    adc #128
    sta pixel_spot
    lda pixel_spot+1
    adc #0
    sta pixel_spot+1
    ; change the pixeldata source address
    lda addr
    clc
    adc #((MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1) * 2)
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    bra @next_row
@done:
    rts

tempOffset: .word 0
draw_bank: .byte 0
draw_offset: .word 0
tempX: .byte 0

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

draw_count: .byte 0

; Bank data has a 1 bit per tile representation
; Turn this into 2 bytes
draw_bank_to_pixeldata:
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
    ; Point to the pixeldata
    lda #<pixeldata
    sta addr2
    lda #>pixeldata
    sta addr2 + 1
@next_byte:
    ; Get a byte then pull out the 8 bits
    ldy #8
    lda (addr)
@next_bit:
    asl
    tax ; hold the rest of the bits
    lda #0
    adc #0
    beq @zero_tile
    lda #2 ; Tile 2 for hiding tiles
@zero_tile:
    sta (addr2)
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
    ; draw guy location
    lda guyPixelDataAddr
    sta addr
    lda guyPixelDataAddr+1
    sta addr+1
    lda #3
    sta (addr)
    rts

.endif