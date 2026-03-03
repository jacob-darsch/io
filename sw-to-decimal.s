.set nobreak
.set noat

.global _start
_start:
    movia   r2, 0xff200020      
    movia   r3, 0xff200040      
    movia   r4, NUMS            
    movia   sp, 0xfffffc
    movi    r5, 10
    mov     r6, sp              
    movia   r11, 0

mainLoop:
    ldwio   r7, 0(r3)           
    andi    r7, r7, 0x3FF       
    mov     r8, r7              
    
    
    mov     sp, r6
    
    
    bne     r8, r0, DivideStart
    subi    sp, sp, 4
    stw     r0, 0(sp)
    br      CountDigits
    
DivideStart:
    mov     r9, r8              
    
RLoop:
    divu    r10, r9, r5        
    mul     r11, r10, r5        
    sub     r11, r9, r11        
    subi    sp, sp, 4           
    stw     r11, 0(sp)
    mov     r9, r10            
    bgtu    r9, r0, RLoop

CountDigits:
    
    mov     r12, sp
    mov     r13, r6
    mov     r14, r0
    
CountLoop:
    beq     r12, r13, ReverseStart
    addi    r14, r14, 1
    addi    r12, r12, 4
    br      CountLoop

ReverseStart:
    
    mov     r12, sp
    mov     r13, r6
    subi    r13, r13, 4
    
    mov     r15, r14
    srli    r15, r15, 1
    
SwapLoop:
    beq     r15, r0, PrepareDisplay
    
    ldw     r16, 0(r12)
    ldw     r17, 0(r13)
    stw     r17, 0(r12)
    stw     r16, 0(r13)
    
    addi    r12, r12, 4
    subi    r13, r13, 4
    subi    r15, r15, 1
    br      SwapLoop

PrepareDisplay:
    
    mov     sp, r6
    movia   r18, 0              
    movi    r19, 0              
    
    
    mov     r20, r14
    slli    r20, r20, 2
    sub     sp, r6, r20

DisplayLoop:
    mov     r20, r14
    beq     r20, r0, WriteDisplay
    
    ldw     r21, 0(sp)
    addi    sp, sp, 4
    subi    r14, r14, 1
    
    
    add     r22, r4, r21
    ldb     r23, 0(r22)
    
    
    sll     r24, r23, r19
    or      r18, r18, r24
    
    addi    r19, r19, 8
    br      DisplayLoop

WriteDisplay:
    stwio   r18, 0(r2)
    br      mainLoop

.data
NUMS:
    .byte   0b00111111  # 0
    .byte   0b00000110  # 1
    .byte   0b01011011  # 2
    .byte   0b01001111  # 3
    .byte   0b01100110  # 4
    .byte   0b01101101  # 5
    .byte   0b01111101  # 6
    .byte   0b00000111  # 7
    .byte   0b01111111  # 8
    .byte   0b01100111  # 9
