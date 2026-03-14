module ProgramCounter (
    input  [15:0] in,
    input         enable,
    input         clk,
    output reg [15:0] out
);

always @(negedge clk) begin
    if (enable)
        out = in;
end

endmodule