module mux4 #(
    parameter WIDTH = 32
) (
    input   logic   [1:0]       s,
    input   logic   [WIDTH-1:0] a, b, c, d,
    output  logic   [WIDTH-1:0] out
);

    always_comb begin
        case (s)
            2'b00   : out = a;
            2'b01   : out = b;
            2'b10   : out = c;
            2'b11   : out = d;
            default : out = 'hDEADBEEF;
        endcase

    end


endmodule
