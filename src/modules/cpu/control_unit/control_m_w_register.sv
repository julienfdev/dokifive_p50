import types::*;

module control_m_w_register(
    input logic clk, rst, en, clr,

    // Memory inputs
    input bool_t reg_write_m,
    input result_src_t result_src_m,

    // Writeback outputs
    output bool_t reg_write_w,
    output result_src_t result_src_w
);

    // Intermediate logic vectors
    logic [0:0] reg_write_m_vec;
    assign reg_write_w = bool_t'(reg_write_m_vec);

    logic [$bits(result_src_t)-1:0] result_src_w_vec;
    assign result_src_w = result_src_t'(result_src_w_vec);

    // MEMORY_WRITEBACK REGISTER
    en_clr_arst_register #(
        .WIDTH(1)
    ) reg_write_m_w (
        .d(reg_write_m),
        .q(reg_write_m_vec),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH($bits(result_src_t))
    ) result_src_m_w (
        .d(result_src_m),
        .q(result_src_w_vec),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

endmodule
