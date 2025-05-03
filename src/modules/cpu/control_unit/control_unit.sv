import types::*;

module control_unit(
    input logic clk, rst, flush_e, stall_e, stall_m, stall_wb,  // Control signals
    input logic [31:0] instr_d, // Instruction to be decoded
    input logic branch_valid_e, // Zero flag from the ALU, used for branch/jump instructions
    input logic [31:0] mem_addr_m, // Memory address for the memory stage, used to decode byte/half instructions

    output immsrc_t immsrc_d, // Immediate source for the decode stage
    output pc_src_t pc_src_e, // PC source for branch/jump, used to switch between PC + 4 and the target address
    output alu_src_a_sig_t alu_src_a_sig_e, // ALU source A, used to switch between rs1 and the PC (AUIPC)
    output alu_src_b_sig_t alu_src_b_sig_e, // ALU source, used to switch between the second operand and the immediate value
    output alu_op_t alu_op_e, // ALU operation, used to select the operation to be performed by the ALU
    output pc_target_src_t pc_target_src_e,
    output bool_t reg_write_m, // for hazard handling
    output bool_t reg_write_w, // Register write signal, used to control the register file
    output result_src_t result_src_w, // Result source, used to select the source of the data to be written back to the register file
    output bool_t mem_write_m, // Memory write signal, now bool_t
    output branch_valid_src_t branch_valid_src_e,
    output byte_half_sel_t byte_half_sel_m, // Byte/half select signal, used for byte/half instructions
    output word_ext_t word_ext_m, // Word extension signal, used for byte/half instructions

    // Hazard handling
    output result_src_t result_src_e
);

logic [6:0] opcode_d; // Opcode from the instruction
logic [2:0] funct3_d; // Function 3 from the instruction
logic funct7_5_d; // Function 7 from the instruction
alu_control_t alu_control; // ALU control signal, comes from the main decoder

// instruction assignemnts
assign opcode_d = instr_d[6:0]; // Opcode from the instruction
assign funct3_d = instr_d[14:12]; // Function 3 from the instruction
assign funct7_5_d = instr_d[30]; // Function 7, bit 5 from the instruction

// Signals
// Decode
bool_t reg_write_d;
result_src_t result_src_d;
bool_t mem_write_d;
bool_t jump_d;
bool_t branch_d;
alu_op_t alu_op_d;
alu_src_a_sig_t alu_src_a_sig_d;
alu_src_b_sig_t alu_src_b_sig_d;
pc_target_src_t pc_target_src_d;
branch_valid_src_t branch_valid_src_d;
logic byte_half_enable_d; // Byte/half enable signal, used for byte/half instructions

// Debug signals
logic [31:0] instr_e, instr_m, instr_w; // Debug output, instruction to be executed

// Execute
bool_t reg_write_e;
bool_t mem_write_e;
bool_t jump_e;
bool_t branch_e;
logic byte_half_enable_e; // Byte/half enable signal, used for byte/half instructions
logic [2:0] funct3_e; // funct3 field from the instruction, used for byte/half instructions

// Memory
result_src_t result_src_m;
logic byte_half_enable_m; // Byte/half enable signal, used for byte/half instructions
logic [2:0] funct3_m; // funct3 field from the instruction, used for byte/half instructions



// Memory
// Writeback

// DECODE STAGE
main_decoder main_decoder_instance (
    .opcode(opcode_d),
    .funct3(funct3_d),
    .reg_write(reg_write_d),
    .result_src(result_src_d),
    .mem_write(mem_write_d),
    .jump(jump_d),
    .branch(branch_d),
    .alu_control(alu_control),
    .alu_src_a_sig(alu_src_a_sig_d),
    .alu_src_b_sig(alu_src_b_sig_d),
    .immsrc(immsrc_d),
    .pc_target_src(pc_target_src_d),
    .branch_valid_src(branch_valid_src_d),
    .byte_half_enable_d(byte_half_enable_d)
);

// Alu decoder
alu_decoder alu_decoder_instance (
    .alu_control(alu_control),
    .funct7_5(funct7_5_d),
    .funct3(funct3_d),
    .alu_op(alu_op_d)
);

// DECODE_EXECUTE REGISTER
control_d_e_register control_d_e_register_instance (
    .clk(clk),
    .rst(rst),
    .en(~stall_e),
    .clr(flush_e),
    .instr_d(instr_d),
    .instr_e(instr_e),
    .reg_write_d(reg_write_d),
    .mem_write_d(mem_write_d),
    .jump_d(jump_d),
    .branch_d(branch_d),
    .result_src_d(result_src_d),
    .alu_op_d(alu_op_d),
    .alu_src_a_sig_d(alu_src_a_sig_d),
    .alu_src_b_sig_d(alu_src_b_sig_d),
    .pc_target_src_d(pc_target_src_d),
    .branch_valid_src_d(branch_valid_src_d),
    .byte_half_enable_d(byte_half_enable_d),
    .funct3_d(funct3_d), // funct3 field from the instruction, used for byte/half instructions
    .reg_write_e(reg_write_e),
    .mem_write_e(mem_write_e),
    .jump_e(jump_e),
    .branch_e(branch_e),
    .result_src_e(result_src_e),
    .alu_op_e(alu_op_e),
    .alu_src_a_sig_e(alu_src_a_sig_e),
    .alu_src_b_sig_e(alu_src_b_sig_e),
    .pc_target_src_e(pc_target_src_e),
    .branch_valid_src_e(branch_valid_src_e),
    .byte_half_enable_e(byte_half_enable_e),
    .funct3_e(funct3_e) // funct3 field from the instruction, used for byte/half instructions
);

// EXECUTE STAGE
// We need to assign PCSrcE
assign pc_src_e = (branch_e & branch_valid_e) | jump_e ? PC_SRC_PC_TARGET : PC_SRC_PC_PLUS_4; // PC source for branch/jump instructions

// EXECUTE_MEMORY REGISTER
control_e_m_register control_e_m_register_instance (
    .clk(clk),
    .rst(rst),
    .en(~stall_m),
    .clr(1'b0), // No clear signal for the memory stage
    .instr_e(instr_e),
    .instr_m(instr_m),
    .reg_write_e(reg_write_e),
    .mem_write_e(mem_write_e),
    .result_src_e(result_src_e),
    .byte_half_enable_e(byte_half_enable_e),
    .funct3_e(funct3_e), // funct3 field from the instruction, used for byte/half instructions
    .reg_write_m(reg_write_m),
    .mem_write_m(mem_write_m),
    .result_src_m(result_src_m),
    .byte_half_enable_m(byte_half_enable_m),
    .funct3_m(funct3_m) // funct3 field from the instruction, used for byte/half instructions
);

// MEMORY STAGE, we introduce the BYTE_HALF_DECODER
byte_half_decoder byte_half_decoder_instance (
    .byte_half_en_m(byte_half_enable_m),
    .funct3_m(funct3_m),
    .mem_addr_m(mem_addr_m[1:0]),
    .byte_half_sel(byte_half_sel_m),
    .word_ext(word_ext_m)
);


// MEMORY_WRITEBACK REGISTER
control_m_w_register control_m_w_register_instance (
    .clk(clk),
    .rst(rst),
    .en(~stall_wb),
    .clr(1'b0), // No clear signal for the writeback stage
    .instr_m(instr_m),
    .instr_w(instr_w),
    .reg_write_m(reg_write_m),
    .result_src_m(result_src_m),
    .reg_write_w(reg_write_w),
    .result_src_w(result_src_w)
);
    
endmodule
