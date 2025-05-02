package io;
    // define two general purpose registers
    typedef struct packed {
        logic [31:0] GPR1;
        logic [31:0] GPR2;
    } GPREGS_T;
    localparam GPRMMSTART = 32'h300;
    localparam GPRMM1 = 32'h300;
    localparam GPRMM2 = 32'h301;
    localparam GPRMMEND = 32'h400;
endpackage