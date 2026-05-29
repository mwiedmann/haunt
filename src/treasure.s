.ifndef TREASURE_S
TREASURE_S = 1

treasure_sets: .res .sizeof(TreasureSet) * TREASURE_SET_COUNT
treasure_temp: .byte 0
treasure_offset: .byte 0
treasure_count: .byte 0

inc_treasureaddr:
    clc
    lda treasureaddr
    adc #<(.sizeof(TreasureSet))
    sta treasureaddr
    lda treasureaddr+1
    adc #>(.sizeof(TreasureSet))
    sta treasureaddr+1
    rts

init_treasure_sets:
    lda #<treasure_sets
    sta treasureaddr
    lda #>treasure_sets
    sta treasureaddr+1
; Chalice set
    lda #CHALICE_SET_TILE_START
    ldy #TreasureSet::_tile_id_start
    sta (treasureaddr), y
    lda #CHALICE_SET_TILE_END+1
    ldy #TreasureSet::_tile_id_end
    sta (treasureaddr), y

    lda #<CHALICE_SET_SCORE1
    ldy #TreasureSet::_scores
    sta (treasureaddr), y
    lda #>CHALICE_SET_SCORE1
    iny
    sta (treasureaddr), y
    lda #<CHALICE_SET_SCORE2
    iny
    sta (treasureaddr), y
    lda #>CHALICE_SET_SCORE2
    iny
    sta (treasureaddr), y
    lda #<CHALICE_SET_SCORE3
    iny
    sta (treasureaddr), y
    lda #>CHALICE_SET_SCORE3
    iny
    sta (treasureaddr), y
    lda #<CHALICE_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score
    sta (treasureaddr), y
    lda #>CHALICE_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score+1
    sta (treasureaddr), y
    lda #CHALICE_SET_SIZE
    ldy #TreasureSet::_set_size
    sta (treasureaddr), y
    lda #0
    ldy #TreasureSet::_collected
    sta (treasureaddr), y
    jsr inc_treasureaddr

; Idol set
    lda #IDOL_SET_TILE_START
    ldy #TreasureSet::_tile_id_start
    sta (treasureaddr), y
    lda #IDOL_SET_TILE_END+1
    ldy #TreasureSet::_tile_id_end
    sta (treasureaddr), y
    lda #<IDOL_SET_SCORE1
    ldy #TreasureSet::_scores
    sta (treasureaddr), y
    lda #>IDOL_SET_SCORE1
    ldy #TreasureSet::_scores+1
    sta (treasureaddr), y
    lda #<IDOL_SET_SCORE2
    ldy #TreasureSet::_scores+2
    sta (treasureaddr), y
    lda #>IDOL_SET_SCORE2
    ldy #TreasureSet::_scores+3
    sta (treasureaddr), y
    lda #<IDOL_SET_SCORE3
    ldy #TreasureSet::_scores+4
    sta (treasureaddr), y
    lda #>IDOL_SET_SCORE3
    ldy #TreasureSet::_scores+5
    sta (treasureaddr), y
    lda #<IDOL_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score
    sta (treasureaddr), y
    lda #>IDOL_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score+1
    sta (treasureaddr), y
    lda #IDOL_SET_SIZE
    ldy #TreasureSet::_set_size
    sta (treasureaddr), y
    lda #0
    ldy #TreasureSet::_collected
    sta (treasureaddr), y
    jsr inc_treasureaddr  

; Brick set
    lda #BRICK_SET_TILE_START
    ldy #TreasureSet::_tile_id_start
    sta (treasureaddr), y
    lda #BRICK_SET_TILE_END+1
    ldy #TreasureSet::_tile_id_end
    sta (treasureaddr), y
    lda #<BRICK_SET_SCORE1
    ldy #TreasureSet::_scores
    sta (treasureaddr), y
    lda #>BRICK_SET_SCORE1
    ldy #TreasureSet::_scores+1
    sta (treasureaddr), y
    lda #<BRICK_SET_SCORE2
    ldy #TreasureSet::_scores+2
    sta (treasureaddr), y
    lda #>BRICK_SET_SCORE2
    ldy #TreasureSet::_scores+3
    sta (treasureaddr), y
    lda #<BRICK_SET_SCORE3
    ldy #TreasureSet::_scores+4
    sta (treasureaddr), y
    lda #>BRICK_SET_SCORE3
    ldy #TreasureSet::_scores+5
    sta (treasureaddr), y
    lda #<BRICK_SET_SCORE4
    ldy #TreasureSet::_scores+6
    sta (treasureaddr), y
    lda #>BRICK_SET_SCORE4
    ldy #TreasureSet::_scores+7
    sta (treasureaddr), y
    lda #<BRICK_SET_SCORE5
    ldy #TreasureSet::_scores+8
    sta (treasureaddr), y
    lda #>BRICK_SET_SCORE5
    ldy #TreasureSet::_scores+9
    sta (treasureaddr), y
    lda #<BRICK_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score
    sta (treasureaddr), y
    lda #>BRICK_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score+1
    sta (treasureaddr), y
    lda #BRICK_SET_SIZE
    ldy #TreasureSet::_set_size
    sta (treasureaddr), y
    lda #0
    ldy #TreasureSet::_collected
    sta (treasureaddr), y
    jsr inc_treasureaddr  

; Gem set
    lda #GEM_SET_TILE_START
    ldy #TreasureSet::_tile_id_start
    sta (treasureaddr), y
    lda #GEM_SET_TILE_END+1
    ldy #TreasureSet::_tile_id_end
    sta (treasureaddr), y
    lda #<GEM_SET_SCORE1
    ldy #TreasureSet::_scores
    sta (treasureaddr), y
    lda #>GEM_SET_SCORE1
    ldy #TreasureSet::_scores+1
    sta (treasureaddr), y
    lda #<GEM_SET_SCORE2
    ldy #TreasureSet::_scores+2
    sta (treasureaddr), y
    lda #>GEM_SET_SCORE2
    ldy #TreasureSet::_scores+3
    sta (treasureaddr), y
    lda #<GEM_SET_SCORE3
    ldy #TreasureSet::_scores+4
    sta (treasureaddr), y
    lda #>GEM_SET_SCORE3
    ldy #TreasureSet::_scores+5
    sta (treasureaddr), y
    lda #<GEM_SET_SCORE4
    ldy #TreasureSet::_scores+6
    sta (treasureaddr), y
    lda #>GEM_SET_SCORE4
    ldy #TreasureSet::_scores+7
    sta (treasureaddr), y
    lda #<GEM_SET_SCORE5
    ldy #TreasureSet::_scores+8
    sta (treasureaddr), y
    lda #>GEM_SET_SCORE5
    ldy #TreasureSet::_scores+9
    sta (treasureaddr), y
    lda #<GEM_SET_SCORE6
    ldy #TreasureSet::_scores+10
    sta (treasureaddr), y
    lda #>GEM_SET_SCORE6
    ldy #TreasureSet::_scores+11
    sta (treasureaddr), y
    lda #<GEM_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score
    sta (treasureaddr), y
    lda #>GEM_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score+1
    sta (treasureaddr), y
    lda #GEM_SET_SIZE
    ldy #TreasureSet::_set_size
    sta (treasureaddr), y
    lda #0
    ldy #TreasureSet::_collected
    sta (treasureaddr), y
    jsr inc_treasureaddr  

    rts

score_treasure:
    lda #TREASURE_SET_COUNT
    sta treasure_count
    lda #<treasure_sets
    sta treasureaddr
    lda #>treasure_sets
    sta treasureaddr+1
@check_set:
    lda treasure_count
    beq @single_treasure
    dec treasure_count
    lda current_tile
    ldy #TreasureSet::_tile_id_start
    cmp (treasureaddr), y
    bcs @maybe_treasure
    bra @next_set
@maybe_treasure:
    ldy #TreasureSet::_tile_id_end
    cmp (treasureaddr), y
    bcc @found_set
@next_set:
    jsr inc_treasureaddr
    bra @check_set
@found_set:
    ; Calculate the score for the found treasure set
    lda #TreasureSet::_scores
    sta treasure_offset
    ldy #TreasureSet::_tile_id_start
    lda (treasureaddr), y
    sta treasure_temp
@next_item:
    lda current_tile
    cmp treasure_temp
    beq @found_item
    inc treasure_offset
    inc treasure_offset
    inc treasure_temp
    bra @next_item
@found_item:
    ldy treasure_offset
    lda (treasureaddr), y
    sta guy_score_tmp
    iny
    lda (treasureaddr), y
    sta guy_score_tmp+1
    jsr guy_add_score
    ; See if bonus for set
    ldy #TreasureSet::_collected
    lda (treasureaddr), y
    inc
    sta (treasureaddr), y
    ldy #TreasureSet::_set_size
    cmp (treasureaddr), y
    bne @done
    ; Set complete, add bonus score
    ldy #TreasureSet::_set_score
    lda (treasureaddr), y
    sta guy_score_tmp
    iny
    lda (treasureaddr), y
    sta guy_score_tmp+1
    jsr guy_add_score
@done:
    rts
@single_treasure:
    lda #<TREASURE_SINGLE_SCORE
    sta guy_score_tmp
    lda #>TREASURE_SINGLE_SCORE
    sta guy_score_tmp+1
    jsr guy_add_score
    rts
    
.endif