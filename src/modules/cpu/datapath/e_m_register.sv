module e_m_register(
    input logic clk, rst, en, clr,
    input logic [31:0] alu_result_e, w_data_e, pc_plus_4_e, imm_ext_e,
    input logic [4:0] wa3_e, // write address for the register file

    output logic [31:0] alu_result_m, w_data_m, pc_plus_4_m, imm_ext_m,
    output logic [4:0] wa3_m // write address for the register file
);

    // EXECUTE_MEMORY REGISTER
    en_clr_arst_register #(
        .WIDTH(logic [31:0])
    ) alu_result_e_m (
        .d(alu_result_e),
        .q(alu_result_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(logic [31:0])
    ) w_data_e_m (
        .d(w_data_e),
        .q(w_data_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(logic [31:0])
    ) pc_plus_4_e_m (
        .d(pc_plus_4_e),
        .q(pc_plus_4_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(logic [4:0])
    ) wa3_e_m (
        .d(wa3_e),
        .q(wa3_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );
    
    en_clr_arst_register #(
        .WIDTH(logic [31:0])
    ) imm_ext_e_m (
        .d(imm_ext_e),
        .q(imm_ext_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

endmodule
