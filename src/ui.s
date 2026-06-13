.ifndef UI_S
UI_S = 1

GUY_SCORE_X = 28
GUY_SCORE_Y = 12
SCORE_L1_MAPBASE_ADDR = MAPBASE_L1_ADDR + (L1_WIDTH*2*GUY_SCORE_Y) + (GUY_SCORE_X*2)

GUY_HEALTH_X = 34
GUY_HEALTH_Y = 12
HEALTH_L1_MAPBASE_ADDR = MAPBASE_L1_ADDR + (L1_WIDTH*2*GUY_HEALTH_Y) + (GUY_HEALTH_X*2)
TILE_DIGIT_START = 122

GAS_COUNTER_X = 22
GAS_COUNTER_Y = 1
GAS_L1_COUNTER_MAPBASE_ADDR = MAPBASE_L1_ADDR + (L1_WIDTH*2*GAS_COUNTER_Y) + (GAS_COUNTER_X*2)

num_low: .byte 0
num_high: .byte 0

update_gas_counter:
    lda #<GAS_L1_COUNTER_MAPBASE_ADDR
    sta VERA_ADDR_LO
    lda #>GAS_L1_COUNTER_MAPBASE_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    
    lda gas_counter+1 ; 100s digits
    jsr get_font_num

    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    lda gas_counter ; 10s and 1s digits
    jsr get_font_num

    lda num_high
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

update_health:
    lda #<HEALTH_L1_MAPBASE_ADDR
    sta VERA_ADDR_LO
    lda #>HEALTH_L1_MAPBASE_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    
    lda guy_health+1 ; 1000s and 100s digits
    jsr get_font_num

    lda num_high
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    lda guy_health ; 10s and 1s digits
    jsr get_font_num

    lda num_high
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

update_score:
    lda #<SCORE_L1_MAPBASE_ADDR
    sta VERA_ADDR_LO
    lda #>SCORE_L1_MAPBASE_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET

    lda guy_score+2
    jsr get_font_num

    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    lda guy_score+1 ; 1000s and 100s digits
    jsr get_font_num

    lda num_high
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0

    lda guy_score ; 10s and 1s digits
    jsr get_font_num

    lda num_high
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    lda num_low
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

get_font_num:
    pha
    and #%1111 ; remove high part
    clc
    adc #TILE_DIGIT_START
    sta num_low
    pla
    ror
    ror
    ror
    ror
    and #%1111 ; remove high part
    clc
    adc #TILE_DIGIT_START
    sta num_high
    rts

.endif
