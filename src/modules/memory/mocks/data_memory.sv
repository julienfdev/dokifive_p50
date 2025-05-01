import types::*;

// Mock and fully combinational data memory, point is to be able to validate the pipeline without the hazard state machine (1 cycle read delay)
module data_memory #(
    INITIAL = ""
) (
    input clk,
    input bool_t we,
    input logic [4:0] addr,
    input logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] data[0:31]; // 1k registers

    assign rdata = data[addr];

    always_ff @(posedge clk) begin
        if(we) begin
            data[addr] <= wdata;
        end
    end

    initial begin 
        if(INITIAL != "") begin
            $display("Initializing data memory from %s", INITIAL);
            $readmemh(INITIAL, data);
        end
    end

endmodule
