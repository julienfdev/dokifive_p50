module mux8 #(
    parameter WIDTH = 32
) (
    input   logic   [2:0]       s,
    input   logic   [WIDTH-1:0] a, b, c, d, e, f, g, h, 
    output  logic   [WIDTH-1:0] out
);

    always_comb begin
        case (s)
            3'b000  : out = a;
            3'b001  : out = b;
            3'b010  : out = c;
            3'b011  : out = d;
            3'b100  : out = e;
            3'b101  : out = f;
            3'b110  : out = g;
            3'b111  : out = h;  
            default : out = 'hDEADBEEF;
        endcase

    end


endmodule
