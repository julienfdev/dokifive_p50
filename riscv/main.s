.globl _start
.equ _start, 0x00000000
# RAM address space
.equ RAM_START, 0x200



.text
_start:
addi s0, zero, 1337 # t0 = zero + 1337
addi t0, zero, RAM_START # prepare the RAM address to store 1337
nop
nop # we don't do hazard handling yet and sw depends on both addis
sw s0, 4(t0)
addi s1, zero, 1000
nop # I think we don't need that
lw s1, 4(t0)
addi s1, s1, 337
nop
nop # we will use the result from the addi
beq s0, s1, branch; # if s0 == s1 then branch
nop
nop
nop
nop
nop
nop
nop
nop
branch:
addi s0, s0, 100
addi s1, s1, 200
addi t2, zero, 3
nop
nop
sll  s0, s0, t2
srli s1, s1, 2
nop
nop
or  s3, s0, s1



