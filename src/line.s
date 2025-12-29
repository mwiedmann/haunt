.ifndef LINE_S
LINE_S = 1

pixelTileId: .byte 0
pixel_spot: .word 0

draw_pixeldata:
    lda bresenham_y1
    sec
    sbc yPosStart
    clc
    adc viewRadiusDiff
    tay
    lda #<pixeldata
    sta addr
    lda #>pixeldata
    sta addr + 1
@draw_y:
    cpy #0
    beq @draw_x
    lda addr
    clc
    adc #((MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1) * 2)
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    dey
    bra @draw_y
@draw_x:
    lda bresenham_x1
    sec
    sbc xPosStart
    clc
    adc viewRadiusDiff
    clc
    rol
    clc
    adc addr
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda pixelTileId
    sta (addr)
    rts

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

draw_lr_lines:
    lda xMid
    sta bresenham_x1
    lda yMid
    sta bresenham_y1
    lda #3
    sta pixelTileId
    jsr draw_pixeldata
    lda #0
    sta pixelTileId
    lda xPosStart
    sta x2
    lda yPosStart
    sta y2
@draw_line:
    lda x2
    sta bresenham_x2
    lda xMid
    sta bresenham_x1
    lda y2
    sta bresenham_y2
    lda yMid
    sta bresenham_y1
    jsr init_bresenham
@next_pixel:
    jsr step_bresenham
    jsr draw_pixeldata
    lda bresenham_x1
    cmp bresenham_x2
    bne @next_step
    lda bresenham_y1
    cmp bresenham_y2
    beq @next_line
@next_step:
    jsr check_floor_val
    cmp #0
    bne @next_line
    bra @next_pixel
@next_line:
    lda x2
    cmp xPosStart
    beq @jump_right
    lda xPosStart
    sta x2
    inc y2
    lda yPosEnd
    clc
    adc #1
    cmp y2
    beq @next_phase
    bra @draw_line
@jump_right:
    lda xPosEnd
    sta x2
    bra @draw_line
@next_phase:
    rts

draw_ud_lines:
    lda xPosStart
    sta x2
    inc x2
    lda yPosStart
    sta y2
@draw_line:
    lda x2
    sta bresenham_x2
    lda xMid
    sta bresenham_x1
    lda y2
    sta bresenham_y2
    lda yMid
    sta bresenham_y1
    jsr init_bresenham
@next_pixel:
    jsr step_bresenham
    jsr draw_pixeldata
    lda bresenham_x1
    cmp bresenham_x2
    bne @next_step
    lda bresenham_y1
    cmp bresenham_y2
    beq @next_line
@next_step:
    jsr check_floor_val
    cmp #0
    bne @next_line
    bra @next_pixel
@next_line:
    lda y2
    cmp yPosStart
    beq @jump_down
    lda yPosStart
    sta y2
    inc x2
    lda xPosEnd
    cmp x2
    beq @next_phase
    bra @draw_line
@jump_down:
    lda yPosEnd
    sta y2
    bra @draw_line
@next_phase:
    rts

.endif