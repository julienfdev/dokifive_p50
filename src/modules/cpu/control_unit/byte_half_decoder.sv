import types::*;

module byte_half_decoder(
    input logic byte_half_en_m,
    input logic [2:0] funct3_m,
    input logic [1:0] mem_addr_m,
    output byte_half_sel_t byte_half_sel,
    output word_ext_t word_ext
);

    // Byte select
    always_comb begin
        if(byte_half_en_m) begin
            casez (funct3_m)
                3'b?00 : begin // For LB, we look at individual byte addressing , we don't care about byte 2 because it's used for the sign extension
                    case (mem_addr_m[1:0])
                        2'b00 : byte_half_sel = BYTE_HALF_BYTE_0; // Mask for byte 0
                        2'b01 : byte_half_sel = BYTE_HALF_BYTE_1; // Mask for byte 1
                        2'b10 : byte_half_sel = BYTE_HALF_BYTE_2; // Mask for byte 2
                        2'b11 : byte_half_sel = BYTE_HALF_BYTE_3; // Mask for byte 3
                        default: byte_half_sel = BYTE_HALF_NONE; // No mask
                    endcase
                end
                3'b?01 : begin // For LH, we look at individual halfword addressing
                    case (mem_addr_m[1:0])
                        2'b00 : byte_half_sel = BYTE_HALF_HALF_0; // Mask for halfword 0
                        2'b10 : byte_half_sel = BYTE_HALF_HALF_1; // Mask for halfword 1
                        default: byte_half_sel = BYTE_HALF_NONE; // No mask, undefined behavior as per RISC-V spec
                    endcase
                end
                default: begin // LW, we don't care about the byte addressing, we just want the whole word
                    byte_half_sel = BYTE_HALF_NONE; // No mask
                end
            endcase
        end else begin
            byte_half_sel = BYTE_HALF_NONE; // No mask, undefined behavior as per RISC-V spec
        end
    end

    // Extension select
    assign word_ext = (funct3_m[2] && byte_half_en_m) ? WORD_EXT_ZERO : WORD_EXT_SIGN;

endmodule
