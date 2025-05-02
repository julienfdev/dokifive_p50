import types::*;
import io::*;

module dokifive_soc #(
    parameter INITIAL_RF = "",
    parameter INITIAL_MOCK_INSTR = "",
    parameter INITIAL_MOCK_DATA = ""
) (
    input logic clk, rst,

    // Memory mapped IO
    output GPREGS_T GPREGS
);

    // Wire definition
    bool_t mem_write;
    logic [31:0] instr_addr, instr_data, mem_addr, mem_data_r, mem_data_w;

    cpu #(
    .INITIAL_RF(INITIAL_RF)
    ) cpu_instance (
        .clk(clk),
        .rst(rst),
        .instr_data(instr_data),
        .mem_data_r(mem_data_r),
        .instr_addr(instr_addr),
        .mem_addr(mem_addr),
        .mem_data_w(mem_data_w),
        .mem_write(mem_write)
    );

    memory_controller #(
        .INITIAL_MOCK_INSTR(INITIAL_MOCK_INSTR),
        .INITIAL_MOCK_DATA(INITIAL_MOCK_DATA)
    ) memory_controller_instance (
        .clk(clk),
        .rst(rst),
        .instr_addr(instr_addr),
        .instr_data(instr_data),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_write_data(mem_data_w),
        .mem_read_data(mem_data_r),
        .GPREGS(GPREGS)
    );

endmodule
