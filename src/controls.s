.ifndef CONTROLS_S
CONTROLS_S = 1

joy_a: .byte 0
joy_x: .byte 0

joy1:
    lda #0
    jsr JOYGET
    sta joy_a ; hold the joystick A state
    stx joy_x ; hold the joystick X state
    lda #1
    jsr JOYGET
    and joy_a
    sta joy_a
    txa
    and joy_x
    sta joy_x
    lda joy_a
    rts

moved: .byte 0

check_controls:
    stz moved
    jsr joy1
    lda joy_a
    bit #%1000
    bne @check_down
    lda guyY
    sec
    sbc #GUY_SPEED
    sta guyY
    inc moved
    bra @check_left
@check_down:
    lda joy_a
    bit #%100
    bne @check_left
    lda guyY
    clc
    adc #GUY_SPEED
    sta guyY
    inc moved
@check_left:
    lda joy_a
    bit #%10 ; Pressing left?
    bne @check_right
    lda guyX
    sec
    sbc #GUY_SPEED
    sta guyX
    inc moved
    bra @done_move
@check_right:
    lda joy_a
    bit #%1 ; Pressing right?
    bne @done_move
    lda guyX
    clc
    adc #GUY_SPEED
    sta guyX
    inc moved
@done_move:
    lda moved
    beq @check_other
    lda guyX
    bmi @neg_x
    cmp #16
    bcc @check_y
    sbc #16
    sta guyX
    inc xMid
    bra @check_y
@neg_x:
    clc
    adc #16
    sta guyX
    dec xMid
@check_y:
    lda guyY
    bmi @neg_y
    cmp #16
    bcc @check_other
    sbc #16
    sta guyY
    inc yMid
    bra @check_other
@neg_y:
    clc
    adc #16
    sta guyY
    dec yMid
@check_other:
@done:
    rts

.endif