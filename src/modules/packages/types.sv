package types;
    typedef enum logic [2:0] {
        I_TYPE,
        S_TYPE,
        B_TYPE,
        J_TYPE,
        U_TYPE
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
        ALU_SRC_B_RS2 = 1'b0, // Second source is rs2 (rd2)
        ALU_SRC_B_IMM = 1'b1 // Second source is immediate (imm_ext)
    } alu_src_b_sig_t;
    typedef enum logic {
        FALSE = 1'b0,
        TRUE = 1'b1
    } bool_t;
endpackage
