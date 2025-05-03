package io;
    // define two general purpose registers
    typedef struct packed {
        logic [31:0] GPR1;
        logic [31:0] GPR2;
    } GPREGS_T;
    localparam GPRMMSTART = 32'h30000000;
    localparam GPRMM1 = 32'h30000000;
    localparam GPRMM2 = 32'h30000001;
    localparam GPRMMEND = 32'h40000000;
endpackage