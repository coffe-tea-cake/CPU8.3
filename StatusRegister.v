module StatusRegister (
    input  SRCin,
    input  SRZin,
    input  SRload,
    input  clk,
    input  Cset,
    input  Creset,
    input  Zset,
    input  Zreset,
    output SRCout,
    output SRZout
);

reg Cflag;
reg Zflag;

assign SRCout = Cflag;
assign SRZout = Zflag;

always @(negedge clk)
begin
    if (SRload)
    begin
        Cflag = SRCin;
        Zflag = SRZin;
    end

    if (Cset)
        Cflag = 1'b1;

    if (Creset)
        Cflag = 1'b0;

    if (Zset)
        Zflag = 1'b1;

    if (Zreset)
        Zflag = 1'b0;
end

endmodule