import types::*;
import io::*;

module dokifive_soc #(
    parameter INITIAL_INSTR = ""
) (
    input logic clk, rst,

    // Memory mapped IO
    output GPREGS_T GPREGS
);

    // Wire definition
    bool_t          mem_write;
    logic           stall_f;
    logic           flush_d;
    logic           read_en;
    logic [31:0]    instr_addr, instr_data, mem_addr, mem_data_r, mem_data_w;
    byte_half_sel_t byteenablea;

    // We need a registered flush_d signal (1 clock cycle behind !flush_d signal)
    // Because our memory has a registered address but not a registered output
    en_clr_arst_register #(
    .WIDTH(1)
    ) en_clr_arst_register_instance (
        .d(~flush_d),
        .q(read_en),
        .clk(clk),
        .rst(rst),
        .en(~rst),
        .clr(1'b0)
    );

    cpu cpu_instance (
        .clk(clk),
        .rst(rst),
        .instr_data(instr_data),
        .mem_data_r(mem_data_r),
        .instr_addr(instr_addr),
        .mem_addr_m(mem_addr),
        .mem_data_w(mem_data_w),
        .mem_write(mem_write),
        .stall_f(stall_f),
        .flush_d(flush_d),
        .byte_half_sel_m(byteenablea)
    );

    memory_controller #(
    .INITIAL_MOCK_INSTR(INITIAL_INSTR)
    ) memory_controller_instance (
        .clk(clk),
        .rst(rst),
        .stall_f(stall_f),
        .read_en(read_en),
        .instr_addr(instr_addr),
        .instr_data(instr_data),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_write_data(mem_data_w),
        .mem_read_data(mem_data_r),
        .byteenablea(byteenablea),
        .GPREGS(GPREGS)
    );

endmodule
