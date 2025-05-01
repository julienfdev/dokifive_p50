import types::*;

module control_e_m_register(
    input logic clk, rst, en, clr,

    // Execute inputs
    input bool_t reg_write_e,
    input bool_t mem_write_e,
    input result_src_t result_src_e,

    // Memory outputs
    output bool_t reg_write_m,
    output bool_t mem_write_m,
    output result_src_t result_src_m
);

    // Intermediate logic vectors
    logic [0:0] reg_write_m_vec, mem_write_m_vec;
    assign reg_write_m = bool_t'(reg_write_m_vec);
    assign mem_write_m = bool_t'(mem_write_m_vec);

    logic [$bits(result_src_t)-1:0] result_src_m_vec;
    assign result_src_m = result_src_t'(result_src_m_vec);

    // EXECUTE_MEMORY REGISTER
    en_clr_arst_register #(
        .WIDTH(1)
    ) reg_write_e_m (
        .d(reg_write_e),
        .q(reg_write_m_vec),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(1)
    ) mem_write_e_m (
        .d(mem_write_e),
        .q(mem_write_m_vec),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH($bits(result_src_t))
    ) result_src_e_m (
        .d(result_src_e),
        .q(result_src_m_vec),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );
    
endmodule
