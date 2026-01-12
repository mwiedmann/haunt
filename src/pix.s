.ifndef PIX_S
PIX_S = 1

pixeldata: .res PIXEL_DATA_SIZE
guyPixelDataAddr: .word 0

set_guy_pixeldata:
    ; Calc guy addr in pixeldata
    lda #<pixeldata
    clc
    adc #<GUY_PIXEL_DATA_OFFSET
    sta guyPixelDataAddr
    lda #>pixeldata
    adc #>GUY_PIXEL_DATA_OFFSET
    sta guyPixelDataAddr+1
    rts

.endif