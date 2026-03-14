module RegisterFile (
    input  [15:0] in,
    input         clk,
    input         RFLwrite,
    input         RFHwrite,
    input  [1:0]  Laddr,
    input  [1:0]  Raddr,
    input  [2:0]  Base,
    output [15:0] Lout,
    output [15:0] Rout
);

reg  [15:0] MemoryFile [0:7];

wire [2:0] Laddress = Base + Laddr;
wire [2:0] Raddress = Base + Raddr;

assign Lout = MemoryFile[Laddress];
assign Rout = MemoryFile[Raddress];

reg [15:0] TempReg;

always @(negedge clk)
begin
    TempReg = MemoryFile[Laddress];

    if (RFLwrite)
        TempReg[7:0]  = in[7:0];

    if (RFHwrite)
        TempReg[15:8] = in[15:8];

    MemoryFile[Laddress] = TempReg;
end

endmodule