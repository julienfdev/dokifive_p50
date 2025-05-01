module f_iw_register(
    input logic clk, rst, en, clr,
    input logic [31:0] pc_f, pc_plus_4_f, // instruction fetched and PC + 4

    output logic [31:0] pc_iw, pc_plus_4_iw // instruction to be decoded and PC + 4
);

    en_clr_arst_register #(
    .WIDTH(logic [31:0])
    ) pc_f_d (
        .d(pc_f),
        .q(pc_iw),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
    .WIDTH(logic [31:0])
    ) pc_plus_4_f_d (
        .d(pc_plus_4_f),
        .q(pc_plus_4_iw),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

endmodule
