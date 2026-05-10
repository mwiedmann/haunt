.ifndef DEAD_S
DEAD_S = 1

dead:
    lda #1
    sta guy_health_tmp
    stz guy_health_tmp+1
    jsr guy_take_damage
    rts

.endif