.ifndef LEVEL_S
LEVEL_S = 1

level: .byte 1

load_level:
    lda #<floor_filename
    sta addr
    lda #>floor_filename
    sta addr + 1
    lda addr
    clc
    adc #2
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda #48 ; "0"
    clc
    adc level
    sta (addr)

    lda #<mapbase_filename
    sta addr
    lda #>mapbase_filename
    sta addr + 1
    lda addr
    clc
    adc #2
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda #48 ; "0"
    clc
    adc level
    sta (addr)

    lda #<gasmap_filename
    sta addr
    lda #>gasmap_filename
    sta addr + 1
    lda addr
    clc
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda #48 ; "0
    clc
    adc level ; add level numbber to the filename
    sta (addr)
    lda addr
    clc
    adc #1
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda #58
    sec
    sbc exit_tile ; Add the exit number to the filename
    clc
    adc #48
    sta (addr)

    jsr load_level_files

    ; Reset gas addr
    lda #<HIRAM
    sta gasaddr
    lda #>HIRAM
    sta gasaddr + 1

    lda #<precalc_filename
    sta addr
    lda #>precalc_filename
    sta addr + 1
    lda addr
    clc
    adc #2
    sta addr
    lda addr + 1
    adc #0
    sta addr + 1
    lda #48 ; "0"
    clc
    adc level
    sta (addr)

    jsr load_precalc
    
    ; Reset the gas counter
    lda #<GAS_START_TIME
    sta gas_counter
    lda #>GAS_START_TIME
    sta gas_counter + 1

    jsr change_wall_color
    
    rts

.endif
