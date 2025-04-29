// Testbench for ALU
// filepath: tests/tb_alu.sv

`timescale 10ps/1ps
import types::*;

module tb_alu;
    // Inputs
    logic [31:0] a, b;
    alu_op_t alu_op;
    // Outputs
    logic [31:0] result;
    logic zero;

    // Instantiate the ALU
    alu dut(
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    // Test vector struct
    typedef struct {
        logic [31:0] a, b;
        alu_op_t alu_op;
        logic [31:0] expected_result;
        logic expected_zero;
        string desc;
    } alu_vec_t;

    // Test vectors
    alu_vec_t vectors[] = '{
    '{32'd10, 32'd5, ALU_OP_ADD, 32'd15, 1'b0, "ADD"},
    '{32'd10, 32'd5, ALU_OP_SUB, 32'd5, 1'b0, "SUB"},
    '{32'hF0F0F0F0, 32'h0F0F0F0F, ALU_OP_AND, 32'h00000000, 1'b1, "AND"},
    '{32'hF0F0F0F0, 32'h0F0F0F0F, ALU_OP_OR, 32'hFFFFFFFF, 1'b0, "OR"},
    '{-32'd5, 32'd10, ALU_OP_SLT, 32'd1, 1'b0, "SLT (signed)"},
    '{32'd10, 32'd5, ALU_OP_SLT, 32'd0, 1'b1, "SLT (signed, zero)"},
    '{32'd5, 32'd10, ALU_OP_SLTU, 32'd1, 1'b0, "SLTU (unsigned)"},
    '{32'd10, 32'd5, ALU_OP_SLTU, 32'd0, 1'b1, "SLTU (unsigned, zero)"},
    '{32'd5, 32'd10, ALU_OP_SGE, 32'd0, 1'b1, "SGE (signed)"},
    '{32'd10, 32'd5, ALU_OP_SGE, 32'd1, 1'b0, "SGE (signed)"},
    '{32'd5, 32'd10, ALU_OP_SGEU, 32'd0, 1'b1, "SGEU (unsigned)"},
    '{32'd10, 32'd5, ALU_OP_SGEU, 32'd1, 1'b0, "SGEU (unsigned)"},
    '{32'hAAAA5555, 32'h5555AAAA, ALU_OP_XOR, 32'hFFFFFFFF, 1'b0, "XOR"},
    '{32'h00000001, 32'd4, ALU_OP_SLL, 32'h00000010, 1'b0, "SLL"},
    '{32'h10, 32'd2, ALU_OP_SRL, 32'h4, 1'b0, "SRL"},
    '{32'h80000000, 32'd1, ALU_OP_SRA, 32'hC0000000, 1'b0, "SRA (arithmetic right shift)"},
    '{32'd0, 32'd0, ALU_OP_ADD, 32'd0, 1'b1, "ADD zero"},
    '{32'd0, 32'd0, ALU_OP_SUB, 32'd0, 1'b1, "SUB zero"}
    };

    initial begin
        $display("Starting ALU testbench...");
        foreach (vectors[i]) begin
            a = vectors[i].a;
            b = vectors[i].b;
            alu_op = vectors[i].alu_op;
            #1; // Wait for combinational logic to settle
            if (result !== vectors[i].expected_result || zero !== vectors[i].expected_zero) begin
                $error("Test %0d (%s) FAILED: a=%h b=%h alu_op=%0d | result=%h (expected %h) zero=%b (expected %b)",
                    i, vectors[i].desc, a, b, alu_op, result, vectors[i].expected_result, zero, vectors[i].expected_zero);
                $stop;
            end else begin
                $display("Test %0d (%s) PASSED", i, vectors[i].desc);
            end
        end
        $display("All ALU tests PASSED.");
        $stop;
    end
endmodule
