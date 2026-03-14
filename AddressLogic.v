module AddressLogic (
    input  [15:0] PCside,
    input  [15:0] Rside,
    input  [7:0]  Iside,

    input         ResetPC,
    input         PCplusI,
    input         PCplus1,
    input         RplusI,
    input         Rplus0,

    output reg [15:0] ALout
);


/* Address selection logic */

always @ (
       PCside
    or Rside
    or Iside
    or ResetPC
    or PCplusI
    or PCplus1
    or RplusI
    or Rplus0
)

case ({
        ResetPC,
        PCplusI,
        PCplus1,
        RplusI,
        Rplus0
     })

    5'b10000: ALout = 16'd0;

    5'b01000: ALout = PCside + Iside;

    5'b00100: ALout = PCside + 16'd1;

    5'b00010: ALout = Rside  + Iside;

    5'b00001: ALout = Rside;

    default:  ALout = PCside;

endcase


endmodule