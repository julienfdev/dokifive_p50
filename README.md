# DokiFive P50: RISC-V CPU for DE10-Lite

## Overview
DokiFive P50 is a custom RISC-V RV32I CPU core designed for the Intel/Altera DE10-Lite FPGA board. The CPU implements the full RV32I instruction set architecture, supporting all base integer instructions, including arithmetic, logic, control flow, memory access, and system instructions. The design is modular, with a clear separation between datapath, control unit, hazard handling, and memory subsystems.

The core can easily be edited to run on different hardware, juste make sure to replace the instruction and data memory with your vendor IP.

## CPU Architecture
The CPU is a classic 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback) RISC-V processor, but modified to accomodate real hardware BRAM timings (it has an additional "Instruction Wait" pipeline stage) with hazard detection and forwarding logic. The Hazard Unit implements an FSM that can easily be extended to support slower memory (using the `readdatavalid` logic signal)

It features:
- Full support for RV32I, including all load/store, branch, jump, and arithmetic instructions.
- Byte and halfword memory access with proper sign/zero extension.
- Data hazard detection and forwarding to minimize pipeline stalls.
- Control hazard handling with flush and stall signals.
- Modular design: separate modules for ALU, register file, control logic, hazard unit, and memory controller.

### Memory map

- **Instruction ROM**: 0x00000000 - 0x0000FFFF (64 KB)
- **Data RAM**: 0x10000000 - 0x10007FFF (32 KB)
- **GPRMM (General Purpose Registers, Memory-Mapped IO)**: 0x30000000 - 0x3FFFFFFF
    - GPRMM1: 0x30000000
    - GPRMM2: 0x30000001

Please note that Instruction and Data memories are address-registered, data read is combinational.
General purpose registers are synchronous write, combinational read.

Addresses outside these ranges return undefined or default values (e.g., 0xDEADBEEF for unmapped memory).

## FPGA Integration (DE10-Lite)
The top-level module (`DokiFive_p50_top`) instantiates the CPU and connects it to on-chip memory, SDRAM, and peripherals (LEDs, switches, 7-segment displays, VGA, Arduino headers). Pin assignments and I/O standards are defined in the Quartus `.qsf` file for the DE10-Lite board. The memory controller provides access to instruction and data memory, as well as memory-mapped I/O for peripherals.

### Performance
On standard DE10-Lite hardware, considering no peripheral constraints, the core can run at a calculated 55.72MHz, it's perfectly suited to use with the 50MHz clock.

## Simulation and Testing
The `simulation/` folder contains ModelSim/Questa simulation project files, testbenches, and memory initialization files. The testbench (`tb_soc.sv`) simulates the SoC, including the CPU and memory system. You can run simulations to verify correct execution of RISC-V programs and observe CPU behavior.

## RISC-V Software and Code Examples
The `riscv/` folder contains:
- Example C and assembly programs (e.g., `fibonacci.c`, `crt0.s`).
- A linker script (`linker.ld`) that places code and data using the correct memory map for the CPU.
- A Makefile to build RISC-V binaries using GCC and convert them to memory initialization files (`instr_init.mem`) for simulation or FPGA loading.
- A Python script (`gen_instr_mem.py`) to extract instruction memory contents from ELF files and format it in a `$readmemh` friendly format.

You can write your own C or assembly programs, build them with the provided toolchain, and run them on the CPU in simulation or on the FPGA.

## Getting Started
1. Build your RISC-V program in the `riscv/` folder using the Makefile.
2. Load the generated `instr_init.mem` into the simulation or FPGA bitstream.
3. Use the provided testbenches or deploy to the DE10-Lite board to observe program execution and interact with peripherals.

## License
See `LICENSE.md` for licensing information.
