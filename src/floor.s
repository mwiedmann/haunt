.ifndef FLOOR_S
FLOOR_S = 1

floor: .res 4096

check_floor_val:
    lda #<floor
    sta addr
    lda #>floor
    sta addr + 1
    ldy #0
@next_y:
    cpy bresenham_y1
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
    adc bresenham_x1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda (addr)
    rts

.endif