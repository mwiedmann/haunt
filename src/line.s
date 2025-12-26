.ifndef LINE_S
LINE_S = 1

bresenham_y1: .byte 0
bresenham_y2: .byte 0
bresenham_x1: .byte 0
bresenham_x2: .byte 0
bresenham_dx: .byte 0
bresenham_dy: .byte 0
bresenham_sx: .byte 0
bresenham_sy: .byte 0
bresenham_err: .byte 0

		;*****************************************************************
		; negate accumulator
		;*****************************************************************

neg:	eor #$ff
		clc
		adc #1
		rts

		;*****************************************************************
		; init bresenham line 
		;*****************************************************************

init_bresenham:
		; dx = abs(x2 - x1)
		; dy = abs(y2 - y1)
		; sx = x1 < x2 ? 1 : -1
		; sy = y1 < y2 ? 1 : -1
		; err = dx > dy ? dx : -dy
		; dx = dx * 2
		; dy = dy * 2

		; if y1 < y2:
		; 	sy = 1
		; 	dy = y2 - y1
		; else:
		; 	sy = -1
		; 	dy = y1 - y2
		ldx #$ff		; X = -1
		lda bresenham_y1
		sec
		sbc bresenham_y2	; A = y1 - y2
		bpl :+
		ldx #1			; X = 1
		jsr neg			; A = y2 - y1
:		sta bresenham_dy
		stx bresenham_sy

		; if x1 < x2:
		; 	sx = 1
		; 	dx = x2 - x1
		; else:
		; 	sx = -1
		; 	dx = x1 - x2
		ldx #$ff		; X = -1
		lda bresenham_x1
		sec
		sbc bresenham_x2	; A = x1 - x2
		bpl :+
		ldx #1			; X = 1
		jsr neg			; A = x2 - x1
:		sta bresenham_dx
		stx bresenham_sx

		; err = dx > dy ? dx : -dy
		;lda bresenham_dx
		cmp bresenham_dy	; dx - dy > 0
		beq :+
		bpl @skiperr
:		lda bresenham_dy
		jsr neg
@skiperr:	sta bresenham_err

		; dx = dx * 2
		; dy = dy * 2
		asl bresenham_dx
		asl bresenham_dy
		rts

		;*****************************************************************
		; step along bresenham line
		;*****************************************************************

step_bresenham:
		; err2 = err
		lda bresenham_err
		pha			; push err2

		; if err2 > -dx:
		;   err = err - dy
		;   x = x + sx
		clc
		adc bresenham_dx	; skip if err2 + dx <= 0
		bmi :+
		beq :+
		lda bresenham_err
		sec
		sbc bresenham_dy
		sta bresenham_err
		lda bresenham_x1
		clc
		adc bresenham_sx
		sta bresenham_x1
:
		; if err2 < dy:
		;   err = err + dx
		;   y = y + sy
		pla			; pop err2
		cmp bresenham_dy	; skip if err2 - dy >= 0
		bpl :+
		lda bresenham_err
		clc
		adc bresenham_dx
		sta bresenham_err
		lda bresenham_y1
		clc
		adc bresenham_sy
		sta bresenham_y1
:	
        rts

pixel_spot: .word 0

check_floor_val:
    lda #<floor
    sta addr
    lda #>floor
    sta addr + 1
    ldy #0
@next_y:
    cpy bresenham_y1
    beq @move_x
    iny
    clc
    lda addr
    adc #64
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    bra @next_y
@move_x:
    clc
    lda addr
    adc bresenham_x1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda (addr)
    rts

STARTX = 1
STARTY = 7
VIEW_RADIUS = 10

xPosStart: .byte STARTX
yPosStart: .byte STARTY
xMid: .byte STARTX + VIEW_RADIUS+1
yMid: .byte STARTY + VIEW_RADIUS+1
xPosEnd: .byte STARTX + VIEW_RADIUS + VIEW_RADIUS +1
yPosEnd: .byte STARTY + VIEW_RADIUS + VIEW_RADIUS +1

PIXEL_DATA_SIZE = (VIEW_RADIUS + VIEW_RADIUS +1) * (VIEW_RADIUS + VIEW_RADIUS +1) * 2

pixeldata: .res PIXEL_DATA_SIZE
emptyPixelData: .res PIXEL_DATA_SIZE

create_empty_pixeldata:
    ldy #0
    ldx #0
    lda #<emptyPixelData
    sta addr
    lda #>emptyPixelData
    sta addr + 1
@fill_loop:
    lda #2
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
    cpx #(VIEW_RADIUS + VIEW_RADIUS +1)
    bne @fill_loop
    ldx #0
    iny
    cpy #(VIEW_RADIUS + VIEW_RADIUS +1)
    bne @fill_loop
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

pixelTileId: .byte 0

draw_pixeldata:
    lda bresenham_y1
    sec
    sbc yPosStart
    tay
    lda #<pixeldata
    sta addr
    lda #>pixeldata
    sta addr + 1
@draw_y:
    cpy #0
    beq @draw_x
    lda addr
    clc
    adc #((VIEW_RADIUS + VIEW_RADIUS +1) * 2)
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    dey
    bra @draw_y
@draw_x:
    lda bresenham_x1
    sec
    sbc xPosStart
    clc
    rol
    clc
    adc addr
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda pixelTileId
    sta (addr)
    rts

row_count: .byte 0

copy_pixeldata_to_vram:
    lda #(VIEW_RADIUS + VIEW_RADIUS +1)
    sta row_count
    lda #<MAPBASE_L1_ADDR
    sta pixel_spot
    lda #>MAPBASE_L1_ADDR
    sta pixel_spot+1
    ldy yPosStart
@next_y:
    cpy #0
    beq @move_x
    lda pixel_spot
    clc
    adc #128
    sta pixel_spot
    lda pixel_spot+1
    adc #0
    sta pixel_spot+1
    dey
    bra @next_y
@move_x: 
    ; calc x - add x twice (2 bytes per pixel)
    lda pixel_spot
    clc
    adc xPosStart
    sta pixel_spot
    lda pixel_spot+1
    adc #0
    sta pixel_spot+1
    clc
    lda pixel_spot
    adc xPosStart
    sta pixel_spot
    lda pixel_spot+1
    adc #0
    sta pixel_spot+1
    ; Set the pixeldata source address
    lda #<pixeldata
    sta addr
    lda #>pixeldata
    sta addr + 1
    ; Set VRAM address
@next_row:
    lda pixel_spot
    sta VERA_ADDR_LO
    lda pixel_spot+1
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda addr
    sta R0L
    lda addr + 1
    sta R0H
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<((VIEW_RADIUS + VIEW_RADIUS +1) * 2)
    sta R2L
    lda #>((VIEW_RADIUS + VIEW_RADIUS +1) * 2)
    sta R2H
    jsr MEMCOPY
    dec row_count
    lda row_count
    cmp #0
    beq @done
    ; Increment pixeldata address to next row
    lda pixel_spot
    clc
    adc #128
    sta pixel_spot
    lda pixel_spot+1
    adc #0
    sta pixel_spot+1
    ; change the pixeldata source address
    lda addr
    clc
    adc #((VIEW_RADIUS + VIEW_RADIUS +1) * 2)
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    bra @next_row
@done:
    rts

draw_lr_lines:
    lda xMid
    sta bresenham_x1
    lda yMid
    sta bresenham_y1
    lda #3
    sta pixelTileId
    jsr draw_pixeldata
    lda #0
    sta pixelTileId
    lda xPosStart
    sta x2
    lda yPosStart
    sta y2
@draw_line:
    lda x2
    sta bresenham_x2
    lda xMid
    sta bresenham_x1
    lda y2
    sta bresenham_y2
    lda yMid
    sta bresenham_y1
    jsr init_bresenham
@next_pixel:
    jsr step_bresenham
    lda bresenham_x1
    cmp bresenham_x2
    bne @next_step
    lda bresenham_y1
    cmp bresenham_y2
    beq @next_line
@next_step:
    jsr draw_pixeldata
    jsr check_floor_val
    cmp #0
    bne @next_line
    bra @next_pixel
@next_line:
    lda x2
    cmp xPosStart
    beq @jump_right
    lda xPosStart
    sta x2
    inc y2
    lda yPosEnd
    clc
    adc #1
    cmp y2
    beq @next_phase
    bra @draw_line
@jump_right:
    lda xPosEnd
    sta x2
    bra @draw_line
@next_phase:
    rts

draw_ud_lines:
    lda xPosStart
    sta x2
    inc x2
    lda yPosStart
    sta y2
@draw_line:
    lda x2
    sta bresenham_x2
    lda xMid
    sta bresenham_x1
    lda y2
    sta bresenham_y2
    lda yMid
    sta bresenham_y1
    jsr init_bresenham
@next_pixel:
    jsr step_bresenham
    lda bresenham_x1
    cmp bresenham_x2
    bne @next_step
    lda bresenham_y1
    cmp bresenham_y2
    beq @next_line
@next_step:
    jsr draw_pixeldata
    jsr check_floor_val
    cmp #0
    bne @next_line
    bra @next_pixel
@next_line:
    lda y2
    cmp yPosStart
    beq @jump_down
    lda yPosStart
    sta y2
    inc x2
    lda xPosEnd
    cmp x2
    beq @next_phase
    bra @draw_line
@jump_down:
    lda yPosEnd
    sta y2
    bra @draw_line
@next_phase:
    rts

.endif