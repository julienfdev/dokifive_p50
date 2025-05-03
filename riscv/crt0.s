.globl _start
.section .text
_start:
    la sp, _stack_top    # Set stack pointer to _stack_top
    call main            # Call main()
1:  j 1b                 # Infinite loop after main returns