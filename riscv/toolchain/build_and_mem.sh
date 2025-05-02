#!/bin/sh
set -e

riscv64-unknown-elf-as --march=rv32i --mabi=ilp32 -o main.o ../main.s
riscv64-unknown-elf-ld -m elf32lriscv -T ../linker.ld -o main.elf ./main.o

riscv64-unknown-elf-objdump -d -M no-aliases --section=.text main.elf

python3 ./gen_instr_mem.py

rm -f main.o main.elf