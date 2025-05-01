import types::*;

module cpu #(
    parameter string INITIAL_RF = ""
)(
    input logic clk, rst,

    // Memory controller
    input logic [31:0] instr_data, mem_data_r, // From the memory controller
    output logic [31:0] instr_addr, mem_addr, mem_data_w, // To the memory controller
    output bool_t mem_write // Memory write signal, will be used by the control unit to control the memory controller
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
    logic stall_f, stall_d, stall_e, stall_m, stall_wb; // stalls for fetch, decode, execute, memory and writeback stages respectively
    // Flushes
    logic flush_d, flush_e; // flush signals for decode and execute stages

    // TODO plug stalls and flushes to the hazard unit, for  now, assigning default values
    assign stall_f = 1'b0; // no stall for fetch stage
    assign stall_d = 1'b0; // no stall for decode stage
    assign stall_e = 1'b0; // no stall for execute stage
    assign stall_m = 1'b0; // no stall for memory stage
    assign stall_wb = 1'b0; // no stall for writeback stage
    assign flush_d = 1'b0; // no flush for decode stage
    assign flush_e = 1'b0; // no flush for execute stage

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
        .reg_write_w(reg_write_w),
        .result_src_w(result_src_w),
        .mem_write_m(mem_write)
    );
endmodule
