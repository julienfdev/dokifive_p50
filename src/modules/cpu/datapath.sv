import types::*;

module datapath(
    input logic clk, rst,
    input logic [31:0] instr_f, // instruction fetched from memory
    output logic [31:0] pc_fnext, // it's fed before the clock edge to the memory controller because the memory is registered
    output logic [31:0] instr_d, // Instruction to be decoded, must be forwarded to the control unit as well as used by the decode stage

    // Stalls
    input logic stall_f, // stall fetch stage, should be propagated to the instruction memory controller
    input logic stall_d,
    // Flushes
    input logic flush_d,

    // Control signals
    // decode
    input immsrc_t immsrc_d,
    // execute
    input logic pc_src_e, // PC source for branch/jump, used to switch between PC + 4 and the target address
    // writeback
    input logic reg_write_w
    // Control signals
);
    // INTERNAL DATAPATH SIGNALS
    // FETCH
    logic [31:0] pc_f, pc_plus_4_f;
    // DECODE
    logic [31:0] rd1_d, rd2_d, imm_ext_d;
    logic [4:0] ra1_d, ra2_d; // source registers addresses
    logic [31:0] pc_d, pc_plus_4_d;
    // EXECUTE
    logic [31:0] pc_target_e;
    // MEMORY
    // WRITEBACK
    logic [4:0] wa3_w; // write address for the register file
    logic [31:0] result_w; // result to be written back to the register file

    // LOGIC
    // FETCH STAGE
    mux2 #(
    .WIDTH(32)
    ) mux2_pc_src (
        .s(pc_src_e),
        .a(pc_plus_4_f),
        .b(pc_target_e),
        .out(pc_fnext)
    );
    en_clr_arst_register #(
    .WIDTH(32)
    ) pc_register (
        .d(pc_fnext),
        .q(pc_f),
        .clk(clk),
        .rst(rst),
        .en(~stall_f), // enable the register only if not stalled
        .clr(1'b0) // no clear signal for the PC register
    );
    assign pc_plus_4_f = pc_f + 4; // PC + 4

    // FETCH_DECODE REGISTER
    f_d_register f_d_register_instance (
        .clk(clk),
        .rst(rst),
        .en(~stall_d), // enable the register only if not stalled
        .clr(flush_d),
        .instr_f(instr_f),
        .pc_f(pc_f),
        .pc_plus_4_f(pc_plus_4_f),
        .instr_d(instr_d),
        .pc_d(pc_d),
        .pc_plus_4_d(pc_plus_4_d)
    );

    // DECODE STAGE
    assign ra1_d = instr_d[19:15]; // rs1 is instr_d[19:15]
    assign ra2_d = instr_d[24:20]; // rs2 is instr_d[24:20]

    register_file rf (
        .clk(~clk), // register file is clocked on the falling edge of the clock for simultaneous read/write operations
        .we3(reg_write_w), // write enable signal, comes from the writeback stage
        .ra1(ra1_d),
        .ra2(ra2_d),
        .wa3(wa3_w), // wa3 is the write address, comes from the writeback stage
        .wd3(result_w), // wd3 is the write data, comes from the writeback stage
        .rd1(rd1_d),
        .rd2(rd2_d)
    );

    imm_extender imm_ext (
        .immsrc(immsrc_d),
        .instr_31_7(instr_d[31:7]),
        .imm_ext(imm_ext_d)
    );

    // DECODE_EXECUTE REGISTER

    // EXECUTE STAGE

    // EXECUTE_MEMORY REGISTER

    // MEMORY STAGE

    // MEMORY_WRITEBACK REGISTER

    // WRITE BACK STAGE

endmodule
