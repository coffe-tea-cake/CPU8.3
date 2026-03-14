module AddressingUnit (
    input  [15:0] Rside,
    input  [7:0]  Iside,

    input         clk,
    input         ResetPC,
    input         PCplusI,
    input         PCplus1,
    input         RplusI,
    input         Rplus0,
    input         PCenable,

    output [15:0] Address
);

wire [15:0] PCout;


/* Program Counter */

ProgramCounter PC (
    .in (Address),
    .enable    (PCenable),
    .clk     (clk),
    .out(PCout)
);


/* Address Logic */

AddressLogic AL (
    .PCout   (PCout),
    .Rside   (Rside),
    .Iside   (Iside),
    .Address (Address),
    .ResetPC (ResetPC),
    .PCplusI (PCplusI),
    .PCplus1 (PCplus1),
    .RplusI  (RplusI),
    .Rplus0  (Rplus0)
);

endmodule
