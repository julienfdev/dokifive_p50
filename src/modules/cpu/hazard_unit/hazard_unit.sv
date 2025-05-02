import types::*;

module hazard_unit(
    input logic clk, rst, // will be used for the Memory FSM
    // Input signals
    input  logic [4:0] rs1_addr_e, rs2_addr_e, // rs1 and rs2 addresses from the execute stage
    input  logic [4:0] rd_addr_m, rd_addr_wb, // rd address from the memory and writeback stages
    input  bool_t       reg_write_m, reg_write_wb, // reg_write signals from the memory and writeback stages

    // Forwarding signals
    output rd1_fwd_t rd1_fwd_sel_e, // select signal for the first read data (rd1)
    output rd2_fwd_t rd2_fwd_sel_e // select signal for the second read data (rd2)
);

    // Forwarding logic
    always_comb begin
        rd1_fwd_sel_e = RD1_FWD_NONE; // Default value
        rd2_fwd_sel_e = RD2_FWD_NONE; // Default value

        // Handling RS1
        // P0 : Forward from memory stage
        if((rs1_addr_e == rd_addr_m && reg_write_m == TRUE) && rs1_addr_e != 0) begin
            rd1_fwd_sel_e = RD1_FWD_MEM;
            // P1 : Forward from WB 
        end else if((rs1_addr_e == rd_addr_wb && reg_write_wb == TRUE) && rs1_addr_e != 0) begin
            rd1_fwd_sel_e = RD1_FWD_WB;
        end

        // Handling RS2
        // P0 : Forward from memory stage
        if((rs2_addr_e == rd_addr_m && reg_write_m == TRUE) && rs2_addr_e != 0) begin
            rd2_fwd_sel_e = RD2_FWD_MEM;
            // P1 : Forward from WB 
        end else if((rs2_addr_e == rd_addr_wb && reg_write_wb == TRUE) && rs2_addr_e != 0) begin
            rd2_fwd_sel_e = RD2_FWD_WB;
        end
    end


endmodule
