.ifndef TILES_S
TILES_S = 1

tilecolor: .byte 0

create_solid_tile:
    lda tilecolor
    ldx #0
@write_tile:
    sta VERA_DATA0
    inx
    cpx #0
    beq @tile_done
    bra @write_tile
@tile_done:
    rts

tileIdx: .byte 0

create_tiles:
    ; create some tiles
    jsr point_to_tilebase_l1
    lda #0
    sta tilecolor
    jsr create_solid_tile
    lda #1
    sta tilecolor
    jsr create_solid_tile
    lda #2
    sta tilecolor
    jsr create_solid_tile
    lda #3
    sta tilecolor
    jsr create_solid_tile
@done:
    rts

.endif