.ifndef PAL_S
PAL_S = 1

pal1_filename: .asciiz "pal1.bin"
pal2_filename: .asciiz "pal2.bin"
pal3_filename: .asciiz "pal3.bin"
pal4_filename: .asciiz "pal4.bin"
pal5_filename: .asciiz "pal5.bin"
pal6_filename: .asciiz "pal6.bin"

load_pal_to_banks:
    lda #PAL1_BANK
    sta BANK
    lda #9
    ldx #<pal1_filename
    ldy #>pal1_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD

    lda #PAL2_BANK
    sta BANK
    lda #9
    ldx #<pal2_filename
    ldy #>pal2_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD

    lda #PAL3_BANK
    sta BANK
    lda #9
    ldx #<pal3_filename
    ldy #>pal3_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD

    lda #PAL4_BANK
    sta BANK
    lda #9
    ldx #<pal4_filename
    ldy #>pal4_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD

    lda #PAL5_BANK
    sta BANK
    lda #9
    ldx #<pal5_filename
    ldy #>pal5_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD

    lda #PAL6_BANK
    sta BANK
    lda #9
    ldx #<pal6_filename
    ldy #>pal6_filename
    jsr SETNAM
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD

    rts

swap_pal1:
    lda #PAL1_BANK
    sta BANK
    jsr swap_pal
    rts

swap_pal:
    lda #<PALETTE_ADDR
    sta VERA_ADDR_LO
    lda #>PALETTE_ADDR
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_UPPERVRAM_BITS
    sta VERA_ADDR_HI_SET
    lda #<HIRAM
    sta addr
    lda #>HIRAM
    sta addr + 1
@next_row:
    lda addr
    sta R0L
    lda addr + 1
    sta R0H
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<512
    sta R2L
    lda #>512
    sta R2H
    jsr MEMCOPY
    rts

current_pal: .byte 0
dir_pal: .byte 0
pal_count: .byte 0
tmp_rand: .byte 0

rotate_pal:
    lda #1
    sta dir_pal
    jsr RAND
    STX tmp_rand   ; combine 24 bits
    EOR tmp_rand   ; using exclusive-or
    STY tmp_rand   ; to get a higher-quality
    EOR tmp_rand   ; 8 bit random value
    STA tmp_rand
    cmp #128
    bcc @set_pal
    lda #255
    sta dir_pal
@set_pal:
    lda current_pal
    clc
    adc dir_pal
    cmp #6
    bne @check_neg
    stz current_pal
    bra @swap_pal
@check_neg:
    cmp #255
    bne @val_ok
    lda #5
@val_ok:
    sta current_pal
@swap_pal:
    lda #PAL1_BANK
    clc
    adc current_pal
    sta BANK
    jsr swap_pal
@no_change:
    rts

.endif