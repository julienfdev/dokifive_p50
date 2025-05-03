import types::*;
module byte_load_unit(
    input logic [31:0] data_in, // Data to be loaded
    input byte_half_sel_t byte_half_sel_m, // Byte/half select signal
    input word_ext_t word_ext_m, // Word extension signal

    output logic [31:0] data_out // Data to be loaded after shifting and masking
);

    always_comb begin
        data_out = data_in; // Default to input data
        case(word_ext_m)
            WORD_EXT_ZERO: begin
                case(byte_half_sel_m)
                    BYTE_HALF_BYTE_0: data_out = {24'b0, data_in[7:0]}; // Load byte 0
                    BYTE_HALF_BYTE_1: data_out = {24'b0, data_in[15:8]}; // Load byte 1
                    BYTE_HALF_BYTE_2: data_out = {24'b0, data_in[23:16]}; // Load byte 2
                    BYTE_HALF_BYTE_3: data_out = {24'b0, data_in[31:24]}; // Load byte 3
                    BYTE_HALF_HALF_0: data_out = {16'b0, data_in[15:0]}; // Load halfword 0
                    BYTE_HALF_HALF_1: data_out = {16'b0, data_in[31:16]}; // Load halfword 1
                    default: data_out = data_in; // No shift or mask, just pass through
                endcase
            end
            WORD_EXT_SIGN: begin
                case(byte_half_sel_m)
                    BYTE_HALF_BYTE_0: data_out = {{24{data_in[7]}}, data_in[7:0]}; // Load byte 0 with sign extension
                    BYTE_HALF_BYTE_1: data_out = {{24{data_in[15]}}, data_in[15:8]}; // Load byte 1 with sign extension
                    BYTE_HALF_BYTE_2: data_out = {{24{data_in[23]}}, data_in[23:16]}; // Load byte 2 with sign extension
                    BYTE_HALF_BYTE_3: data_out = {{24{data_in[31]}}, data_in[31:24]}; // Load byte 3 with sign extension
                    BYTE_HALF_HALF_0: data_out = {{16{data_in[15]}}, data_in[15:0]}; // Load halfword 0 with sign extension
                    BYTE_HALF_HALF_1: data_out = {{16{data_in[31]}}, data_in[31:16]}; // Load halfword 1 with sign extension
                    default: data_out = data_in; // No shift or mask, just pass through
                endcase
            end
            default: data_out = data_in; // No shift or mask, just pass through
        endcase
    end


endmodule
