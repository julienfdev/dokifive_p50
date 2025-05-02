import types::*;

module cpu #(
    parameter INITIAL_RF = ""
)(
    input logic clk, rst,

    // Memory controller
    input logic [31:0] instr_data, mem_data_r, // From the memory controller
    output logic [31:0] instr_addr, mem_addr, mem_data_w, // To the memory controller
    output bool_t mem_write, // Memory write signal, will be used by the control unit to control the memory controller
    output logic stall_f // we need the info for the memory
);

    // WIRE DECLARATIONS
    logic [31:0] instr_f, pc_f; // instruction fetched from memory and the next PC value


    // Control unit signals
    logic [31:0] instr_d; // Instruction to be decoded, must be forwarded to the control unit
    logic zero_e; // zero flag from the ALU, used for branch/jump instructions
    // decode
    immsrc_t immsrc_d; // immediate source for the decode stage
    // execute
    pc_src_t pc_src_e;
    pc_target_src_t pc_target_src_sig_e; // PC source for branch/jump, used to switch between PC + 4 and the target address
    alu_src_a_sig_t alu_src_a_sig_e; // ALU source A, used to switch between rs1 and the PC (AUIPC)
    alu_src_b_sig_t alu_src_b_sig_e; // ALU source, used to switch between the second operand and the immediate value
    alu_op_t alu_op; // ALU operation, used to select the operation to be performed by the ALU
    // writeback
    bool_t reg_write_w; // register write signal, used to control the register file
    result_src_t result_src_w; // result source, used to select the source of the data to be written back to the register file

    // Hazard unit signals
    // Stalls
    logic [4:0] rs1_addr_d, rs2_addr_d, rd_addr_e; // from datapath
    result_src_t result_src_e; // from control unit
    logic stall_d, stall_e, stall_m, stall_wb; // stalls for fetch, decode, execute, memory and writeback stages respectively
    // Flushes
    logic flush_d, flush_e; // flush signals for decode and execute stages
    // Forwards
    rd1_fwd_t rd1_fwd_sel_e;
    rd2_fwd_t rd2_fwd_sel_e;
    logic [4:0] rs1_addr_e, rs2_addr_e, rd_addr_m, rd_addr_wb;
    bool_t reg_write_m;

    // WIRE ASSIGNMENTS
    assign instr_addr = pc_f; // PC_fnext is the address of the instruction to be fetched (registered in the memory controller, synced with pc_f)
    assign instr_f = instr_data; // instruction fetched from memory

    datapath #(
    .INITIAL_RF(INITIAL_RF)
    ) datapath_instance (
        .clk(clk),
        .rst(rst),
        .instr_iw(instr_f),
        .mem_data_r_m(mem_data_r),
        .pc_f(pc_f),
        .instr_d(instr_d),
        .zero_e(zero_e),
        .mem_addr_m(mem_addr),
        .mem_data_w_m(mem_data_w),
        .stall_f(stall_f),
        .stall_d(stall_d),
        .stall_e(stall_e),
        .stall_m(stall_m),
        .stall_wb(stall_wb),
        .flush_d(flush_d),
        .flush_e(flush_e),
        .rd1_fwd_sel_e(rd1_fwd_sel_e),
        .rd2_fwd_sel_e(rd2_fwd_sel_e),
        .rs1_addr_e(rs1_addr_e),
        .rs2_addr_e(rs2_addr_e),
        .rd_addr_m(rd_addr_m),
        .rd_addr_wb(rd_addr_wb),
        .rs1_addr_d(rs1_addr_d),
        .rs2_addr_d(rs2_addr_d),
        .rd_addr_e(rd_addr_e),
        .immsrc_d(immsrc_d),
        .pc_src_e(pc_src_e),
        .alu_src_a_sig_e(alu_src_a_sig_e),
        .alu_src_b_sig_e(alu_src_b_sig_e),
        .alu_op(alu_op),
        .pc_target_src_sig_e(pc_target_src_sig_e),
        .reg_write_w(reg_write_w),
        .result_src_w(result_src_w)
    );


    // Control unit
    control_unit control_unit_instance (
        .clk(clk),
        .rst(rst),
        .flush_e(flush_e),
        .stall_e(stall_e),
        .stall_m(stall_m),
        .stall_wb(stall_wb),
        .instr_d(instr_d),
        .zero_e(zero_e),
        .immsrc_d(immsrc_d),
        .pc_src_e(pc_src_e),
        .alu_src_a_sig_e(alu_src_a_sig_e),
        .alu_src_b_sig_e(alu_src_b_sig_e),
        .alu_op_e(alu_op),
        .pc_target_src_e(pc_target_src_sig_e),
        .reg_write_m(reg_write_m),
        .reg_write_w(reg_write_w),
        .result_src_w(result_src_w),
        .mem_write_m(mem_write),
        .result_src_e(result_src_e)
    );

    // Hazard unit
    hazard_unit hazard_unit_instance (
        .clk(clk),
        .rst(rst),
        .rs1_addr_e(rs1_addr_e),
        .rs2_addr_e(rs2_addr_e),
        .rd_addr_m(rd_addr_m),
        .rd_addr_wb(rd_addr_wb),
        .reg_write_m(reg_write_m),
        .reg_write_wb(reg_write_w),
        .rs1_addr_d(rs1_addr_d),
        .rs2_addr_d(rs2_addr_d),
        .rd_addr_e(rd_addr_e),
        .result_src_e(result_src_e),
        .pc_src_e(pc_src_e),
        .rd1_fwd_sel_e(rd1_fwd_sel_e),
        .rd2_fwd_sel_e(rd2_fwd_sel_e),
        .stall_f(stall_f),
        .stall_d(stall_d),
        .stall_e(stall_e),
        .stall_m(stall_m),
        .stall_wb(stall_wb),
        .flush_d(flush_d),
        .flush_e(flush_e)
    );
endmodule
