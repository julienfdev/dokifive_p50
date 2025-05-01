import types::*;

module datapath(
    input logic clk, rst,
    // Fetch
    input logic [31:0] instr_f, // instruction fetched from memory
    // Memory
    input logic [31:0] r_data_m, // data read from memory

    // OUTPUTS
    // Fetch stage
    output logic [31:0] pc_fnext, // it's fed before the clock edge to the memory controller because the memory is registered
    // Decode stage
    output logic [31:0] instr_d, // Instruction to be decoded, must be forwarded to the control unit as well as used by the decode stage
    // Execute stage
    output logic zero_e, // zero flag from the ALU, used for branch/jump instructions
    // Memory stage
    output logic [31:0] w_addr_m, w_data_m,

    // Hazard Unit signals
    // Stalls
    input logic stall_f, // stalls, the fetch stall should also be propagated to the instruction memory controller
    input logic stall_d, stall_e, stall_m, stall_wb, // stalls for decode, execute, memory and writeback stages respectively, 
    // Flushes
    input logic flush_d,
    input logic flush_e,

    // Control Unit signals
    // decode
    input immsrc_t immsrc_d,
    // execute
    input logic pc_src_e, // PC source for branch/jump, used to switch between PC + 4 and the target address
    input logic alu_src_e, // ALU source, used to switch between the second operand and the immediate value
    input alu_op_t alu_op, // ALU operation, used to select the operation to be performed by the ALU
    // writeback
    input logic reg_write_w,
    input logic [1:0] result_src_w // TODO change to enum 
    // Control signals
);
    // INTERNAL DATAPATH SIGNALS
    // FETCH
    logic [31:0] pc_f, pc_plus_4_f;
    // DECODE
    logic [31:0] rd1_d, rd2_d, imm_ext_d;
    logic [4:0] ra1_d, ra2_d, wa3_d; // source registers addresses
    logic [31:0] pc_d, pc_plus_4_d;
    // EXECUTE
    logic [31:0] pc_e, pc_plus_4_e, imm_ext_e, pc_target_e;
    logic [31:0] rd1_e, rd2_e; // operands for ALU
    logic [4:0] ra1_e, ra2_e, wa3_e; // source registers addresses
    logic [31:0] alu_src_a_e, alu_src_b_e, alu_result_e, w_data_e; // Alu result and write data from rd2_e (or forwared values)

    // MEMORY
    logic [31:0] alu_result_m, pc_plus_4_m; // ALU result and write data from rd2_e (or forwared values)
    logic [4:0] wa3_m; // write address for the register file

    // WRITEBACK
    logic [4:0] wa3_w; // write address for the register file
    logic [31:0] result_w; // result to be written back to the register file
    logic [31:0] r_data_w, pc_plus_4_w, alu_result_w; // Multiplexer inputs for the writeback stage

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
    assign wa3_d = instr_d[11:7]; // rd is instr_d[11:7]

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
    d_e_register d_e_register_instance (
        .clk(clk),
        .rst(rst),
        .en(~stall_e), // enable the register only if not stalled
        .clr(flush_e),
        .rd1_d(rd1_d),
        .rd2_d(rd2_d),
        .imm_ext_d(imm_ext_d),
        .pc_d(pc_d),
        .pc_plus_4_d(pc_plus_4_d),
        .ra1_d(ra1_d),
        .ra2_d(ra2_d),
        .wa3_d(wa3_d),
        .rd1_e(rd1_e),
        .rd2_e(rd2_e),
        .imm_ext_e(imm_ext_e),
        .pc_e(pc_e),
        .pc_plus_4_e(pc_plus_4_e),
        .ra1_e(ra1_e),
        .ra2_e(ra2_e),
        .wa3_e(wa3_e)
    );

    // EXECUTE STAGE

    // PC Target calculation
    assign pc_target_e = pc_e + imm_ext_e; // PC target for branch/jump instructions

    // Temporary assignment for ALU source A and wd_e
    assign alu_src_a_e = rd1_e;
    assign w_data_e = rd2_e; // write data for the data memory

    mux2 #(
        .WIDTH(32)
    ) alu_src_b_mux (
        .s(alu_src_e),
        .a(rd2_e),
        .b(imm_ext_e),
        .out(alu_src_b_e)
    );

    // ALU
    alu alu_instance (
        .a(alu_src_a_e),
        .b(alu_src_b_e),
        .alu_op(alu_op),
        .result(alu_result_e),
        .zero(zero_e) // zero flag for branch/jump instructions
    );

    // EXECUTE_MEMORY REGISTER
    e_m_register e_m_register_instance (
        .clk(clk),
        .rst(rst),
        .en(~stall_m), // enable the register only if not stalled
        .clr(1'b0), // no clear signal for the execute memory register
        .alu_result_e(alu_result_e),
        .w_data_e(w_data_e),
        .pc_plus_4_e(pc_plus_4_e),
        .wa3_e(wa3_e),
        .alu_result_m(alu_result_m),
        .w_data_m(w_data_m),
        .pc_plus_4_m(pc_plus_4_m),
        .wa3_m(wa3_m)
    );

    // MEMORY STAGE
    // Memory stage is simpler, as the bulk of the work is done outside of the datapath, eveything is already declared
    assign w_addr_m = alu_result_m; // write address for the data memory

    // MEMORY_WRITEBACK REGISTER
    m_w_register m_w_register_instance (
        .clk(clk),
        .rst(rst),
        .en(~stall_wb), // enable the register only if not stalled
        .clr(1'b0), // no clear signal for the memory writeback register
        .alu_result_m(alu_result_m),
        .r_data_m(r_data_m),
        .pc_plus_4_m(pc_plus_4_m),
        .wa3_m(wa3_m),
        .alu_result_w(alu_result_w), // ALU result to be written back to the register file
        .r_data_w(r_data_w), // data read from memory
        .pc_plus_4_w(pc_plus_4_w),
        .wa3_w(wa3_w) // write address for the register file,
    );

    // WRITE BACK STAGE
    mux4 #(
        .WIDTH(32)
    ) wb_mux (
        .s(result_src_w),
        .a(alu_result_w),
        .b(r_data_w),
        .c(pc_plus_4_w),
        .d(32'hDEADBEEF),
        .out(result_w)
    );

endmodule
