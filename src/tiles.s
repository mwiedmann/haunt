.ifndef TILES_S
TILES_S = 1

tile_animations: .res .sizeof(TileAnim) * TILE_ANIMS_COUNT

inc_tileanimaddr:
    clc
    lda tileanimaddr
    adc #<(.sizeof(TileAnim))
    sta tileanimaddr
    lda tileanimaddr+1
    adc #>(.sizeof(TileAnim))
    sta tileanimaddr+1
    rts

init_tile_animations:
    lda #<tile_animations
    sta tileanimaddr
    lda #>tile_animations
    sta tileanimaddr+1
; Wall torch
    lda #TORCH_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #TORCH_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_current
    sta (tileanimaddr), y
    lda #<TORCH_MEM_ADDR
    ldy #TileAnim::_frames_addr
    sta (tileanimaddr), y
    lda #>TORCH_MEM_ADDR
    ldy #TileAnim::_frames_addr+1
    sta (tileanimaddr), y
    lda #<TORCH_TILE_ADDR
    ldy #TileAnim::_tile_addr
    sta (tileanimaddr), y
    lda #>TORCH_TILE_ADDR
    ldy #TileAnim::_tile_addr+1
    sta (tileanimaddr), y
    lda #0
    ldy #TileAnim::_frame_zero_hold_time
    sta (tileanimaddr), y

    jsr inc_tileanimaddr

; Floor torch
    lda #TORCH_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #TORCH_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_current
    sta (tileanimaddr), y
    lda #<TORCH_FLOOR_MEM_ADDR
    ldy #TileAnim::_frames_addr
    sta (tileanimaddr), y
    lda #>TORCH_FLOOR_MEM_ADDR
    ldy #TileAnim::_frames_addr+1
    sta (tileanimaddr), y
    lda #<TORCH_FLOOR_TILE_ADDR
    ldy #TileAnim::_tile_addr
    sta (tileanimaddr), y
    lda #>TORCH_FLOOR_TILE_ADDR
    ldy #TileAnim::_tile_addr+1
    sta (tileanimaddr), y
    lda #0
    ldy #TileAnim::_frame_zero_hold_time
    sta (tileanimaddr), y
    jsr inc_tileanimaddr

; Spikes
    lda #SPIKES_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #SPIKES_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_current
    sta (tileanimaddr), y
    lda #<SPIKES_MEM_ADDR
    ldy #TileAnim::_frames_addr
    sta (tileanimaddr), y
    lda #>SPIKES_MEM_ADDR
    ldy #TileAnim::_frames_addr+1
    sta (tileanimaddr), y
    lda #<SPIKES_TILE_ADDR
    ldy #TileAnim::_tile_addr
    sta (tileanimaddr), y
    lda #>SPIKES_TILE_ADDR
    ldy #TileAnim::_tile_addr+1
    sta (tileanimaddr), y
    lda #SPIKES_FRAME_ZERO_HOLD_TIME
    ldy #TileAnim::_frame_zero_hold_time
    sta (tileanimaddr), y
    jsr inc_tileanimaddr

; Pit
    lda #PIT_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #PIT_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_current
    sta (tileanimaddr), y
    lda #<PIT_MEM_ADDR
    ldy #TileAnim::_frames_addr
    sta (tileanimaddr), y
    lda #>PIT_MEM_ADDR
    ldy #TileAnim::_frames_addr+1
    sta (tileanimaddr), y
    lda #<PIT_TILE_ADDR
    ldy #TileAnim::_tile_addr
    sta (tileanimaddr), y
    lda #>PIT_TILE_ADDR
    ldy #TileAnim::_tile_addr+1
    sta (tileanimaddr), y
    lda #PIT_FRAME_ZERO_HOLD_TIME
    ldy #TileAnim::_frame_zero_hold_time
    sta (tileanimaddr), y

    rts

anim_idx: .byte 0
anim_frame: .byte 0
anim_tile_address: .word 0

run_tile_animations:
    lda #TILE_ANIMS_COUNT+1
    sta anim_idx
    lda #<tile_animations
    sta tileanimaddr
    lda #>tile_animations
    sta tileanimaddr+1
@next_tile_anim:
    dec anim_idx
    lda anim_idx
    beq @done
    ldy #TileAnim::_time_current
    lda (tileanimaddr), y
    dec
    sta (tileanimaddr), y
    beq @next_tile_frame
    jsr inc_tileanimaddr
    bra @next_tile_anim
@next_tile_frame:
    ; Reset the time
    ldy #TileAnim::_time_max
    lda (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y

    lda #ANIM_BANK
    sta BANK
    ldy #TileAnim::_frames_addr
    lda (tileanimaddr), y
    sta addr2
    ldy #TileAnim::_frames_addr+1
    lda (tileanimaddr), y
    sta addr2+1
    
    ldy #TileAnim::_frame_current
    lda (tileanimaddr), y
    tax

    ldy #TileAnim::_tile_addr
    lda (tileanimaddr), y
    sta anim_tile_address
    ldy #TileAnim::_tile_addr+1
    lda (tileanimaddr), y
    sta anim_tile_address+1

    jsr handle_anim_frame

    ; Advance the frame
    ldy #TileAnim::_frame_current
    lda (tileanimaddr), y
    dec
    sta (tileanimaddr), y
    cmp #0
    bne @next_tile_anim
    ldy #TileAnim::_frame_max
    lda (tileanimaddr), y
    ldy #TileAnim::_frame_current
    sta (tileanimaddr), y

    ; See if frame 0 is held for extra time
    ldy #TileAnim::_frame_zero_hold_time
    lda (tileanimaddr), y
    beq @next_tile_anim ; No extra hold, move to next anim
    clc
    ldy #TileAnim::_time_current
    adc (tileanimaddr), y
    sta (tileanimaddr), y

    bra @next_tile_anim
@done:
    rts

handle_anim_frame:
; move to correct frame
    dex ; counts down to 0
@check_frame:
    cpx #0
    beq @frame_set
    dex
    inc addr2+1 ; This works because frames are 256 bytes
    bra @check_frame
@frame_set:
    lda anim_tile_address
    sta VERA_ADDR_LO
    lda anim_tile_address + 1
    sta VERA_ADDR_MID
    lda #VERA_ADDR_HI_INC_UPPERVRAM_BITS
    sta VERA_ADDR_HI_SET

    lda addr2
    sta R0L
    lda addr2 + 1
    sta R0H
    lda #<VERA_DATA0
    sta R1L
    lda #>VERA_DATA0
    sta R1H
    lda #<256
    sta R2L
    lda #>256
    sta R2H
    jsr MEMCOPY
    
    rts
    
.endif