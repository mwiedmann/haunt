.ifndef TREASURE_S
TREASURE_S = 1

treasure_sets: .res .sizeof(TreasureSet) * TREASURE_SET_COUNT
treasure_temp: .byte 0
treasure_score_offset: .byte 0
treasure_collected_offset: .byte 0
treasure_count: .byte 0
treasure_ui_offset: .byte 0
treasure_ui_addr: .word 0
treasure_set_count: .byte 0

inc_treasureaddr:
    clc
    lda treasureaddr
    adc #<(.sizeof(TreasureSet))
    sta treasureaddr
    lda treasureaddr+1
    adc #>(.sizeof(TreasureSet))
    sta treasureaddr+1
    rts

clear_treasure_set:
    lda #0
    ldy #TreasureSet::_ui_address_row2
    sta (treasureaddr), y
    ldy #TreasureSet::_collected
    sta (treasureaddr), y
    iny
    sta (treasureaddr), y
    iny
    sta (treasureaddr), y
    iny
    sta (treasureaddr), y
    iny
    sta (treasureaddr), y
    iny
    sta (treasureaddr), y
    lda #255
    ldy #TreasureSet::_row_count
    sta (treasureaddr), y
    rts

init_treasure_sets:
    lda #<treasure_sets
    sta treasureaddr
    lda #>treasure_sets
    sta treasureaddr+1
; Chalice set
    jsr clear_treasure_set
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
    ldy #TreasureSet::_count
    sta (treasureaddr), y
    lda #<CHALICE_SET_UI_ADDR
    ldy #TreasureSet::_ui_address
    sta (treasureaddr), y
    lda #>CHALICE_SET_UI_ADDR
    ldy #TreasureSet::_ui_address+1
    sta (treasureaddr), y
    jsr inc_treasureaddr

; Idol set
    jsr clear_treasure_set
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
    lda #<IDOL_SET_SCORE4
    ldy #TreasureSet::_scores+6
    sta (treasureaddr), y
    lda #>IDOL_SET_SCORE4
    ldy #TreasureSet::_scores+7
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
    ldy #TreasureSet::_count
    sta (treasureaddr), y
    lda #<IDOL_SET_UI_ADDR
    ldy #TreasureSet::_ui_address
    sta (treasureaddr), y
    lda #>IDOL_SET_UI_ADDR
    ldy #TreasureSet::_ui_address+1
    sta (treasureaddr), y
    jsr inc_treasureaddr  

; Brick set
    jsr clear_treasure_set
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
    ldy #TreasureSet::_count
    sta (treasureaddr), y
    lda #<BRICK_SET_UI_ADDR
    ldy #TreasureSet::_ui_address
    sta (treasureaddr), y
    lda #>BRICK_SET_UI_ADDR
    ldy #TreasureSet::_ui_address+1
    sta (treasureaddr), y
    jsr inc_treasureaddr  

; Gem set
    jsr clear_treasure_set
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
    ldy #TreasureSet::_count
    sta (treasureaddr), y
    lda #<GEM_SET_UI_ADDR
    ldy #TreasureSet::_ui_address
    sta (treasureaddr), y
    lda #>GEM_SET_UI_ADDR
    ldy #TreasureSet::_ui_address+1
    sta (treasureaddr), y
    jsr inc_treasureaddr  

; Beetle set
    jsr clear_treasure_set
    lda #BEETLE_SET_TILE_START
    ldy #TreasureSet::_tile_id_start
    sta (treasureaddr), y
    lda #BEETLE_SET_TILE_END+1
    ldy #TreasureSet::_tile_id_end
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE1
    ldy #TreasureSet::_scores
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE1
    ldy #TreasureSet::_scores+1
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE2
    ldy #TreasureSet::_scores+2
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE2
    ldy #TreasureSet::_scores+3
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE3
    ldy #TreasureSet::_scores+4
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE3
    ldy #TreasureSet::_scores+5
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE4
    ldy #TreasureSet::_scores+6
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE4
    ldy #TreasureSet::_scores+7
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE5
    ldy #TreasureSet::_scores+8
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE5
    ldy #TreasureSet::_scores+9
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE6
    ldy #TreasureSet::_scores+10
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE6
    ldy #TreasureSet::_scores+11
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE7
    ldy #TreasureSet::_scores+12
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE7
    ldy #TreasureSet::_scores+13
    sta (treasureaddr), y
    lda #<BEETLE_SET_SCORE8
    ldy #TreasureSet::_scores+14
    sta (treasureaddr), y
    lda #>BEETLE_SET_SCORE8
    ldy #TreasureSet::_scores+15
    sta (treasureaddr), y
    lda #<BEETLE_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score
    sta (treasureaddr), y
    lda #>BEETLE_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score+1
    sta (treasureaddr), y
    lda #BEETLE_SET_SIZE
    ldy #TreasureSet::_set_size
    sta (treasureaddr), y
    lda #0
    ldy #TreasureSet::_count
    sta (treasureaddr), y
    lda #<BEETLE_SET_UI_ADDR
    ldy #TreasureSet::_ui_address
    sta (treasureaddr), y
    lda #>BEETLE_SET_UI_ADDR
    ldy #TreasureSet::_ui_address+1
    sta (treasureaddr), y
    lda #BEETLE_SET_SIZE/2
    ldy #TreasureSet::_row_count
    sta (treasureaddr), y
    lda #<BEETLE_SET_UI_ROW2_ADDR
    ldy #TreasureSet::_ui_address_row2
    sta (treasureaddr), y
    lda #>BEETLE_SET_UI_ROW2_ADDR
    ldy #TreasureSet::_ui_address_row2+1
    sta (treasureaddr), y
    jsr inc_treasureaddr  

; Key set
    jsr clear_treasure_set
    lda #KEY_SET_TILE_START
    ldy #TreasureSet::_tile_id_start
    sta (treasureaddr), y
    lda #KEY_SET_TILE_END+1
    ldy #TreasureSet::_tile_id_end
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE1
    ldy #TreasureSet::_scores
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE1
    ldy #TreasureSet::_scores+1
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE2
    ldy #TreasureSet::_scores+2
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE2
    ldy #TreasureSet::_scores+3
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE3
    ldy #TreasureSet::_scores+4
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE3
    ldy #TreasureSet::_scores+5
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE4
    ldy #TreasureSet::_scores+6
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE4
    ldy #TreasureSet::_scores+7
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE5
    ldy #TreasureSet::_scores+8
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE5
    ldy #TreasureSet::_scores+9
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE6
    ldy #TreasureSet::_scores+10
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE6
    ldy #TreasureSet::_scores+11
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE7
    ldy #TreasureSet::_scores+12
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE7
    ldy #TreasureSet::_scores+13
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE8
    ldy #TreasureSet::_scores+14
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE8
    ldy #TreasureSet::_scores+15
    sta (treasureaddr), y
     lda #<KEY_SET_SCORE9
    ldy #TreasureSet::_scores+16
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE9
    ldy #TreasureSet::_scores+17
    sta (treasureaddr), y
    lda #<KEY_SET_SCORE10
    ldy #TreasureSet::_scores+18
    sta (treasureaddr), y
    lda #>KEY_SET_SCORE10
    ldy #TreasureSet::_scores+19
    sta (treasureaddr), y
    lda #<KEY_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score
    sta (treasureaddr), y
    lda #>KEY_SET_BONUS_SCORE
    ldy #TreasureSet::_set_score+1
    sta (treasureaddr), y
    lda #KEY_SET_SIZE
    ldy #TreasureSet::_set_size
    sta (treasureaddr), y
    lda #0
    ldy #TreasureSet::_count
    sta (treasureaddr), y
    lda #<KEY_SET_UI_ADDR
    ldy #TreasureSet::_ui_address
    sta (treasureaddr), y
    lda #>KEY_SET_UI_ADDR
    ldy #TreasureSet::_ui_address+1
    sta (treasureaddr), y
    lda #KEY_SET_SIZE/2
    ldy #TreasureSet::_row_count
    sta (treasureaddr), y
    lda #<KEY_SET_UI_ROW2_ADDR
    ldy #TreasureSet::_ui_address_row2
    sta (treasureaddr), y
    lda #>KEY_SET_UI_ROW2_ADDR
    ldy #TreasureSet::_ui_address_row2+1
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
    beq @no_treasure_found
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
    sta treasure_score_offset
    lda #TreasureSet::_collected
    sta treasure_collected_offset
    ldy #TreasureSet::_tile_id_start
    lda (treasureaddr), y
    sta treasure_temp
    stz treasure_ui_offset
    stz treasure_set_count
@next_item:
    lda current_tile
    cmp treasure_temp
    beq @found_item
    inc treasure_score_offset
    inc treasure_score_offset
    inc treasure_collected_offset
    inc treasure_temp
    inc treasure_ui_offset
    inc treasure_ui_offset
    inc treasure_set_count
    bra @next_item
@found_item:
    jsr mark_treasure_collected
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
    ; Update UI
    jsr update_treasure_ui
    rts
@no_treasure_found:
    ; Shouldn't happen, but just return if we didn't find the treasure for some reason
    rts
    
mark_treasure_collected:
     ; Mark this treasure as collected
    ldy treasure_collected_offset
    lda #1
    sta (treasureaddr), y
    ; Load the score for this treasure and add to player score
    ldy treasure_score_offset
    lda (treasureaddr), y
    sta guy_score_tmp
    iny
    lda (treasureaddr), y
    sta guy_score_tmp+1
    jsr guy_add_score
    ; See if bonus for set
    ldy #TreasureSet::_count
    lda (treasureaddr), y
    inc
    sta (treasureaddr), y
    ldy #TreasureSet::_set_size
    cmp (treasureaddr), y
    rts

update_treasure_ui:
    lda treasure_set_count
    ldy #TreasureSet::_row_count
    cmp (treasureaddr), y
    bcs @update_row2
    ; Update first row
    ldy #TreasureSet::_ui_address
    lda (treasureaddr), y
    sta treasure_ui_addr
    iny
    lda (treasureaddr), y
    sta treasure_ui_addr+1
    lda treasure_ui_addr
    clc
    adc treasure_ui_offset
    sta treasure_ui_addr
    lda treasure_ui_addr+1
    adc #0
    sta treasure_ui_addr+1
    bra @write_to_ui
@update_row2:
    lda treasure_set_count
    sec
    ldy #TreasureSet::_row_count
    sbc (treasureaddr), y
    asl
    sta treasure_ui_offset
    ldy #TreasureSet::_ui_address_row2
    lda (treasureaddr), y
    sta treasure_ui_addr
    iny
    lda (treasureaddr), y
    sta treasure_ui_addr+1
    lda treasure_ui_addr
    clc
    adc treasure_ui_offset
    sta treasure_ui_addr
    lda treasure_ui_addr+1
    adc #0
    sta treasure_ui_addr+1
@write_to_ui:
    lda treasure_ui_addr
    sta VERA_ADDR_LO
    lda treasure_ui_addr+1
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_BITS
    sta VERA_ADDR_HI_SET
    lda current_tile
    sta VERA_DATA0
    lda #0
    sta VERA_DATA0
    rts

draw_all_treasure_ui:
    lda #TREASURE_TILE_START
    sta current_tile
@next_treasure:
    lda current_tile
    cmp #TREASURE_TILE_END+1
    bcs @done
    jsr draw_single_treasure_ui
    inc current_tile
    bra @next_treasure
@done:
    rts

draw_single_treasure_ui:
    lda #TREASURE_SET_COUNT
    sta treasure_count
    lda #<treasure_sets
    sta treasureaddr
    lda #>treasure_sets
    sta treasureaddr+1
@check_set:
    lda treasure_count
    beq @treasure_not_collected
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
    lda #TreasureSet::_collected
    sta treasure_collected_offset
    ldy #TreasureSet::_tile_id_start
    lda (treasureaddr), y
    sta treasure_temp
    stz treasure_ui_offset
    stz treasure_set_count
@next_item:
    lda current_tile
    cmp treasure_temp
    beq @found_item
    inc treasure_collected_offset
    inc treasure_temp
    inc treasure_ui_offset
    inc treasure_ui_offset
    inc treasure_set_count
    bra @next_item
@found_item:
    ; check if this treasure was collected
    ldy treasure_collected_offset
    lda (treasureaddr), y
    beq @treasure_not_collected
@done:
    ; Update UI
    jsr update_treasure_ui
@treasure_not_collected:
    rts

.endif