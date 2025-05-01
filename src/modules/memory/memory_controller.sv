import types::*;
module  memory_controller #(
    parameter INITIAL_MOCK_INSTR = "",
    parameter INITIAL_MOCK_DATA = ""
) (
    input logic clk, rst,


    // Port A, instruction memory
    input logic [31:0] instr_addr,
    output logic [31:0] instr_data,

    // Port B, data memory
    input bool_t mem_write,
    input logic [31:0] mem_addr, mem_write_data,
    output logic [31:0] mem_read_data,

    // Seven segments
    output logic [31:0] seven_segment_display
);

localparam INSTRUCTION_ROM_START = 'h0;
localparam DATA_RAM_START = 'h200;
localparam DATA_RAM_END = 'h300;
localparam DATA_SEVEN_SEGMENTS_ADDR = 'h400;

// Instruction
logic [31:0] instr_data_raw;
logic instruction_valid;
assign instr_data = instruction_valid ? instr_data_raw : 32'hDEADBEEF;
assign instruction_valid = instr_addr >= INSTRUCTION_ROM_START && instr_addr < DATA_RAM_START;

// RAM
logic [31:0] mem_data_raw;
logic data_valid, sevensegment_valid;
bool_t write_valid;
assign write_valid = (data_valid && mem_write == TRUE) ? TRUE : FALSE;
assign data_valid = mem_addr >= DATA_RAM_START && mem_addr < DATA_RAM_END;
assign mem_read_data = data_valid ? mem_data_raw : 32'hDEADBEEF;
assign sevensegment_valid = mem_addr == DATA_SEVEN_SEGMENTS_ADDR;


instruction_memory #(
    .INITIAL(INITIAL_MOCK_INSTR)
) instruction_memory_instance (
    .clk(clk),
    .rst(rst),
    .addr(instr_addr >> 2), // Word aligned
    .rdata(instr_data_raw)
);

data_memory #(
    .INITIAL(INITIAL_MOCK_DATA)
) data_memory_instance (
    .clk(clk),
    .we(write_valid),
    .addr(mem_addr >> 2),
    .wdata(mem_write_data),
    .rdata(mem_data_raw)
);

// Seven segments
en_clr_arst_register #(
    .WIDTH(32)
) seven_segments_register_instance (
    .d(mem_write_data),
    .q(seven_segment_display),
    .clk(clk),
    .rst(rst),
    .en(sevensegment_valid),
    .clr(1'b0)
);

endmodule
