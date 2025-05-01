import types::*;

module main_decoder(
    input logic [6:0] opcode,
    input logic [2:0] funct3,

    output bool_t reg_write,
    output result_src_t result_src,
    output bool_t mem_write,
    output bool_t jump,
    output bool_t branch,
    output alu_control_t alu_control,
    output alu_src_b_sig_t alu_src_b_sig,
    output immsrc_t immsrc
);

    always_comb begin
        reg_write = FALSE;
        result_src = RESULT_SRC_ALU;
        mem_write = FALSE;
        jump = FALSE;
        branch = FALSE;
        alu_control = ALU_CONTROL_ADD;
        alu_src_b_sig = ALU_SRC_B_RS2;
        immsrc = IMMSRC_I_TYPE;

        case (opcode)
            OPCODE_LOAD: begin
                reg_write  = TRUE;
                result_src = RESULT_SRC_MEM;
                mem_write = FALSE;
                jump = FALSE;
                branch = FALSE;
                alu_control = ALU_CONTROL_ADD;
                alu_src_b_sig = ALU_SRC_B_IMM;
                immsrc = IMMSRC_I_TYPE;
            end
            default: ; // Use default values
        endcase

    end


endmodule
