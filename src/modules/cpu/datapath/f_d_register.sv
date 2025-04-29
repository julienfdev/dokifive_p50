module f_d_register(
    input logic clk, rst, en, clr,
    input logic [31:0] instr_f, pc_f, pc_plus_4_f, // instruction fetched and PC + 4

    output logic [31:0] instr_d, pc_d, pc_plus_4_d // instruction to be decoded and PC + 4
);

    en_clr_arst_register #(
    .WIDTH(32)
    ) instr_f_d (
        .d(instr_f),
        .q(instr_d),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
    .WIDTH(32)
    ) pc_f_d (
        .d(pc_f),
        .q(pc_d),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
    .WIDTH(32)
    ) pc_plus_4_f_d (
        .d(pc_plus_4_f),
        .q(pc_plus_4_d),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

endmodule
