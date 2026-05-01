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
    lda #TORCH_TILE_ID
    ldy #TileAnim::_tile_id
    sta (tileanimaddr), y
    lda #TORCH_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #TORCH_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    dec
    ldy #TileAnim::_frame_last
    sta (tileanimaddr), y
    lda #0
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
    ldy #TileAnim::_frame_last_hold_time
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_loop_type
    sta (tileanimaddr), y
    lda #1 ; Start moving forward
    ldy #TileAnim::_frame_dir
    sta (tileanimaddr), y
    jsr inc_tileanimaddr

; Floor torch
    lda #TORCH_FLOOR_TILE_ID
    ldy #TileAnim::_tile_id
    sta (tileanimaddr), y
    lda #TORCH_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #TORCH_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    dec
    ldy #TileAnim::_frame_last
    sta (tileanimaddr), y
    lda #0
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
    ldy #TileAnim::_frame_last_hold_time
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_loop_type
    sta (tileanimaddr), y
    lda #1 ; Start moving forward
    ldy #TileAnim::_frame_dir
    sta (tileanimaddr), y
    jsr inc_tileanimaddr

; Spikes
    lda #SPIKES_TILE_ID
    ldy #TileAnim::_tile_id
    sta (tileanimaddr), y
    lda #SPIKES_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #SPIKES_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    dec
    ldy #TileAnim::_frame_last
    sta (tileanimaddr), y
    lda #0
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
    lda #SPIKES_FRAME_LAST_HOLD_TIME
    ldy #TileAnim::_frame_last_hold_time
    sta (tileanimaddr), y
    lda #1 ; Ping pong animation, start moving forward
    ldy #TileAnim::_frame_loop_type
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_dir
    sta (tileanimaddr), y
    jsr inc_tileanimaddr

; Pit
    lda #PIT_TILE_ID
    ldy #TileAnim::_tile_id
    sta (tileanimaddr), y
    lda #PIT_ANIM_COUNT
    ldy #TileAnim::_time_max
    sta (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y
    lda #PIT_FRAMES
    ldy #TileAnim::_frame_max
    sta (tileanimaddr), y
    dec
    ldy #TileAnim::_frame_last
    sta (tileanimaddr), y
    lda #0
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
    lda #PIT_FRAME_LAST_HOLD_TIME
    ldy #TileAnim::_frame_last_hold_time
    sta (tileanimaddr), y
    lda #1 ; Ping pong animation, start moving forward
    ldy #TileAnim::_frame_loop_type
    sta (tileanimaddr), y
    ldy #TileAnim::_frame_dir
    sta (tileanimaddr), y
    jsr inc_tileanimaddr

    rts

anim_idx: .byte 0
anim_frame: .byte 0
anim_tile_address: .word 0

reverse_anim_frame:
    ; Ping pong - reverse direction
    ldy #TileAnim::_frame_dir
    lda (tileanimaddr), y
    eor #$FE ; Flip between 1 and -1
    sta (tileanimaddr), y
    rts

advance_frame:
    ldy #TileAnim::_frame_current
    clc
    adc (tileanimaddr), y
    sta (tileanimaddr), y
    rts

run_tile_animations:
    lda #TILE_ANIMS_COUNT+1
    sta anim_idx
    lda #<tile_animations
    sta tileanimaddr
    lda #>tile_animations
    sta tileanimaddr+1
next_tile_anim:
    dec anim_idx
    lda anim_idx
    bne @process_tile_anim
    rts
@process_tile_anim:
    ldy #TileAnim::_time_current
    lda (tileanimaddr), y
    dec
    sta (tileanimaddr), y
    beq @next_tile_frame
    jsr inc_tileanimaddr
    jmp next_tile_anim
@next_tile_frame:
    ; Reset the time
    ldy #TileAnim::_time_max
    lda (tileanimaddr), y
    ldy #TileAnim::_time_current
    sta (tileanimaddr), y

    ; Advance the frame
    ldy #TileAnim::_frame_dir
    lda (tileanimaddr), y
    jsr advance_frame
    ldy #TileAnim::_frame_max
    cmp (tileanimaddr), y
    beq @check_frame_type
@check_frame_zero:
    ldy #TileAnim::_frame_current
    lda (tileanimaddr), y
    bne @check_last_frame
    ; check if ping pong or looping
    ; ldy #TileAnim::_frame_loop_type
    ; lda (tileanimaddr), y
    ; beq @loop_back
    jsr reverse_anim_frame
    bra @check_zero_frame
@check_frame_type:
    ; check if ping pong or looping
    ldy #TileAnim::_frame_loop_type
    lda (tileanimaddr), y
    beq @loop_back
    jsr reverse_anim_frame
    ; move the frame back within bounds
    jsr advance_frame
    bra @check_last_frame
@loop_back:
    lda #0
    ldy #TileAnim::_frame_current
    sta (tileanimaddr), y
@check_zero_frame:
    ; See if frame 0 is held for extra time
    ldy #TileAnim::_frame_zero_hold_time
    lda (tileanimaddr), y
    beq @show_frame ; No extra hold, move to next anim
    clc
    ldy #TileAnim::_time_current
    adc (tileanimaddr), y
    sta (tileanimaddr), y
    bra @show_frame
@check_last_frame:
    ldy #TileAnim::_frame_last
    cmp (tileanimaddr), y
    bne @show_frame
    ; See if last is held for extra time
    ldy #TileAnim::_frame_last_hold_time
    lda (tileanimaddr), y
    beq @show_frame ; No extra hold, move to next anim
    clc
    ldy #TileAnim::_time_current
    adc (tileanimaddr), y
    sta (tileanimaddr), y
@show_frame:
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
    jmp next_tile_anim
@done:
    rts

handle_anim_frame:
; move to correct frame
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