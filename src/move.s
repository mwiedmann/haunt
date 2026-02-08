.ifndef MOVE_S
MOVE_S = 1

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
    clc
    adc #POS_ADJUST
    sta xMidAdj
    lda xMid
    sec
    sbc viewRadius
    sta xPosStart
    clc
    adc #POS_ADJUST
    sta xPosStartAdj
    ; Now Y
    lda yMid
    clc
    adc #POS_ADJUST
    sta yMidAdj
    lda yMid
    sec
    sbc viewRadius
    sta yPosStart
    clc
    adc #POS_ADJUST
    sta yPosStartAdj
    rts

hscroll: .word 0
vscroll: .word 0

scroll_layers:
    lda yPosStartAdj
    sta vscroll
    stz vscroll+1
    lda xPosStartAdj
    sta hscroll
    stz hscroll+1
    ; subtract 5 from yPos/vscroll to center it
    lda vscroll
    sec
    sbc #3
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
    sbc #3
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
    lda hscroll
    clc
    adc guyX
    sta hscroll
    lda hscroll+1
    adc #0
    sta hscroll+1

    lda vscroll
    clc
    adc guyY
    sta vscroll
    lda vscroll+1
    adc #0
    sta vscroll+1

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