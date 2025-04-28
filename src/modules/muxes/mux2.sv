module mux2 #(
    parameter WIDTH = 32
) (
    input   logic               s,
    input   logic   [WIDTH-1:0] a, b,
    output  logic   [WIDTH-1:0] out
);

assign out = s ? b : a;
endmodule
