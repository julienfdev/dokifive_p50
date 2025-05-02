import subprocess
import re

# Dump instructions using objdump
objdump = subprocess.check_output([
    "riscv64-unknown-elf-objdump",
    "-d", "-M", "no-aliases", "--section=.text", "main.elf"
], encoding="utf-8")

# Extract instruction hex codes
lines = objdump.splitlines()
instrs = []
for line in lines:
    m = re.match(r'\s*[0-9a-f]+:\s*([0-9a-f]{8})', line)
    if m:
        # Write as-is, do not reverse bytes
        instrs.append(m.group(1))

# Write to instr_init.mem
with open("../instr_init.mem", "w") as f:
    for instr in instrs:
        f.write(instr + "\n")