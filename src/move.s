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
    cmp #32-(VIEW_RADIUS+VIEW_RADIUS+1)
    bcc @set_y_start_ok
    lda #32-(VIEW_RADIUS+VIEW_RADIUS+1)
@set_y_start_ok:
    sta yPosStart
    bra @set_y_end
@set_y_start_zero:
    stz yPosStart
@set_y_end:
    lda yMid
    clc
    adc #VIEW_RADIUS
    cmp #32
    bcc @set_y_end_ok
    lda #31
@set_y_end_ok:
    sta yPosEnd
    rts

.endif