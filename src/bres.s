.ifndef BRES_S
BRES_S = 1

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

.endif