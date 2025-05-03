import types::*;

module datapath(
    input   logic               clk, rst,
    input   logic [31:0]        instr_iw, // instruction fetched from memory
    input   logic [31:0]        mem_data_r_m, // data read from memory
    // OUTPUTS
    // Fetch stage
    output  logic [31:0]        pc_f, // it's fed before the clock edge to the memory controller because the memory is registered
    // Decode stage
    output  logic [31:0]        instr_d, // Instruction to be decoded, must be forwarded to the control unit as well as used by the decode stage
    // Execute stage
    output  logic               branch_valid_e, // zero flag from the ALU, used for branch/jump instructions
    // Memory stage
    output  logic [31:0]        mem_addr_m, // address for the data memory, used to read/write data from/to memory
    output  logic [31:0]        mem_data_w_m, // data to be written to memory, used to write data to memory

    // Hazard Unit signals
    // Stalls
    input   logic               stall_f, // stalls, the fetch stall should also be propagated to the instruction memory controller
    input   logic               stall_d, stall_e, stall_m, stall_wb, // stalls for decode, execute, memory and writeback stages respectively, 
    // Flushes
    input logic                 flush_d,
    input logic                 flush_e,
    // Forwarding signals
    input rd1_fwd_t             rd1_fwd_sel_e, // select signal for the first read data (rd1)
    input rd2_fwd_t             rd2_fwd_sel_e, // select signal for the second read data (rd2)
    output  logic [4:0]         rs1_addr_e, rs2_addr_e, // rs1 and rs2 addresses from the execute stage
    output  logic [4:0]         rd_addr_m, rd_addr_wb, // rd address from the memory and writeback stages
    // Stall signals
    output  logic [4:0]         rs1_addr_d, rs2_addr_d, rd_addr_e,

    // Control Unit signals
    // decode
    input immsrc_t              immsrc_d,
    // execute
    input pc_src_t              pc_src_e, // PC source for branch/jump, used to switch between PC + 4 and the target address
    input alu_src_a_sig_t       alu_src_a_sig_e, // ALU source A, used to switch between rs1 and the PC (AUIPC)
    input alu_src_b_sig_t       alu_src_b_sig_e, // ALU source, used to switch between the second operand and the immediate value
    input alu_op_t              alu_op, // ALU operation, used to select the operation to be performed by the ALU
    input pc_target_src_t       pc_target_src_sig_e,
    input branch_valid_src_t    branch_valid_src_e,
    // memory
    input byte_half_sel_t       byte_half_sel_m, // Byte/half select signal, used for byte/half instructions
    input word_ext_t            word_ext_m, // Word extension signal, used for byte/half instructions
    input result_src_t          result_src_m,
    // writeback
    input bool_t                reg_write_w,
    input result_src_t          result_src_w
    // Control signals
);
    // INTERNAL DATAPATH SIGNALS
    // FETCH
    logic [31:0]    pc_fnext, pc_plus_4_f;
    // INSTRUCTION WAIT
    // Instruction Wait stage
    logic [31:0]    pc_iw; // PC to be used in the instruction wait stage, must be forwarded to the decode stage
    logic [31:0]    pc_plus_4_iw; // PC + 4, used to calculate the target address for branch/jump instructions

    // DECODE
    logic [31:0]    rd1_d, rd2_d, imm_ext_d;
    logic [4:0]     ra1_d, ra2_d, wa3_d; // source registers addresses
    logic [31:0]    pc_d, pc_plus_4_d;
    // EXECUTE
    logic [31:0]    pc_e, pc_plus_4_e, imm_ext_e, pc_target_e, pc_target_src_e;
    logic [31:0]    rd1_e, rd2_e; // operands for ALU, before forwarding
    logic [31:0]    rd1_fwd_e, rd2_fwd_e; // operands for ALU, after forwarding
    logic [4:0]     ra1_e, ra2_e, wa3_e; // source registers addresses
    logic [31:0]    alu_src_a_e, alu_src_b_e, alu_result_e, w_data_e; // Alu result and write data from rd2_e (or forwared values)
    logic           zero_e;

    // MEMORY
    logic [31:0]    forwarded_value_m; // alu_result_m if result_src is not IMM
    logic [31:0]    alu_result_m, pc_plus_4_m, imm_ext_m; // ALU result and write data from rd2_e (or forwared values)
    logic [4:0]     wa3_m; // write address for the register file
    logic [31:0]    mem_data_w_m_raw;
    logic [31:0]    mem_data_r_m_ext; // data to be written to memory, after shifting logic

    // WRITEBACK
    logic [4:0]     wa3_w; // write address for the register file
    logic [31:0]    result_w; // result to be written back to the register file
    logic [31:0]    r_data_w, pc_plus_4_w, alu_result_w, imm_ext_w; // Multiplexer inputs for the writeback stage

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
    .WIDTH(32),
    .OFFSET('h0000) // Should be 0x8000 when we introduce the bootloader
    ) pc_register (
        .d(pc_fnext),
        .q(pc_f),
        .clk(clk),
        .rst(rst),
        .en(~stall_f), // enable the register only if not stalled
        .clr(1'b0) // no clear signal for the PC register
    );
    assign pc_plus_4_f = pc_f + 4; // PC + 4

    // FETCH_INSTRUCTION_WAIT REGISTER
    f_iw_register f_iw_register_instance ( // waste one clock cycle for the instruction to arrive from memory
        .clk(clk),
        .rst(rst),
        .en(~stall_f),
        .clr(flush_d),
        .pc_f(pc_f),  // Will be flushed with the iw_d register, that's what we want because of the RAM latency
        .pc_plus_4_f(pc_plus_4_f),
        .pc_iw(pc_iw),
        .pc_plus_4_iw(pc_plus_4_iw)
    );

    // INSTRUCTION_WAIT_DECODE REGISTER
    iw_d_register f_d_register_instance (
        .clk(clk),
        .rst(rst),
        .en(~stall_d), // enable the register only if not stalled
        .clr(flush_d),
        .instr_iw(instr_iw),
        .pc_iw(pc_iw),
        .pc_plus_4_iw(pc_plus_4_iw),
        .instr_d(instr_d),
        .pc_d(pc_d),
        .pc_plus_4_d(pc_plus_4_d)
    );

    // DECODE STAGE
    assign ra1_d = instr_d[19:15]; // rs1 is instr_d[19:15]
    assign ra2_d = instr_d[24:20]; // rs2 is instr_d[24:20]
    assign wa3_d = instr_d[11:7]; // rd is instr_d[11:7]

    // Hazard unit assignment
    assign rs1_addr_d = ra1_d;
    assign rs2_addr_d = ra2_d;

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
    // Hazard Unit assignments
    assign rs1_addr_e   = ra1_e;
    assign rs2_addr_e   = ra2_e;
    assign rd_addr_e    = wa3_e;

    // PC Target calculation
    logic [31:0]    pc_target_sum_e;
    assign          pc_target_sum_e  = (pc_target_src_e + imm_ext_e); // PC target for branch/jump instructions
    assign          pc_target_e      = {pc_target_sum_e[31:1], 1'b0 }; // PC target for branch/jump instructions, zeroing the LSB
    // 
    mux2 #(
    .WIDTH(32)
    ) pc_target_adder_src (
        .s(pc_target_src_sig_e),
        .a(pc_e),
        .b(rd1_e),
        .out(pc_target_src_e)
    );

    assign w_data_e = rd2_fwd_e; // write data for the data memory, after forwarding

    // forwarding logic
    mux4 #(
    .WIDTH(32)
    ) rd1_fwd_mux (
        .s(rd1_fwd_sel_e),
        .a(rd1_e),
        .b(result_w),
        .c(forwarded_value_m),
        .d(32'hDEADBEEF),
        .out(rd1_fwd_e)
    );
    mux4 #(
    .WIDTH(32)
    ) rd2_fwd_mux (
        .s(rd2_fwd_sel_e),
        .a(rd2_e),
        .b(result_w),
        .c(forwarded_value_m),
        .d(32'hDEADBEEF),
        .out(rd2_fwd_e)
    );
    // forwarding logic

    mux2 #(
    .WIDTH(32)
    ) alu_src_a_mux (
        .s(alu_src_a_sig_e),
        .a(rd1_fwd_e),
        .b(pc_e),
        .out(alu_src_a_e)
    );

    mux2 #(
    .WIDTH(32)
    ) alu_src_b_mux (
        .s(alu_src_b_sig_e),
        .a(rd2_fwd_e),
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

    mux4 #(
        .WIDTH(1)
    ) branch_valid_mux (
        .s(branch_valid_src_e),
        .a(zero_e),
        .b(~zero_e),
        .c(alu_result_e[0]),
        .d(1'b0),
        .out(branch_valid_e)
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
        .imm_ext_e(imm_ext_e),
        .wa3_e(wa3_e),
        .alu_result_m(alu_result_m),
        .w_data_m(mem_data_w_m_raw), // Before shifting logic
        .pc_plus_4_m(pc_plus_4_m),
        .imm_ext_m(imm_ext_m),
        .wa3_m(wa3_m)
    );

    // MEMORY STAGE
    // Hazard unit assignments
    assign rd_addr_m = wa3_m;
    // Memory stage is simpler, as the bulk of the work is done outside of the datapath, eveything is already declared
    assign mem_addr_m           = alu_result_m; // write address for the data memory
    assign forwarded_value_m    = (result_src_m == RESULT_SRC_IMM) ? imm_ext_m : alu_result_m; // ALU result if result_src is not IMM

    // Byte store unit
    byte_store_unit byte_store_unit_instance (
        .data_in(mem_data_w_m_raw),
        .byte_half_sel_m(byte_half_sel_m),
        .data_out(mem_data_w_m)
    );

    byte_load_unit byte_load_unit_instance (
        .data_in(mem_data_r_m),
        .byte_half_sel_m(byte_half_sel_m),
        .word_ext_m(word_ext_m),
        .data_out(mem_data_r_m_ext)
    );

    // MEMORY_WRITEBACK REGISTER
    m_w_register m_w_register_instance (
        .clk(clk),
        .rst(rst),
        .en(~stall_wb), // enable the register only if not stalled
        .clr(1'b0), // no clear signal for the memory writeback register
        .alu_result_m(alu_result_m),
        .r_data_m(mem_data_r_m_ext),
        .pc_plus_4_m(pc_plus_4_m),
        .imm_ext_m(imm_ext_m),
        .wa3_m(wa3_m),
        .alu_result_w(alu_result_w), // ALU result to be written back to the register file
        .r_data_w(r_data_w), // data read from memory
        .pc_plus_4_w(pc_plus_4_w),
        .imm_ext_w(imm_ext_w), // immediate value to be written back to the register file
        .wa3_w(wa3_w) // write address for the register file,
    );

    // WRITE BACK STAGE
    // Hazard unit assignments
    assign rd_addr_wb = wa3_w;

    mux4 #(
    .WIDTH(32)
    ) wb_mux (
        .s(result_src_w),
        .a(alu_result_w),
        .b(r_data_w),
        .c(pc_plus_4_w),
        .d(imm_ext_w),
        .out(result_w)
    );

endmodule
