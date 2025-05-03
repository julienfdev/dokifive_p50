import types::*;

module control_d_e_register(
    input logic clk, rst, en, clr,

    // Debug input
    input logic [31:0] instr_d, // Debug input
    // Debug output
    output logic [31:0] instr_e, // Debug output

    // Decode inputs
    input bool_t reg_write_d,
    input bool_t mem_write_d, jump_d, branch_d,
    input result_src_t result_src_d,
    input alu_op_t alu_op_d,
    input alu_src_a_sig_t alu_src_a_sig_d,
    input alu_src_b_sig_t alu_src_b_sig_d,
    input pc_target_src_t pc_target_src_d,
    input branch_valid_src_t branch_valid_src_d,
    input logic byte_half_enable_d, // Byte/half enable signal, used for byte/half instructions
    input logic [2:0] funct3_d, // funct3 field from the instruction, used for byte/half instructions

    // Execute outputs
    output bool_t reg_write_e,
    output bool_t mem_write_e, jump_e, branch_e,
    output result_src_t result_src_e,
    output alu_op_t alu_op_e,
    output alu_src_a_sig_t alu_src_a_sig_e,
    output alu_src_b_sig_t alu_src_b_sig_e,
    output pc_target_src_t pc_target_src_e,    
    output branch_valid_src_t branch_valid_src_e,
    output logic byte_half_enable_e, // Byte/half enable signal, used for byte/half instructions
    output logic [2:0] funct3_e // funct3 field from the instruction, used for byte/half instructions

);

logic [0:0] reg_write_e_vec, mem_write_e_vec, jump_e_vec, branch_e_vec;
assign reg_write_e = bool_t'(reg_write_e_vec);
assign mem_write_e = bool_t'(mem_write_e_vec);
assign jump_e = bool_t'(jump_e_vec);
assign branch_e = bool_t'(branch_e_vec);

logic [$bits(result_src_t)-1:0] result_src_e_vec;
assign result_src_e = result_src_t'(result_src_e_vec);

logic [$bits(alu_op_t)-1:0] alu_op_e_vec;
assign alu_op_e = alu_op_t'(alu_op_e_vec);

logic [$bits(alu_src_a_sig_t)-1:0] alu_src_a_sig_e_vec;
assign alu_src_a_sig_e = alu_src_a_sig_t'(alu_src_a_sig_e_vec);

logic [$bits(alu_src_b_sig_t)-1:0] alu_src_b_sig_e_vec;
assign alu_src_b_sig_e = alu_src_b_sig_t'(alu_src_b_sig_e_vec);

logic [$bits(pc_target_src_t)-1:0] pc_target_src_e_vec;
assign pc_target_src_e = pc_target_src_t'(pc_target_src_e_vec);

logic [$bits(branch_valid_src_t)-1:0] branch_valid_src_e_vec;
assign branch_valid_src_e = branch_valid_src_t'(branch_valid_src_e_vec);

en_clr_arst_register #(
    .WIDTH(1)
) en_clr_arst_register_instance (
    .d(reg_write_d),
    .q(reg_write_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(1)
) mem_write_en_clr_arst_register_instance (
    .d(mem_write_d),
    .q(mem_write_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(1)
) jump_en_clr_arst_register_instance (
    .d(jump_d),
    .q(jump_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(1)
) branch_en_clr_arst_register_instance (
    .d(branch_d),
    .q(branch_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH($bits(result_src_t))
) result_src_en_clr_arst_register_instance (
    .d(result_src_d),
    .q(result_src_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH($bits(alu_op_t))
) alu_op_en_clr_arst_register_instance (
    .d(alu_op_d),
    .q(alu_op_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH($bits(alu_src_b_sig_t))
) alu_src_b_sig_en_clr_arst_register_instance (
    .d(alu_src_b_sig_d),
    .q(alu_src_b_sig_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH($bits(pc_target_src_t))
) pc_target_src_en_clr_arst_register_instance (
    .d(pc_target_src_d),
    .q(pc_target_src_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH($bits(alu_src_a_sig_t))
) alu_src_a_sig_en_clr_arst_register_instance (
    .d(alu_src_a_sig_d),
    .q(alu_src_a_sig_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH($bits(branch_valid_src_t))
) branch_valid_src_en_clr_arst_register_instance (
    .d(branch_valid_src_d),
    .q(branch_valid_src_e_vec),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

// Debug output
en_clr_arst_register #(
    .WIDTH(32)
) instr_e_en_clr_arst_register_instance (
    .d(instr_d),
    .q(instr_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(1)
) byte_half_enable_en_clr_arst_register_instance (
    .d(byte_half_enable_d),
    .q(byte_half_enable_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

en_clr_arst_register #(
    .WIDTH(3)
) funct3_en_clr_arst_register_instance (
    .d(funct3_d),
    .q(funct3_e),
    .clk(clk),
    .rst(rst),
    .en(en),
    .clr(clr)
);

endmodule
