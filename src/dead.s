.ifndef DEAD_S
DEAD_S = 1

damage_amount: .byte 0

dead:
    lda damage_amount
    sta guy_health_tmp
    stz guy_health_tmp+1
    jsr guy_take_damage
    rts

.endif