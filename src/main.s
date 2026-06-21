.zeropage
    addr: .res 2
    addr2: .res 2
    mapbase_addr: .res 2
    yOffset: .res 2
    xOffset: .res 2
    row_count: .res 1
    tempOffset: .res 2
    draw_bank: .res 1
    draw_offset: .res 2
    draw_count: .res 1
    xPosStart: .res 1
    xPosStartAdj: .res 1
    yPosStart: .res 1
    yPosStartAdj: .res 1
    xMid: .res 1
    xMidAdj: .res 1
    yMid: .res 1
    yMidAdj: .res 1
    xLastMid: .res 1
    yLastMid: .res 1
    guyLastX: .res 1
    guyLastY: .res 1
    tileanimaddr: .res 2
    treasureaddr: .res 2
    gasaddr: .res 2

.segment "STARTUP"
    jmp start

.segment "ONCE"

.include "x16.inc"
.include "config.inc"
.include "tileanim.inc"
.include "treasure.inc"
.include "zsmkit.inc"

.segment "CODE"

default_irq: .word 0
waitflag: .byte 0
zsmreserved: .res 256

.include "config.s"
.include "guy.s"
.include "ui.s"
.include "gas.s"
.include "level.s"
.include "irq.s"
.include "move.s"
.include "floor.s"
.include "draw.s"
.include "loading.s"
.include "controls.s"
.include "pal.s"
.include "sprites.s"
.include "tiles.s"
.include "title.s"
.include "dead.s"
.include "wait.s"
.include "treasure.s"
.include "sound.s"

start:
    jsr sound_init
    jsr load_soundfx
    jsr show_intro
    jsr irq_config
restart:
    ; hide layers until everything loaded
    lda #VERA_LAYERS_OFF_DC_VIDEO_BITS
    sta VERA_DC_VIDEO
    jsr load_pal
    jsr change_wall_color
    jsr load_tiles
    jsr load_ui
    jsr config
    jsr init_tile_animations
    jsr find_start
    jsr set_xy_pos
    jsr guy_reset_health
    jsr guy_reset_score
    jsr load_game_music
    jsr play_music
    bra @draw_everything ; initial draw
@main_loop:
    lda guy_dead
    beq @not_dead
    jmp dead
@not_dead:
    jsr check_gas
    jsr guy_check_fire
    lda guy_stunned
    bne @cant_move
    jsr check_controls
@cant_move:
    jsr check_damage_sound_timer
    stz guy_stunned
    jsr set_xy_pos
    jsr check_floor_val
    lda hit_exit
    bne @next_level
    lda moved
    bne @draw_everything
    jsr guy_still
    lda gas_spread
    beq @waiting
@draw_everything:
    jsr move_guy_sprite
    lda current_tile
    beq @not_blocked
    ; Blocked...move back
    lda xLastMid
    sta xMid
    lda yLastMid
    sta yMid
    lda guyLastX
    sta guyX
    lda guyLastY
    sta guyY
    jsr set_xy_pos
@not_blocked:
    lda xMid
    sta xLastMid
    lda yMid
    sta yLastMid
    jsr calc_draw_bank
    jsr draw_bank_to_vram_hold
@waiting:
    lda waitflag
    cmp #0
    beq @waiting
    stz waitflag
    jsr run_tile_animations
    jsr scroll_layers
    jsr copy_vram_hold_to_vram
    bra @main_loop
@next_level:
    stz hit_exit
    lda treasure_total_collected
    cmp #TREASURE_TOTAL_COUNT
    bne @not_last_treasure
    jmp escaped
@not_last_treasure:
    jsr stop_music
    jsr load_level
    jsr play_music
    jsr change_wall_color
    jsr remove_found_treasure
    jsr find_start
    jsr set_xy_pos
    bra @draw_everything ; initial draw

dead:
    jsr load_ui2
    jsr update_score
    jsr draw_all_treasure_ui
    jsr pick_ranking
    jsr watch_for_joystick_press
    jsr show_game_over
    jsr show_intro
    jmp restart

escaped:
    jsr show_escaped
    jsr show_intro
    jmp restart

reset_game:
    stz level
    stz guy_dead
    stz guy_on_fire
    stz treasure_total_collected
    jsr load_level
    jsr init_treasure_sets
    jsr load_animated_tiles
    jsr clear_extra_vram_row
    jsr create_guy
    rts

show_intro:
    jsr show_title
    jsr load_title_music
    jsr play_music
    jsr watch_for_joystick_press
    jsr stop_music
    jsr reset_game
    rts