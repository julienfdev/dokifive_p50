import types::*;

module lw_fsm(
    input logic clk, rst, lwstall, readdatavalid,
    output logic readdatawait
);

lw_fsm_state_t nextstate, state;

// Next state logic
always_comb begin
    case(state)
        LW_NOT_LW: begin
            if(lwstall) begin
                nextstate = LW_WAITING_READVALID;
            end else begin
                nextstate = LW_NOT_LW;
            end
        end
        LW_WAITING_READVALID: begin
            if(readdatavalid) begin
                nextstate = LW_NOT_LW;
            end else begin
                nextstate = LW_WAITING_READVALID;
            end
        end
        default: nextstate = LW_NOT_LW;
    endcase
end

// FSM Register
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= LW_NOT_LW;
    end else begin 
        state <= nextstate;
    end
end

// Output logic
assign readdatawait = state == LW_WAITING_READVALID;


endmodule
