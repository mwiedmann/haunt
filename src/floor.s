.ifndef FLOOR_S
FLOOR_S = 1

floor: .res 4096
current_tile: .byte 0

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
    cmp #48
    bcc @blocked
    stz current_tile
    rts
@blocked:
    jsr check_treasure
    rts

check_treasure:
    cmp #TREASURE_TILE
    beq @is_treasure
    rts
@is_treasure:
    lda #0
    sta current_tile
    sta (addr)
    ; remove treasure from map
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

    lda #32 ; replace treasure with floor tile
    sta (addr)
    rts

; y=14592
; x=90

; HIRAM=40960
; addr=55642

.endif