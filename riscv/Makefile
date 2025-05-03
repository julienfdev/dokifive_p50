RISCV_GCC = riscv64-unknown-elf-gcc
RISCV_OBJDUMP = riscv64-unknown-elf-objdump
RISCV_OBJCOPY = riscv64-unknown-elf-objcopy
AS = riscv64-unknown-elf-as
LD = riscv64-unknown-elf-ld
PYTHON = python3

ASFLAGS = -march=rv32i -mabi=ilp32 -Wall
CFLAGS = -march=rv32i -mabi=ilp32 -Wall -O2 -nostdlib -ffreestanding
LDFLAGS = -T linker.ld -nostdlib

all: instr_init.mem

crt0.o: crt0.s
	$(AS) $(ASFLAGS) -o ./out/$@ $<

fibonacci.o: fibonacci.c
	$(RISCV_GCC) $(CFLAGS) -c -o ./out/$@ $<

main.elf: crt0.o fibonacci.o
	$(RISCV_GCC) $(CFLAGS) ./out/crt0.o ./out/fibonacci.o -o ./out/$@ $(LDFLAGS)

instr_init.mem: main.elf
	$(PYTHON) gen_instr_mem.py ./out/main.elf instr_init.mem

clean:
	rm -f ./out/*.o /out/*.elf instr_init.mem

dump: main.elf
	$(RISCV_OBJDUMP) -D -M no-aliases --section=.text ./out/main.elf 