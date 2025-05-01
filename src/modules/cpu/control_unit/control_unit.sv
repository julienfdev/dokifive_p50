import types::*;

module control_unit(
    input logic clk, rst, flush_e, stall_e, stall_m, stall_wb,  // Control signals
    input logic [31:0] instr_d, // Instruction to be decoded
    input logic zero_e, // Zero flag from the ALU, used for branch/jump instructions

    output immsrc_t immsrc_d, // Immediate source for the decode stage
    output pc_src_t pc_src_e, // PC source for branch/jump, used to switch between PC + 4 and the target address
    output alu_src_b_sig_t alu_src_b_e_sig, // ALU source, used to switch between the second operand and the immediate value
    output alu_op_t alu_op_e, // ALU operation, used to select the operation to be performed by the ALU
    output bool_t reg_write_w, // Register write signal, used to control the register file
    output result_src_t result_src_w, // Result source, used to select the source of the data to be written back to the register file
    output logic mem_write_m // Memory write signal, used to control the memory controller
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
logic reg_write_d;
result_src_t result_src_d;
logic mem_write_d;
logic jump_d;
logic branch_d;
alu_op_t alu_op_d;
alu_src_b_sig_t alu_src_b_sig_d;

// Execute
// Memory
// Writeback

// DECODE STAGE
main_decoder main_decoder_instance (
    .opcode(opcode_d),
    .reg_write(reg_write_d),
    .result_src(result_src_d),
    .mem_write(mem_write_d),
    .jump(jump_d),
    .branch(branch_d),
    .alu_control(alu_control),
    .alu_src_b_sig(alu_src_b_sig_d),
    .immsrc(immsrc_d)
);

// Alu decoder
alu_decoder alu_decoder_instance (
    .alu_control(alu_control),
    .funct7_5(funct7_5_d),
    .funct3(funct3_d),
    .alu_op(alu_op_d)
);

// DECODE_EXECUTE REGISTER

// EXECUTE STAGE

// MEMORY STAGE

// WRITEBACK STAGE
    
endmodule
