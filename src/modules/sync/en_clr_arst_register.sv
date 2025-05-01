module en_clr_arst_register #(
    parameter type WIDTH = logic [31:0] // Default width of the register
) (
    input WIDTH d, // Data input
    output WIDTH q, // Data output
    input logic clk, rst, en, clr // Clock, reset, and enable signals
);

    // Asynchronous reset and synchronous enable
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= '0; // Reset the register to zero on reset
        end else if (clr) begin
            q <= '0; // Clear the register if clr is asserted
        end else if (en) begin
            q <= d; // Load the data into the register if enable is asserted
        end
    end

endmodule
