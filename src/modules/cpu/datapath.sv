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
    input logic pc_src_e // PC source for branch/jump

    // Control signals
);
    // SIGNALS
    // FETCH
    logic [31:0] pc_f, pc_plus_4_f;
    // DECODE
    logic [31:0] pc_d, pc_plus_4_d;
    // EXECUTE
    logic [31:0] pc_target_e;
    // MEMORY
    // WRITEBACK

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

    // DECODE_EXECUTE REGISTER

    // EXECUTE STAGE

    // EXECUTE_MEMORY REGISTER

    // MEMORY STAGE

    // MEMORY_WRITEBACK REGISTER

    // WRITE BACK STAGE

endmodule
