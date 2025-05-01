package types;
    typedef enum logic [2:0] {
        IMMSRC_I_TYPE,
        IMMSRC_UI_TYPE,
        IMMSRC_S_TYPE,
        IMMSRC_B_TYPE,
        IMMSRC_J_TYPE,
        IMMSRC_U_TYPE
    } immsrc_t;
    typedef enum logic [3:0] {
        ALU_OP_ADD,
        ALU_OP_SUB,
        ALU_OP_AND,
        ALU_OP_OR,
        ALU_OP_SLT,
        ALU_OP_SLTU,
        ALU_OP_SGE,
        ALU_OP_SGEU,
        ALU_OP_XOR,
        ALU_OP_SLL,
        ALU_OP_SRL,
        ALU_OP_SRA
    } alu_op_t;
    typedef enum logic [2:0] {
        ALU_CONTROL_ADD,
        ALU_CONTROL_SUB,
        ALU_CONTROL_ITYPE,
        ALU_CONTROL_RTYPE,
        ALU_CONTROL_BTYPE
    } alu_control_t;
    typedef enum logic [1:0] {
        RESULT_SRC_ALU = 2'b00,
        RESULT_SRC_MEM = 2'b01,
        RESULT_SRC_PC_PLUS_4 = 2'b10
    } result_src_t;
    typedef enum logic {
        PC_SRC_PC_PLUS_4 = 1'b0, // PC + 4
        PC_SRC_PC_TARGET = 1'b1 // Target address for branch/jump
    } pc_src_t;
    typedef enum logic {
        PC_TARGET_PC, // JAL
        PC_TARGET_RS1 // JALR
    } pc_target_src_t;
    typedef enum logic {
        ALU_SRC_B_RS2 = 1'b0, // Second source is rs2 (rd2)
        ALU_SRC_B_IMM = 1'b1 // Second source is immediate (imm_ext)
    } alu_src_b_sig_t;
    typedef enum logic {
        FALSE = 1'b0,
        TRUE = 1'b1
    } bool_t;
    typedef enum logic [6:0] {
        OPCODE_LOAD = 7'd3,
        OPCODE_I_TYPE = 7'd19,
        OPCODE_AUIPC = 7'd23,
        OPCODE_STORE = 7'd35,
        OPCODE_R = 7'd51,
        OPCODE_LUI = 7'd55,
        OPCODE_BRANCH = 7'd99,
        OPCODE_JALR = 7'd103,
        OPCODE_JAL = 7'd111
    } opcode_t; // Opcode for the instruction
endpackage
