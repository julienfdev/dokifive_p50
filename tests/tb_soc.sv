`timescale 10ps/1ps

module tb_soc;
    // Clock and reset
    logic clk = 0;
    logic rst = 1;
    logic [31:0] seven_segments;

    // SoC instance
    dokifive_soc #(
        .INITIAL_RF(""),
        .INITIAL_MOCK_INSTR("instr_init.mem"),
        .INITIAL_MOCK_DATA("")
    ) uut  (
        .clk(clk),
        .rst(rst),
        .seven_segment_display(seven_segments)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock

    // Reset logic
    initial begin
        rst = 1;
        #22;
        rst = 0;
    end

    // No stop condition, manual control in QuestaSim
endmodule