import types::*;

module main_decoder(
    input logic [6:0] opcode,
    input logic [2:0] funct3,

    output bool_t reg_write,
    output result_src_t result_src,
    output logic mem_write,
    output logic jump,
    output logic branch,
    output alu_control_t alu_control,
    output alu_src_b_sig_t alu_src_b_sig,
    output immsrc_t immsrc
);

endmodule
