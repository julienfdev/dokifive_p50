module d_e_register(
    input logic clk, rst, en, clr,
    // input nets
    input logic [31:0] rd1_d, rd2_d, imm_ext_d, pc_d, pc_plus_4_d,
    input logic [4:0] ra1_d, ra2_d, wa3_d, // source registers addresses
    // output nets
    output logic [31:0] rd1_e, rd2_e, imm_ext_e, pc_e, pc_plus_4_e,
    output logic [4:0] ra1_e, ra2_e, wa3_e // source registers addresses
);

    // DECODE_EXECUTE REGISTER
    en_clr_arst_register #(
        .WIDTH(32)
    ) rd1_d_e (
        .d(rd1_d),
        .q(rd1_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) rd2_d_e (
        .d(rd2_d),
        .q(rd2_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) imm_ext_d_e (
        .d(imm_ext_d),
        .q(imm_ext_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) pc_d_e (
        .d(pc_d),
        .q(pc_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(32)
    ) pc_plus_4_d_e (
        .d(pc_plus_4_d),
        .q(pc_plus_4_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(5)
    ) ra1_d_e (
        .d(ra1_d),
        .q(ra1_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(5)
    ) ra2_d_e (
        .d(ra2_d),
        .q(ra2_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
        .WIDTH(5)
    ) wa3_d_e (
        .d(wa3_d),
        .q(wa3_e),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

endmodule
