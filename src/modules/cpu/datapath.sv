module datapath(
    input logic clk, rst,
    input logic [31:0] instr_f, // instruction fetched from memory
    output logic [31:0] pc_fnext, // it's fed before the clock edge to the memory controller because the memory is registered

    // Control signals
    // Fetch signals
    input logic stall_f, // stall fetch stage, should be propagated to the instruction memory controller

    // Execute signals
    input logic pc_src_e // PC source for branch/jump

    // Control signals
);
    // SIGNALS
    // FETCH
    logic [31:0] pc_f, pc_plus_4_f;
    // DECODE
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
    enabled_register_async_reset #(
        .WIDTH(32)
    ) pc_register (
        .d(pc_fnext),
        .q(pc_f),
        .clk(clk),
        .rst(rst),
        .enable(~stall_f) // enable the register only if not stalled
    );
    assign pc_plus_4_f = pc_f + 4; // PC + 4

    // FETCH_DECODE REGISTER

    // DECODE STAGE

    // DECODE_EXECUTE REGISTER

    // EXECUTE STAGE

    // EXECUTE_MEMORY REGISTER

    // MEMORY STAGE

    // MEMORY_WRITEBACK REGISTER

    // WRITE BACK STAGE

endmodule
