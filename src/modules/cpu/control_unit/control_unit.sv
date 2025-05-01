import types::*;

module control_unit(
    input logic clk, rst, flush_e, stall_e, stall_m, stall_wb,  // Control signals
    input logic [31:0] instr_d, // Instruction to be decoded
    input logic zero_e, // Zero flag from the ALU, used for branch/jump instructions

    output immsrc_t immsrc_d, // Immediate source for the decode stage
    output pc_src_t pc_src_e, // PC source for branch/jump, used to switch between PC + 4 and the target address
    output alu_src_b_sig_t alu_src_b_e_sig, // ALU source, used to switch between the second operand and the immediate value
    output alu_op_t alu_op, // ALU operation, used to select the operation to be performed by the ALU
    output bool_t reg_write_w, // Register write signal, used to control the register file
    output result_src_t result_src_w, // Result source, used to select the source of the data to be written back to the register file
    output logic mem_write // Memory write signal, used to control the memory controller
);


// DECODE STAGE

// EXECUTE STAGE

// MEMORY STAGE

// WRITEBACK STAGE
    
endmodule
