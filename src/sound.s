.ifndef SOUND_S
SOUND_S = 1

SOUND_PRIORITY_MAIN = 0
SOUND_PRIORITY_MUSIC = 1
SOUND_PRIORITY_DANGER = 2

DAMAGE_TIMER = 30

DAMAGE_MEM = HIRAM
TREASURE_MEM = DAMAGE_MEM + 512

zsmkit_filename: .asciiz "zsmkit.bin"

soundmuted: .byte 0
damage_timer: .byte 0

sound_init:
	; load the zsmkit code into banked RAM
	lda #ZSM_BANK
	sta BANK
    lda #10
    ldx #<zsmkit_filename
    ldy #>zsmkit_filename
    jsr SETNAM
    ; 0,8,2
    lda #0
    ldx #8
    ldy #2
    jsr SETLFS
    lda #0
    ldx #<HIRAM
    ldy #>HIRAM
    jsr LOAD
	; Init zsmkit
	lda #ZSM_BANK
	sta BANK
    ldx #<zsmreserved
    ldy #>zsmreserved
	jsr zsm_init_engine
	lda #ZSM_BANK
	sta BANK
	jsr zsmkit_setisr
	jsr sound_set_bank
    rts

sound_set_bank:
	; Set bank for all priorities
	ldx #0
	lda #SOUND_BANK
	jsr zsm_setbank
	ldx #1
	lda #MUSIC_BANK
	jsr zsm_setbank
	ldx #2
	lda #DANGER_BANK
	jsr zsm_setbank
	ldx #3
	lda #SOUND_BANK
	jsr zsm_setbank
	rts

sound_damage_play:
	; Don't spam the sound too quickly
	lda damage_timer
	bne @done
	lda #DAMAGE_TIMER
	sta damage_timer
	lda #ZSM_BANK
	sta BANK
	lda soundmuted
	cmp #1
	beq @done
	lda #<DAMAGE_MEM
	ldx #SOUND_PRIORITY_MAIN ; Priority
	ldy #>DAMAGE_MEM; address hi to Y
	jsr zsm_setmem
	ldx #SOUND_PRIORITY_MAIN
	jsr zsm_play
@done:
	rts

check_damage_sound_timer:
	lda damage_timer
	beq @done
	dec damage_timer
@done:
	rts

sound_treasure_play:
	lda #ZSM_BANK
	sta BANK
	lda soundmuted
	cmp #1
	beq @done
	lda #<TREASURE_MEM
	ldx #SOUND_PRIORITY_MAIN ; Priority
	ldy #>TREASURE_MEM; address hi to Y
	jsr zsm_setmem
	ldx #SOUND_PRIORITY_MAIN
	jsr zsm_play
@done:
	rts

play_music:
	lda #ZSM_BANK
	sta BANK
	lda soundmuted
	cmp #1
	beq @done
	lda #<HIRAM
	ldx #SOUND_PRIORITY_MUSIC ; Priority
	ldy #>HIRAM; address hi to Y
	jsr zsm_setmem
	ldx #SOUND_PRIORITY_MUSIC
	jsr zsm_play
	ldx #SOUND_PRIORITY_MUSIC ; Priority
	sec
	jsr zsm_setloop
@done:
    rts

play_danger:
	lda #ZSM_BANK
	sta BANK
	lda soundmuted
	cmp #1
	beq @done
	lda #<HIRAM
	ldx #SOUND_PRIORITY_DANGER ; Priority
	ldy #>HIRAM; address hi to Y
	jsr zsm_setmem
	ldx #SOUND_PRIORITY_DANGER
	jsr zsm_play
	ldx #SOUND_PRIORITY_DANGER ; Priority
	sec
	jsr zsm_setloop
@done:
    rts

stop_music:
	lda #ZSM_BANK
	sta BANK
	lda soundmuted
	cmp #1
	beq @done
	ldx #SOUND_PRIORITY_MUSIC
	jsr zsm_stop
@done:
	rts

sound_toggle:
	lda soundmuted
	eor #%1
	sta soundmuted
	rts

.endif