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
        ALU_OP_XOR,
        ALU_OP_SLL,
        ALU_OP_SRL,
        ALU_OP_SRA
    } alu_op_t;
endpackage
