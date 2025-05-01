import types::*;

module alu(
    input logic     [31:0]  a, b,
    input alu_op_t          alu_op,
    output logic    [31:0]  result,
    output logic            zero
);

    always_comb begin
        case (alu_op)
            ALU_OP_ADD: result = a + b;
            ALU_OP_SUB: result = a - b;
            ALU_OP_AND: result = a & b;
            ALU_OP_OR : result = a | b;
            ALU_OP_SLT: result = ($signed(a) < $signed(b)) ? 1 : 0;
            ALU_OP_SLTU: result = (a < b) ? 1 : 0;
            ALU_OP_SGE: result = ($signed(a) >= $signed(b)) ? 1 : 0;
            ALU_OP_SGEU: result = (a >= b) ? 1 : 0;
            ALU_OP_XOR: result = a ^ b;
            ALU_OP_SLL: result = a << b[4:0];
            ALU_OP_SRL: result = a >> b[4:0];
            ALU_OP_SRA: result = $signed(a) >>> b[4:0];
            default   : result = 'hDEADBEEF; // Undefined operation
        endcase

        zero = (result == 32'b0) ? 1'b1 : 1'b0; // Set zero flag if result is zero
    end


endmodule
