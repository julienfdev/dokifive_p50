module clock_divider #(
parameter WIDTH = 25
) (
    input   logic   clk,
    input   logic   rst,

    output  logic   div_clk
);

logic [WIDTH-1:0] counter;
assign div_clk = counter[WIDTH-1];

always_ff @(posedge clk or posedge rst) begin
	if(rst) counter <= 0;
	else counter <= counter + 1;
end

endmodule