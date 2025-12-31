.ifndef CREATE_S
CREATE_S = 1

save_filename: .asciiz "save.bin"
linedata: .res 2048

create_linedata:
    jsr load_rad10
    jsr create_data
    jsr save_linedata
@done:
    bra @done
    
save_linedata:
    lda #8
    ldx #<save_filename
    ldy #>save_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #<linedata
    sta addr
    lda #>linedata
    sta addr+1
    lda #<addr
    ldx #<(linedata+2048) ; End address
    ldy #>(linedata+2048)
    jsr SAVE
    rts

create_data:
    lda #<linedata
    sta addr
    lda #>linedata
    sta addr+1
    lda #10
    sta bresenham_x1
    sta bresenham_y1
    lda #0
    sta circleId
    ldx circleId
    lda rad_coords, x
    sta x2
    inx
    lda rad_coords, x
    sta y2
@draw_line:
;stp
    lda x2
    sta bresenham_x2
    lda #10
    sta bresenham_x1
    lda y2
    sta bresenham_y2
    lda #10
    sta bresenham_y1
    jsr init_bresenham
@next_pixel:
    jsr step_bresenham
    ; Store bresenham_x1, bresenham_x2
    lda bresenham_x1
    sta (addr)
    clc
    lda addr
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda bresenham_y1
    sta (addr)
    clc
    lda addr
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda bresenham_x1
    cmp bresenham_x2
    bne @next_step
    lda bresenham_y1
    cmp bresenham_y2
    beq @next_line
@next_step:
    bra @next_pixel
@next_line:
    lda #254
    sta (addr)
    clc
    lda addr
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    inc circleId
    inc circleId
    ldx circleId
    lda rad_coords, x
    cmp #255
    beq @done
    sta x2
    inx
    lda rad_coords, x
    sta y2
    bra @draw_line
@done:
    lda #255
    sta (addr)       ; End marker
    rts

; Decimal conversion outputs and temp (zero page)
dec_h: .byte 0    ; ASCII hundreds ('0'..'2')
dec_t: .byte 0    ; ASCII tens ('0'..'9')
dec_u: .byte 0    ; ASCII units ('0'..'9')
dec_tmp: .byte 0  ; working copy of the value

; byte_to_dec
; Input: A = value (0..255)
; Output: dec_h, dec_t, dec_u contain ASCII digits ('0'..'9') representing the value
; Preserves A
byte_to_dec:
    pha                 ; save original A
    sta dec_tmp         ; working copy
    lda #0
    sta dec_h
    sta dec_t

; compute hundreds
@bt_h_loop:
    lda dec_tmp
    cmp #100
    bcc @bt_done_h
    lda dec_tmp
    sec
    sbc #100
    sta dec_tmp
    inc dec_h
    jmp @bt_h_loop
@bt_done_h:

; compute tens
@bt_t_loop:
    lda dec_tmp
    cmp #10
    bcc @bt_done_t
    lda dec_tmp
    sec
    sbc #10
    sta dec_tmp
    inc dec_t
    jmp @bt_t_loop
@bt_done_t:

; convert to ASCII and store
    lda dec_h
    clc
    adc #$30
    sta dec_h
    lda dec_t
    clc
    adc #$30
    sta dec_t
    lda dec_tmp
    clc
    adc #$30
    sta dec_u

    pla                 ; restore original A
    rts

.endif