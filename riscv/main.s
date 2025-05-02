.globl _start
.equ _start, 0x00000000
# RAM address space
.equ RAM_START, 0x200
.equ SEVEN_SEG_ADDR, 0x300



.text
_start:
lui s0, 0x1 # t0 = zero + 1337
addi s0, s0, 823
increment_segment:
sw s0, SEVEN_SEG_ADDR(zero)
addi s0, s0, 1
j increment_segment
nop
nop
nop
nop
nop

