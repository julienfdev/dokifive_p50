module enabled_register_async_reset #(
    parameter WIDTH = 32 // Default width of the register
) (
    input logic [WIDTH-1:0] d, // Data input
    output logic [WIDTH-1:0] q, // Data output
    input logic clk, rst, enable // Clock, reset, and enable signals
);

    // Asynchronous reset and synchronous enable
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= '0; // Reset the register to zero on reset
        end else if (enable) begin
            q <= d; // Load data into the register on clock edge if enabled
        end
    end
    
endmodule
