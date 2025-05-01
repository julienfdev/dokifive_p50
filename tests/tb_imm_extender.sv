`timescale 1ps / 1ps

import types::*;
module tb_imm_extender();
    // Inputs
    immsrc_t immsrc;
    logic [31:0] instr;
    // Outputs
    logic [31:0] imm_ext;

    // Instantiate the Unit Under Test (UUT)
    imm_extender uut (
        .immsrc(immsrc),
        .instr_31_7(instr[31:7]),
        .imm_ext(imm_ext)
    );

    // Test vectors
    initial begin
        $display("Starting testbench for imm_extender");

        // I-Type: addi s0, s0, 1337
        immsrc = IMMSRC_I_TYPE;
        instr = 32'h53980113; // 0x53980113
        #10;
        $display("I_TYPE (addi x2, x16, 1337): instr=0x%h, imm_ext=%d", instr, imm_ext);

        // S-Type: sw s0, 1337(t0)
        immsrc = IMMSRC_S_TYPE;
        instr = 32'h53988223; // 0x53988223
        #10;
        $display("S_TYPE (sb x25, 1316(x17): instr=0x%h, imm_ext=%d", instr, imm_ext);

        // B-Type: beq s0, t0, 1336
        immsrc = IMMSRC_B_TYPE;
        instr = 32'h53888463; // 0x53888463
        #10;
        $display("B_TYPE (beq x17, x24, 1320): instr=0x%h, imm_ext=%d", instr, imm_ext);

        // J-Type: jal s0, 1336
        immsrc = IMMSRC_J_TYPE;
        instr = 32'h5380106f; // 0x5380106f
        #10;
        $display("J_TYPE (jal x0, 5432): instr=0x%h, imm_ext=%d", instr, imm_ext);

        // U-Type: lui s0, 0x12345
        immsrc = IMMSRC_U_TYPE;
        instr = 32'h12345137; // 0x12345137
        #10;
        $display("U_TYPE (lui x2, 74565): instr=0x%h, imm_ext=%h", instr, imm_ext);

        $display("Testbench completed");
        $stop;
    end

endmodule