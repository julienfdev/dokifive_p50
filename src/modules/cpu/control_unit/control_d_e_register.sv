import types::*;

module control_d_e_register(
    input logic clk, rst, en, clr,

    // Decode inputs
    input bool_t reg_write_d,
    input logic mem_write_d, jump_d, branch_d,
    input result_src_t result_src_d,
    input alu_op_t alu_op_d,
    input alu_src_b_sig_t alu_src_b_sig_d,

    // Execute outputs
    output bool_t reg_write_e,
    output logic mem_write_e, jump_e, branch_e,
    output result_src_t result_src_e,
    output alu_op_t alu_op_e,
    output alu_src_b_sig_t alu_src_b_sig_e

);

en_clr_arst_register #(
    .WIDTH(bool_t)
) en_clr_arst_register_instance (
    .d(reg_write_d),
    .q(reg_write_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(logic)
) mem_write_en_clr_arst_register_instance (
    .d(mem_write_d),
    .q(mem_write_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(logic)
) jump_en_clr_arst_register_instance (
    .d(jump_d),
    .q(jump_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(logic)
) branch_en_clr_arst_register_instance (
    .d(branch_d),
    .q(branch_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(result_src_t)
) result_src_en_clr_arst_register_instance (
    .d(result_src_d),
    .q(result_src_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(alu_op_t)
) alu_op_en_clr_arst_register_instance (
    .d(alu_op_d),
    .q(alu_op_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(alu_src_b_sig_t)
) alu_src_b_sig_en_clr_arst_register_instance (
    .d(alu_src_b_sig_d),
    .q(alu_src_b_sig_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);


endmodule
