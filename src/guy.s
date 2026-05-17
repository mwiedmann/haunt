.ifndef GUY_S
GUY_S = 1

GUY_MAX_HEALTH = $9999
GUY_START_HEALTH = $1000

guy_health:     .word GUY_START_HEALTH
guy_health_tmp: .word 0  ; set lo+hi before calling take_damage or heal

guy_stunned: .byte 0

guy_score: .dword 0
guy_score_tmp: .dword 0

; Set guy_health_tmp_lo/hi to BCD amount before calling.
; Clamps to $0000 on underflow.
guy_take_damage:
    sed
    sec
    lda guy_health
    sbc guy_health_tmp
    tax                       ; save lo result
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

; Set guy_score_tmp bytes to BCD amount before calling.
guy_add_score:
    sed
    clc
    lda guy_score
    adc guy_score_tmp
    sta guy_score
    lda guy_score+1
    adc guy_score_tmp+1
    sta guy_score+1
    lda guy_score+2
    adc guy_score_tmp+2
    sta guy_score+2
    lda guy_score+3
    adc guy_score_tmp+3
    sta guy_score+3
    cld
    jsr update_score
    rts

guy_reset_score:
    stz guy_score
    stz guy_score+1
    jsr update_score
    rts

.endif
