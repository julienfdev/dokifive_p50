import io::*;

module gprmm_registers(
    // Signals
    input logic             clk, rst, wen,
    // Inputs
    input logic     [31:0]  rwaddr,
    input logic     [31:0]  wdata,
    // Outputs
    output logic    [31:0]  rdata,
    output GPREGS_T         GPREGS
);

    // Address space checking
    logic valid;
    assign valid = rwaddr >= GPRMMSTART && rwaddr < GPRMMEND;

    // Write port
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            GPREGS <= '0;
        end else if(wen && valid) begin
            case (rwaddr)
                GPRMM1 : GPREGS.GPR1 <= wdata;
                GPRMM2 : GPREGS.GPR2 <= wdata;
                default : ; // We do nothing
            endcase

        end
    end

    always_comb begin
        rdata = 32'hDEADBEEF;
        if(wen) begin
            rdata = wdata;
        end else begin
            case(rwaddr)
                GPRMM1 :    rdata = GPREGS.GPR1;
                GPRMM2 :    rdata = GPREGS.GPR2;
                default :   rdata = 32'hDEADBEEF;
            endcase
        end
    end



endmodule
