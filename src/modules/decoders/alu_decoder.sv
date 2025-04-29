import types::*;

module alu_decoder(
    input alu_control_t alu_control,
    input logic         funct7_5,
    input logic [2:0]   funct3,
    output alu_op_t alu_op
);

    always_comb begin
        case (alu_control)
            ALU_CONTROL_ADD:    alu_op = ALU_OP_ADD; // ADD operation
            ALU_CONTROL_SUB:    alu_op = ALU_OP_SUB; // SUB operation
            ALU_CONTROL_ITYPE:  begin // We look at the function bits
                case(funct3)
                    3'b000: alu_op = ALU_OP_ADD; // ADDI operation
                    3'b001: alu_op = ALU_OP_SLL; // SLLI operation
                    3'b010: alu_op = ALU_OP_SLT; // SLTI operation
                    3'b011: alu_op = ALU_OP_SLTU; // SLTIU operation
                    3'b100: alu_op = ALU_OP_XOR; // XORI operation
                    3'b101: begin
                        case(funct7_5)
                            1'b0: alu_op = ALU_OP_SRL; // SRLI operation
                            1'b1: alu_op = ALU_OP_SRA; // SRAI operation
                            default: alu_op = ALU_OP_SRL; // Default to SRLI operation, should not happen
                        endcase
                    end
                    3'b110: alu_op = ALU_OP_OR; // ORI operation
                    3'b111: alu_op = ALU_OP_AND; // ANDI operation
                    default: alu_op = ALU_OP_ADD; // Default to ADD operation
                endcase
            end
            ALU_CONTROL_RTYPE: begin
                case(funct3) // We look at the function bits
                    3'b000: begin
                        case(funct7_5)
                            1'b0: alu_op = ALU_OP_ADD; // ADD operation
                            1'b1: alu_op = ALU_OP_SUB; // SUB operation
                            default: alu_op = ALU_OP_ADD; // Default to ADD operation, should not happen
                        endcase
                    end
                    3'b001: alu_op = ALU_OP_SLL; // SLL operation
                    3'b010: alu_op = ALU_OP_SLT; // SLT operation
                    3'b011: alu_op = ALU_OP_SLTU; // SLTU operation
                    3'b100: alu_op = ALU_OP_XOR; // XOR operation
                    3'b101: begin
                        case(funct7_5)
                            1'b0: alu_op = ALU_OP_SRL; // SRL operation
                            1'b1: alu_op = ALU_OP_SRA; // SRA operation
                            default: alu_op = ALU_OP_SRL; // Default to SRL operation, should not happen
                        endcase
                    end
                    3'b110: alu_op = ALU_OP_OR; // OR operation
                    3'b111: alu_op = ALU_OP_AND; // AND operation
                    default: alu_op = ALU_OP_ADD; // Default to ADD operation
                endcase
            end
            ALU_CONTROL_BTYPE: begin
                case(funct3)
                    3'b000: alu_op = ALU_OP_SUB; // BEQ, we need to sub to check for zero flag
                    3'b001: alu_op = ALU_OP_SUB; // BNE, we need to sub to check for not zero flag
                    3'b100: alu_op = ALU_OP_SLT; // BLT operation, we need to check if a < b
                    3'b101: alu_op = ALU_OP_SGE; // BGE operation, we need to check if a < a (we will invert the alusrca and alusrcb in the multiplexer)
                    3'b110: alu_op = ALU_OP_SLTU; // BLTU operation, we need to check if a < b unsigned
                    3'b111: alu_op = ALU_OP_SGEU; // BGEU operation, we need to check if b < a unsigned (we will invert the alusrca and alusrcb in the multiplexer)
                    default: alu_op = ALU_OP_ADD; // Default to ADD operation
                endcase
            end
            default :           alu_op = ALU_OP_ADD; // Default to ADD operation
        endcase

    end


endmodule
