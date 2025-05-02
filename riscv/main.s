.globl _start
.equ _start, 0x00000000
# RAM address space
.equ RAM_START, 0x200
.equ SEVEN_SEG_ADDR, 0x300



.text
_start:
li s0, 0x7331
sw s0, SEVEN_SEG_ADDR(zero)
increment_segment:
lw t2, SEVEN_SEG_ADDR(zero)
addi s1, t2, 1
sw s1, SEVEN_SEG_ADDR(zero)
addi s1, zero, 0 # back to zero to ensure it's LW and SW that do the job
j increment_segment
nop # I need to solve this (IW step needs to be flushed)
sw s1, SEVEN_SEG_ADDR(zero)

