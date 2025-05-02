import types::*;
import io::*;
module  memory_controller #(
    parameter INITIAL_MOCK_INSTR = "",
    parameter INITIAL_MOCK_DATA = ""
) (
    input logic clk, rst,

    // Hazard signals
    input logic stall_f,
    input logic flush_d,

    // Port A, instruction memory
    input logic [31:0] instr_addr,
    output logic [31:0] instr_data,

    // Port B, data memory
    input bool_t mem_write,
    input logic [31:0] mem_addr, mem_write_data,
    output logic [31:0] mem_read_data,

    output GPREGS_T GPREGS
);

localparam INSTRUCTION_ROM_START = 'h0;
localparam DATA_RAM_START = 'h200;

// Instruction
logic [31:0] instr_data_raw;
logic instruction_valid;

always_comb begin
    instruction_valid = instr_addr >= INSTRUCTION_ROM_START && instr_addr < DATA_RAM_START;
    if(!instruction_valid) begin
        instr_data = 32'hDEADBEEF;
    end else if(flush_d) begin
        instr_data = 32'b0;
    end else begin
        instr_data = instr_data_raw;
    end
end


// RAM
logic [31:0] mem_data_raw;
logic data_valid;
assign data_valid = mem_addr >= DATA_RAM_START && mem_addr < GPRMMSTART;
bool_t write_valid;
assign write_valid = (data_valid && mem_write == TRUE) ? TRUE : FALSE;
// GPRMM
logic [31:0] gprmm_read_raw;


// MEM READ DATA MULTIPLEXER
always_comb begin
    mem_read_data = 32'hDEADBEEF;

    if(mem_addr >= DATA_RAM_START && mem_addr < GPRMMSTART ) begin
        mem_read_data = mem_data_raw;
    end else if (mem_addr >= GPRMMSTART && mem_addr < GPRMMEND) begin
        mem_read_data = gprmm_read_raw;
    end
end
// MEM READ DATA MULTIPLEXER


instruction_memory #(
    .INITIAL(INITIAL_MOCK_INSTR)
) instruction_memory_instance (
    .clk(clk),
    .rst(rst),
    .en(~stall_f),
    .addr(instr_addr >> 2), // Word aligned
    .rdata(instr_data_raw)
);

// data_memory #(
//     .INITIAL(INITIAL_MOCK_DATA)
// ) data_memory_instance (
//     .clk(clk),
//     .rst(rst),
//     .we(write_valid),
//     .addr(mem_addr >> 2),
//     .wdata(mem_write_data),
//     .rdata(mem_data_raw)
// );

// 16kbits of BRAM
data_bram	data_bram_inst (
	.address(mem_addr >> 2),
	.byteena(4'b1), // No masking
	.clock (clk),
	.data (mem_write_data),
	.wren (write_valid),
	.q (mem_data_raw)
	);


gprmm_registers gprmm_registers_instance (
    .clk(clk),
    .rst(rst),
    .wen(mem_write),
    .rwaddr(mem_addr), // Byte aligned
    .wdata(mem_write_data),
    .rdata(gprmm_read_raw),
    .GPREGS(GPREGS)
);


endmodule
