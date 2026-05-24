.ifndef LEVEL_S
LEVEL_S = 1

level: .byte 1

load_level:
    lda #<floor_filename
    sta addr
    lda #>floor_filename
    sta addr + 1
    inc addr
    inc addr
    lda #48 ; "0"
    clc
    adc level
    sta (addr)

    lda #<mapbase_filename
    sta addr
    lda #>mapbase_filename
    sta addr + 1
    inc addr
    inc addr
    lda #48 ; "0"
    clc
    adc level
    sta (addr)

    lda #<gasmap_filename
    sta addr
    lda #>gasmap_filename
    sta addr + 1
    inc addr
    inc addr
    lda #48 ; "0"
    clc
    adc level
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
    inc addr
    inc addr
    lda #48 ; "0"
    clc
    adc level
    sta (addr)

    jsr load_precalc

    jsr init_treasure_sets
    
    rts

.endif
