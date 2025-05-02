import types::*;

module hazard_unit(
    input logic clk, rst, // will be used for the Memory FSM
    // Input signals
    // Forwarding
    input  logic [4:0] rs1_addr_e, rs2_addr_e, // rs1 and rs2 addresses from the execute stage
    input  logic [4:0] rd_addr_m, rd_addr_wb, // rd address from the memory and writeback stages
    input  bool_t       reg_write_m, reg_write_wb, // reg_write signals from the memory and writeback stages
    // Stalls
    input logic readdatavalid,
    input  logic [4:0] rs1_addr_d, rs2_addr_d, rd_addr_e,
    input result_src_t result_src_e,

    // Control Hazards
    input pc_src_t pc_src_e,

    // Forwarding signals
    output rd1_fwd_t rd1_fwd_sel_e, // select signal for the first read data (rd1)
    output rd2_fwd_t rd2_fwd_sel_e, // select signal for the second read data (rd2)

    // Stalls signals
    output logic stall_f, stall_d, stall_e, stall_m, stall_wb, flush_d, flush_e
);

    // Control Hazard
    logic control_hazard;
    assign control_hazard = pc_src_e == PC_SRC_PC_TARGET;

    // Declaration
    logic lw_stall, readdatawait; // a load word stall induces a stall of f (and IW) and d registers, and introduces a bubble in e
    assign stall_f = lw_stall | readdatawait;
    assign stall_d = lw_stall | readdatawait;
    assign stall_e = readdatawait;
    assign stall_m = readdatawait; 
    assign stall_wb = readdatawait; 
    assign flush_d = control_hazard;
    assign flush_e = lw_stall | control_hazard;
    // STALL M and WB will be asserted by the cycle latency FSM when switching to BRAM


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

    // Stall detection, will be asserted for 1 clock cycle as we're introducing a bubble in E
    // read latency will be handled by the state machine when we switch to BRAM
    assign lw_stall = (result_src_e == RESULT_SRC_MEM) && ((rs1_addr_d == rd_addr_e) ||  (rs2_addr_d == rd_addr_e));


    // Read data wait FSM
    lw_fsm lw_fsm_instance (
        .clk(clk),
        .rst(rst),
        .lwstall(lw_stall),
        .readdatavalid(readdatavalid),
        .readdatawait(readdatawait)
    );


endmodule
