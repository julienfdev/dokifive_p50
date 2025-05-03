module sevenseg(
  input   logic [3:0]     data,
  output  logic [6:0]     segments
);

  always_comb
  begin
    case (data)
      4'h0:
      segments = 7'h40;
      4'h1:
      segments = 7'h79;
      4'h2:
      segments = 7'h24;
      4'h3:
      segments = 7'h30;
      4'h4:
      segments = 7'h19;
      4'h5:
      segments = 7'h12;
      4'h6:
      segments = 7'h2;
      4'h7:
      segments = 7'h78;
      4'h8:
      segments = 7'h0;
      4'h9:
      segments = 7'h18;
      4'ha:
      segments = 7'h8;
      4'hb:
      segments = 7'h3;
      4'hc:
      segments = 7'h27;
      4'hd:
      segments = 7'h21;
      4'he:
      segments = 7'h6;
      4'hf:
      segments = 7'he;
      default:
      begin
        segments = 7'b1111111;
      end
    endcase
  end

endmodule
