.ifndef IRQ_S
IRQ_S = 1

irq_routine:
    lda VERA_ISR
    and #1
    cmp #1
    beq @vsync
    bra @continue
@vsync:
    lda #1
    sta waitflag ; Signal that its ok to draw now
@continue:
    lda #10
    sta VERA_ISR
    jmp (default_irq)

irq_config:
    sei
    ; First, capture the default IRQ handler
    ; This is so we can call it after our custom handler
    lda IRQ_FUNC_ADDR
    sta default_irq
    lda IRQ_FUNC_ADDR+1
    sta default_irq+1
    ; Now replace it with our custom handler
    lda #<irq_routine
    sta IRQ_FUNC_ADDR
    lda #>irq_routine
    sta IRQ_FUNC_ADDR+1
    ; Just VSYNC
    lda #%1
    sta VERA_IEN
    cli
    rts

irq_restore:
    sei
    lda default_irq
    sta IRQ_FUNC_ADDR
    lda default_irq+1
    sta IRQ_FUNC_ADDR+1
    cli
    rts

.endif