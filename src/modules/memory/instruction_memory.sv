import types::*;

// Mock and fully combinational data memory, point is to be able to validate the pipeline without the hazard state machine (1 cycle read delay)
module instruction_memory #(
    INITIAL = ""
) (
    input clk, rst, en,
    input logic [18:0] addr,
    output logic [31:0] rdata
);

    (* ramstyle = "M9K" *) logic [31:0] data[0:16383]; // 16K words, 64KB of instruction memory
    logic [18:0] reg_addr;

    always_ff @(posedge clk) begin
        if(!rst && en) begin
            reg_addr <= addr;
        end
    end

    assign rdata = data[reg_addr];

    initial begin
        if(INITIAL != "") begin
            $display("Initializing instruction memory from %s", INITIAL);
            $readmemh(INITIAL, data);
        end
    end

endmodule
