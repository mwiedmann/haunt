.ifndef PIX_S
PIX_S = 1

pixeldata: .res PIXEL_DATA_SIZE
emptyPixelData: .res PIXEL_DATA_SIZE
guyPixelDataAddr: .word 0

create_empty_pixeldata:
    ldy #0
    ldx #0
    lda #<emptyPixelData
    sta addr
    lda #>emptyPixelData
    sta addr + 1
@fill_loop:
    lda #16
    sta (addr)
    lda addr
    clc
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda #0
    sta (addr)
    clc
    lda addr
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    inx
    cpx #(MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1)
    bne @fill_loop
    ldx #0
    iny
    cpy #(MAX_VIEW_RADIUS + MAX_VIEW_RADIUS +1)
    bne @fill_loop
    ; Calc guy addr in pixeldata
    lda #<pixeldata
    clc
    adc #<GUY_PIXEL_DATA_OFFSET
    sta guyPixelDataAddr
    lda #>pixeldata
    adc #>GUY_PIXEL_DATA_OFFSET
    sta guyPixelDataAddr+1
    rts

clear_pixeldata:
    lda #<emptyPixelData
    sta R0L
    lda #>emptyPixelData
    sta R0H
    lda #<pixeldata
    sta R1L
    lda #>pixeldata
    sta R1H
    lda #<PIXEL_DATA_SIZE
    sta R2L
    lda #>PIXEL_DATA_SIZE
    sta R2H
    jsr MEMCOPY
    rts

.endif