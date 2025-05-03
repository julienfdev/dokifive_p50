// The byte store unit is responsible for shitfing and masking bytes before storing them
// It performs shifting based on the byte_half_sel_m signal
import types::*;

module byte_store_unit(
    input   logic [31:0]    data_in, // Data to be stored
    input byte_half_sel_t   byte_half_sel_m, // Byte/half select signal
    output  logic [31:0]    data_out // Data to be stored after shifting and masking
);

always_comb begin
    data_out = data_in; // Default to input data
    case(byte_half_sel_m)
        BYTE_HALF_BYTE_0:   data_out = {24'b0, data_in[7:0]}; // Store byte 0
        BYTE_HALF_BYTE_1:   data_out = {16'b0, data_in[7:0], 8'b0}; // Store byte 1
        BYTE_HALF_BYTE_2:   data_out = {8'b0, data_in[7:0], 16'b0}; // Store byte 2
        BYTE_HALF_BYTE_3:   data_out = {data_in[7:0], 24'b0}; // Store byte 3
        BYTE_HALF_HALF_0:   data_out = {16'b0, data_in[15:0]}; // Store halfword 0
        BYTE_HALF_HALF_1:   data_out = {data_in[15:0], 16'b0}; // Store halfword 
        default:            data_out = data_in; // No shift or mask, just pass through
    endcase
end


endmodule
