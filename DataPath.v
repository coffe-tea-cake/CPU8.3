module DataPath (
    input         clk,
    inout  [15:0] Databus,

    output [15:0] Addressbus,
    output [15:0] Instruction,
    output        Cout,
    output        Zout,

    input ResetPC,
    input PCplusI,
    input PCplus1,
    input RplusI,
    input Rplus0,

    input Rs_on_AddressUnitRSide,
    input Rd_on_AddressUnitRSide,
    input EnablePC,

    input B15to0,
    input AandB,
    input AorB,
    input notB,
    input shlB,
    input shrB,
    input AaddB,
    input AsubB,
    input AmulB,
    input AcmpB,

    input RFLwrite,
    input RFHwrite,

    input WPreset,
    input WPadd,
    input IRload,
    input SRload,

    input Address_on_Databus,
    input ALU_on_Databus,

    input IR_on_LOpndBus,
    input IR_on_HOpndBus,
    input RFright_on_OpndBus,

    input Cset,
    input Creset,
    input Zset,
    input Zreset,

    input Shadow
);

wire [15:0] Right;
wire [15:0] Left;
wire [15:0] OpndBus;
wire [15:0] ALUout;
wire [15:0] IRout;
wire [15:0] Address;
wire [15:0] AddressUnitRSideBus;

wire SRCin;
wire SRZin;
wire SRZout;
wire SRCout;

wire [2:0] WPout;
wire [1:0] Laddr;
wire [1:0] Raddr;



AddressingUnit AU (
    .Rside    (AddressUnitRSideBus),
    .Iside    (IRout[7:0]),
    .clk      (clk),
    .ResetPC  (ResetPC),
    .PCplusI  (PCplusI),
    .PCplus1  (PCplus1),
    .RplusI   (RplusI),
    .Rplus0   (Rplus0),
    .PCenable (EnablePC),
    .Address  (Address)
);
ArithmeticUnit AL (
    .A      (Left),
    .B      (OpndBus),

    .B15to0 (B15to0),
    .AandB  (AandB),
    .AorB   (AorB),
    .notB   (notB),
    .shlB   (shlB),
    .shrB   (shrB),
    .AaddB  (AaddB),
    .AsubB  (AsubB),
    .AmulB  (AmulB),
    .AcmpB  (AcmpB),
//connect to databus

    .aluout (ALUout),
//connect to status register
    .cin    (SRCout),
    .zout   (SRZin),
    .cout   (SRCin)
);
RegisterFile RF (
    .in       (Databus),
    .clk      (clk),
    .RFLwrite (RFLwrite),
    .RFHwrite (RFHwrite),
    .Laddr    (Laddr),
    .Raddr    (Raddr),
    .Base     (WPout),
    .Lout     (Left),
    .Rout     (Right)
);

InstructionRegister IR (
    Databus,
    IRload,
    clk,
    IRout
);


StatusRegister SR (
    SRCin,
    SRZin,
    SRload,
    clk,
    Cset,
    Creset,
    Zset,
    Zreset,
    SRCout,
    SRZout
);


WindowPointer WP (
    IRout[2:0],
    clk,
    WPreset,
    WPadd,
    WPout
);


assign AddressUnitRSideBus =
        (Rs_on_AddressUnitRSide) ? Right :
        (Rd_on_AddressUnitRSide) ? Left  :
        16'bZZZZZZZZZZZZZZZZ;


assign Addressbus = Address;


assign Databus =
        (Address_on_Databus) ? Address :
        (ALU_on_Databus)     ? ALUout  :
        16'bZZZZZZZZZZZZZZZZ;


assign OpndBus[7:0] =
        IR_on_LOpndBus ? IRout[7:0] : 8'bZZZZZZZZ;


assign OpndBus[15:8] =
        IR_on_HOpndBus ? IRout[7:0] : 8'bZZZZZZZZ;


assign OpndBus =
        RFright_on_OpndBus ? Right :
        16'bZZZZZZZZZZZZZZZZ;


assign Zout = SRZout;
assign Cout = SRCout;

assign Instruction = IRout[15:0];


assign Laddr =
        (~Shadow) ? IRout[11:10] :
                    IRout[3:2];


assign Raddr =
        (~Shadow) ? IRout[9:8] :
                    IRout[1:0];

endmodule