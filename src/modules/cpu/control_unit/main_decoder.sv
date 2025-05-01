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
    output immsrc_t immsrc,
    output pc_target_src_t pc_target_src
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
        pc_target_src = PC_TARGET_PC;

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
                pc_target_src = PC_TARGET_PC; // We don't care
            end
            OPCODE_I_TYPE: begin
                reg_write = TRUE;
                result_src = RESULT_SRC_ALU;
                mem_write = FALSE;
                jump = FALSE;
                branch = FALSE;
                alu_control = ALU_CONTROL_ITYPE; // We delegate the operation control to the ALU decoder
                alu_src_b_sig = ALU_SRC_B_IMM; // We use the immediate
                case(funct3) // We look at funct3 to chose between I or UI type immediate decoding
                // UIMM for SLLI, SRLI, SRAI (SRLI and SRAI both have funct3 101)
                    3'b001: immsrc = IMMSRC_UI_TYPE;
                    3'b101: immsrc = IMMSRC_UI_TYPE;
                    default: immsrc = IMMSRC_I_TYPE;
                endcase
                pc_target_src = PC_TARGET_PC;
            end
            OPCODE_STORE: begin
                reg_write = FALSE; // we discard the result after the mem stage because we don't care
                result_src = RESULT_SRC_ALU; // We don't care
                mem_write = TRUE;
                jump = FALSE;
                branch = FALSE;
                alu_control = ALU_CONTROL_ADD; // we add rs1 with the immediate
                alu_src_b_sig = ALU_SRC_B_IMM;
                immsrc = IMMSRC_S_TYPE;
                pc_target_src = PC_TARGET_PC;
            end
            OPCODE_R: begin
                reg_write = TRUE;
                result_src = RESULT_SRC_ALU;
                mem_write = FALSE;
                jump = FALSE;
                branch = FALSE;
                alu_control = ALU_CONTROL_RTYPE;
                alu_src_b_sig = ALU_SRC_B_RS2;
                immsrc = IMMSRC_I_TYPE; // we don't care
                pc_target_src = PC_TARGET_PC;
            end
            OPCODE_BRANCH: begin
                // Only handle BEQ for now, we'll need alu_result[0] and a funct3 and a multiplexer (branch_flag_src) on the control logic to chose between zero flag and alu_result[0]
                // PCTarget is calculated by the execute stage by the PC adder so we're not using the MEM and WB stage
                reg_write = FALSE;
                result_src = RESULT_SRC_ALU; // We don't care
                mem_write = FALSE;
                jump = FALSE;
                branch = TRUE;
                alu_control = ALU_CONTROL_BTYPE;
                alu_src_b_sig = ALU_SRC_B_RS2; // We don't care, we're not using the result from the ALU, just the zero and probably alu_result[0] flags
                immsrc = IMMSRC_B_TYPE;
                pc_target_src = PC_TARGET_PC; // We use the PC + Imm as BTA 
            end
            OPCODE_JAL: begin
                reg_write = TRUE; // we write PC+4 to RD
                result_src = RESULT_SRC_PC_PLUS_4;
                mem_write = FALSE;
                jump = TRUE;
                branch = FALSE;
                alu_control = ALU_CONTROL_ADD; // We don't care, we're not using the result
                alu_src_b_sig = ALU_SRC_B_RS2; // We don't care
                immsrc = IMMSRC_J_TYPE; // J-Type immediate, label is 20 bit immediate
                pc_target_src = PC_TARGET_PC; // We use the PC + imm as JTA
            end
            OPCODE_JALR: begin
                reg_write = TRUE; // We write PC+4 to RD
                result_src = RESULT_SRC_PC_PLUS_4;
                mem_write = FALSE;
                jump = TRUE;
                branch = FALSE;
                alu_control = ALU_CONTROL_ADD; // We're not using the ALU
                alu_src_b_sig = ALU_SRC_B_RS2; // We don't care
                immsrc = IMMSRC_I_TYPE; // JALR uses I-Type immediate
                pc_target_src = PC_TARGET_RS1; // We use RS1 + imm as our JTA
            end
            default: ; // Use default values
        endcase

    end


endmodule
