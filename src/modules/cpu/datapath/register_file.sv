// 3 ported 32x32 register file
module register_file #(
    parameter string INITIAL = ""
)(
    input clk, we3,
    input logic [4:0] ra1, ra2, wa3, // read and write addresses
    input logic [31:0] wd3, // write data

    output logic [31:0] rd1, rd2 // read data
);

    logic [31:0] rf [0:31]; // register file

    assign rd1 = (ra1 == 5'b0) ? 32'b0 : rf[ra1]; // read data 1
    assign rd2 = (ra2 == 5'b0) ? 32'b0 : rf[ra2]; // read data 2

    always_ff @(posedge clk) begin
        if (we3) begin
            rf[wa3] <= wd3; // write data
        end
    end

    initial begin
        if (INITIAL != "") begin
            $display("Initializing register file from %s", INITIAL);
            $readmemh(INITIAL, rf);
        end
    end

endmodule
