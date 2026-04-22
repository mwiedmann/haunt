.ifndef TILEANIM_H
TILEANIM_H=1

.struct TileAnim
    _time_current .byte
    _time_max .byte
    _frame_current .byte
    _frame_max .byte
    _frame_last .byte
    _frames_addr .word
    _tile_addr .word ; Assumes upper VRAM
    _frame_zero_hold_time .byte
    _frame_last_hold_time .byte
    _frame_loop_type .byte ; 0 for loop, 1 for ping-pong
    _frame_dir .byte ; 1 for forward, -1 for backward, used for ping-pong animations
.endstruct

.endif