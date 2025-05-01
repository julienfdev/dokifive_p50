import signals::*;
import types::*;

module imm_extender(
    input   immsrc_t        immsrc,
    input   imm_instr_t     instr_31_7,
    output  imm_ext_t       imm_ext
);

always_comb begin
    case (immsrc)
        I_TYPE  : imm_ext = {{20{instr_31_7[31]}}, instr_31_7[31:20]};
        UI_TYPE : imm_ext = {27'b0, instr_31_7[24:20]};
        S_TYPE  : imm_ext = {{20{instr_31_7[31]}}, instr_31_7[31:25], instr_31_7[11:7]};
        B_TYPE  : imm_ext = {{20{instr_31_7[31]}}, instr_31_7[7], instr_31_7[30:25], instr_31_7[11:8], 1'b0};
        J_TYPE  : imm_ext = {{12{instr_31_7[31]}}, instr_31_7[19:12], instr_31_7[20], instr_31_7[30:21], 1'b0};
        U_TYPE  : imm_ext = {instr_31_7[31:12], 12'b0};
        default : imm_ext = 'hDEADBEEF;
    endcase
        
end

endmodule
