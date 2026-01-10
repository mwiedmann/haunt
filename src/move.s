.ifndef MOVE_S
MOVE_S = 1

xPosStart: .byte 0
yPosStart: .byte 0
xMid: .byte STARTX
yMid: .byte STARTY
xLastMid: .byte 0
yLastMid: .byte 0

viewRadius: .byte STARTING_VIEW_RADIUS
viewRadiusDiff: .byte (MAX_VIEW_RADIUS-STARTING_VIEW_RADIUS)
viewStartX: .byte 0
viewStartY: .byte 0
viewEndX: .byte 0
viewEndY: .byte 0
guyX: .byte 0
guyY: .byte 0

set_xy_pos:
    lda xMid
    sec
    sbc viewRadius
    sta xPosStart
    ; Now Y
    lda yMid
    sec
    sbc viewRadius
    sta yPosStart
    rts

hscroll: .word 0
vscroll: .word 0

scroll_layers:
    lda guyX
    sta VERA_L1_HSCROLL_L
    lda guyY
    sta VERA_L1_VSCROLL_L
    ; convert 8 to 16 bit yPosStart with code to handle negatives
    lda yPosStart
    sta vscroll
    bmi @neg_y
    stz vscroll+1
    bra @y_pos_set
@neg_y:
    lda #255
    sta vscroll+1
@y_pos_set:
    ; convert 8 to 16 bit with code to handle negatives
    lda xPosStart
    sta hscroll
    bmi @neg_x
    stz hscroll+1
    bra @x_pos_set
@neg_x:
    lda #255
    sta hscroll+1
@x_pos_set:
    ; subtract 5 from yPos/vscroll to center it
    lda vscroll
    sec
    sbc #5
    sta vscroll
    lda vscroll+1
    sbc #0
    sta vscroll+1
    ; Multiply vscroll by 16 (tile size)
    ldy #4
@next_vscroll:
    cpy #0
    beq @end_vscroll
    dey
    asl vscroll
    rol vscroll+1
    bra @next_vscroll
@end_vscroll:
    ; subtract 10 from xPos/hscroll to center it
    lda hscroll
    sec
    sbc #10
    sta hscroll
    lda hscroll+1
    sbc #0
    sta hscroll+1
    ; Multiply hscroll by 16 (tile size)
    ldy #4
@next_hscroll:
    cpy #0
    beq @end_hscroll
    dey
    asl hscroll
    rol hscroll+1
    bra @next_hscroll
@end_hscroll:
    ; TODO: add guy position
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