import signals::*;
import types::*;

module imm_extender(
    input   immsrc_t        immsrc,
    input   imm_instr_t     instr,
    output  imm_ext_t       imm_ext
);

always_comb begin
    case (immsrc)
        I_TYPE  : imm_ext = {{20{instr[31]}}, instr[31:20]};
        S_TYPE  : imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        B_TYPE  : imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        J_TYPE  : imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        U_TYPE  : imm_ext = {instr[31:12], 12'b0};
        default : imm_ext = 'hDEADBEEF;
    endcase
        
end

endmodule
