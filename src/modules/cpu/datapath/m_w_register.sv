module m_w_register(
    input   logic           clk, rst, en, clr,
    // input nets
    input   logic [31:0]    alu_result_m, r_data_m, pc_plus_4_m, imm_ext_m,
    input   logic [4:0]     wa3_m, // write address for the register file

    // output nets
    output  logic [31:0]    alu_result_w, r_data_w, pc_plus_4_w, imm_ext_w, // Multiplexer inputs for the writeback stage
    output  logic [4:0]     wa3_w // write address for the register file
);

    // MEMORY_WRITEBACK REGISTER
    en_clr_arst_register #(
        .WIDTH(32)
    ) alu_result_m_w (
        .d(alu_result_m),
        .q(alu_result_w),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) r_data_m_w (
        .d(r_data_m),
        .q(r_data_w),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) pc_plus_4_m_w (
        .d(pc_plus_4_m),
        .q(pc_plus_4_w),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(5)
    ) wa3_m_w (
        .d(wa3_m),
        .q(wa3_w),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) imm_ext_m_w (
        .d(imm_ext_m),
        .q(imm_ext_w),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );
    
endmodule
