.globl _start
.equ _start, 0x00000000

.data
    .globl test_var

test_var:
    .word 0x12345678

.bss
    .globl global_a
    .globl global_b
    .align 2
global_a:
    .space 4
    .align 2
global_b:
    .space 4

.text
_start:
    li t0, 1         # t0 = 1
    li t1, 2         # t1 = 2

    # Test SW/LW with uninitialized global variable
    li t2, 0xCAFEBABE      # t2 = test value
    la t3, global_a        # t3 = address of global_a
    sw t2, 0(t3)           # Store t2 to global_a
    li t2, 0               # Clear t2
    lw t2, 0(t3)           # Load from global_a into t2
    mv s8, t2              # Save loaded value for observation

    # BEQ: should NOT branch (1 != 2)
    li s1, 0         # s1 = 0 (default)
    beq t0, t1, beq_taken
    li s1, 10        # Not taken
    j bne_test
beq_taken:
    li s1, 11        # Taken

bne_test:
    # BNE: should branch (1 != 2)
    li s2, 0
    bne t0, t1, bne_taken
    li s2, 20        # Not taken
    j blt_test
bne_taken:
    li s2, 21        # Taken

blt_test:
    # BLT: should branch (1 < 2)
    li s3, 0
    blt t0, t1, blt_taken
    li s3, 30        # Not taken
    j bge_test
blt_taken:
    li s3, 31        # Taken

bge_test:
    # BGE: should NOT branch (1 >= 2 is false)
    li s4, 0
    bge t0, t1, bge_taken
    li s4, 40        # Not taken
    j bltu_test
bge_taken:
    li s4, 41        # Taken

bltu_test:
    # BLTU: should branch (1 < 2 unsigned)
    li s5, 0
    bltu t0, t1, bltu_taken
    li s5, 50        # Not taken
    j bgeu_test
bltu_taken:
    li s5, 51        # Taken

bgeu_test:
    # BGEU: should NOT branch (1 >= 2 unsigned is false)
    li s6, 0
    bgeu t0, t1, bgeu_taken
    li s6, 60        # Not taken
    j auipc_test
bgeu_taken:
    li s6, 61        # Taken

auipc_test:
    auipc t3, 0x12300   
    addi  t3, t3, 0x100  # t3 = t3 + 0x100 (lower 12 bits)
    mv    s7, t3         # Save result for observation

end:
    j end

