import sys
import subprocess
import re

if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} <input.elf> <output.mem>")
    sys.exit(1)

input_elf = sys.argv[1]
output_mem = sys.argv[2]

# Dump instructions using objdump
objdump = subprocess.check_output([
    "riscv64-unknown-elf-objdump",
    "-d", "-M", "no-aliases", "--section=.text", input_elf
], encoding="utf-8")

# Extract instruction hex codes
lines = objdump.splitlines()
instrs = []
for line in lines:
    m = re.match(r'\s*[0-9a-f]+:\s*([0-9a-f]{8})', line)
    if m:
        instrs.append(m.group(1))

# Write to output memory file
with open(output_mem, "w") as f:
    for instr in instrs:
        f.write(instr + "\n")