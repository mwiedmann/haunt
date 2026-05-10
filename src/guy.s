.ifndef GUY_S
GUY_S = 1

GUY_MAX_HEALTH = $9999
GUY_START_HEALTH = $1234

guy_health:     .word GUY_START_HEALTH
guy_health_tmp: .word 0  ; set lo+hi before calling take_damage or heal

; Set guy_health_tmp_lo/hi to BCD amount before calling.
; Clamps to $0000 on underflow.
guy_take_damage:
    sed
    sec
    lda guy_health
    sbc guy_health_tmp
    tax                         ; save lo result
    lda guy_health+1
    sbc guy_health_tmp+1
    bcs @no_underflow
    stz guy_health
    stz guy_health+1
    cld
    jsr update_health
    rts
@no_underflow:
    stx guy_health
    sta guy_health+1
    cld
    jsr update_health
    rts

; Set guy_health_tmp_lo/hi to BCD amount before calling.
; Clamps to $9999 on overflow.
guy_heal:
    sed
    clc
    lda guy_health
    adc guy_health_tmp
    tax                         ; save lo result
    lda guy_health+1
    adc guy_health_tmp+1
    bcs @clamp                  ; carry set = result exceeded $9999
    stx guy_health
    sta guy_health+1
    cld
    jsr update_health
    rts
@clamp:
    lda #<GUY_MAX_HEALTH
    sta guy_health
    lda #>GUY_MAX_HEALTH
    sta guy_health+1
    cld
    jsr update_health
    rts

; Restore health to 9999.
guy_reset_health:
    lda #<GUY_START_HEALTH
    sta guy_health
    lda #>GUY_START_HEALTH
    sta guy_health+1
    jsr update_health
    rts

.endif
