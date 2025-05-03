import types::*;

module control_e_m_register(
    input   logic           clk, rst, en, clr,
    // Debug input
    input   logic [31:0]    instr_e, // Debug input
    // Debug output
    output  logic [31:0]    instr_m, // Debug output

    // Execute inputs
    input   bool_t          reg_write_e,
    input   bool_t          mem_write_e,
    input   result_src_t    result_src_e,
    input   logic           byte_half_enable_e, // Byte/half enable signal, used for byte/half instructions
    input   logic [2:0]     funct3_e, // funct3 field from the instruction, used for byte/half instructions

    // Memory outputs
    output  bool_t          reg_write_m,
    output  bool_t          mem_write_m,
    output  result_src_t    result_src_m,
    output  logic           byte_half_enable_m, // Byte/half enable signal, used for byte/half instructions
    output  logic [2:0]     funct3_m // funct3 field from the instruction, used for byte/half instructions
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

    en_clr_arst_register #(
    .WIDTH(32)
    ) en_clr_arst_register_instance (
        .d(instr_e),
        .q(instr_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
    .WIDTH(1)
    ) byte_half_enable_e_m (
        .d(byte_half_enable_e),
        .q(byte_half_enable_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

    en_clr_arst_register #(
    .WIDTH(3)
    ) funct3_e_m (
        .d(funct3_e),
        .q(funct3_m),
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr(clr)
    );

endmodule
