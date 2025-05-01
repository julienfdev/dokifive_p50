import types::*;

module control_e_m_register(
    input logic clk, rst, en, clr,

    // Execute inputs
    input bool_t reg_write_e,
    input logic mem_write_e,
    input result_src_t result_src_e,

    // Memory outputs
    output bool_t reg_write_m,
    output logic  mem_write_m,
    output result_src_t result_src_m
);

    // EXECUTE_MEMORY REGISTER
    en_clr_arst_register #(
        .WIDTH(bool_t)
    ) reg_write_e_m (
        .d(reg_write_e),
        .q(reg_write_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(logic)
    ) mem_write_e_m (
        .d(mem_write_e),
        .q(mem_write_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(result_src_t)
    ) result_src_e_m (
        .d(result_src_e),
        .q(result_src_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );
    
endmodule
