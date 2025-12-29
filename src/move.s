.ifndef MOVE_S
MOVE_S = 1

xPosStart: .byte 0
yPosStart: .byte 0
xMid: .byte STARTX
yMid: .byte STARTY
xPosEnd: .byte 0
yPosEnd: .byte 0

set_xy_pos:
    lda xMid
    sec
    sbc #VIEW_RADIUS
    bmi @set_x_start_zero
    sta xPosStart
    bra @set_x_end
@set_x_start_zero:
    stz xPosStart
@set_x_end:
    lda xMid
    clc
    adc #VIEW_RADIUS
    cmp #64
    bcc @set_x_end_ok
    lda #63
@set_x_end_ok:
    sta xPosEnd
    ; Now Y
    lda yMid
    sec
    sbc #VIEW_RADIUS
    bmi @set_y_start_zero
    sta yPosStart
    bra @set_y_end
@set_y_start_zero:
    stz yPosStart
@set_y_end:
    lda yMid
    clc
    adc #VIEW_RADIUS
    cmp #64
    bcc @set_y_end_ok
    lda #63
@set_y_end_ok:
    sta yPosEnd
    rts

hscroll: .word 0
vscroll: .word 0

scroll_layers:
    ; Scroll L0 map
    stz hscroll
    stz hscroll+1
    stz vscroll
    stz vscroll+1
    lda yPosStart
    sec
    sbc #L0_START_Y
    tay
@next_vscroll:
    cpy #0
    beq @end_vscroll
    dey
    lda vscroll
    clc
    adc #16
    sta vscroll
    lda vscroll+1
    adc #0
    sta vscroll+1
    bra @next_vscroll
@end_vscroll:
    lda xPosStart
    sec
    sbc #L0_START_X
    tay
@next_hscroll:
    cpy #0
    beq @set_scroll
    dey
    lda hscroll
    clc
    adc #16
    sta hscroll
    lda hscroll+1
    adc #0
    sta hscroll+1
    bra @next_hscroll
@set_scroll:
    lda hscroll
    sta VERA_L0_HSCROLL_L
    lda hscroll+1
    sta VERA_L0_HSCROLL_H
    lda vscroll
    sta VERA_L0_VSCROLL_L
    lda vscroll+1
    sta VERA_L0_VSCROLL_H
@done:
    rts

.endif