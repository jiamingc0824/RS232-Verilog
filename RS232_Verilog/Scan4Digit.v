`timescale 1ns / 1ps

module Scan4Digit(
    input [6:0] digit0,
    input [6:0] digit1,
    input [6:0] digit2,
    input [6:0] digit3,
    input clock,
    output [3:0] an,
    output ca,
    output cb,
    output cc,
    output cd,
    output ce,
    output cf,
    output cg
    );

reg [15:0] iCount16;
wire [6:0] iDigitOut;

always@(posedge clock)
begin
    iCount16 = iCount16 + 1'b1;
end

assign iDigitOut = (iCount16[15:14] == 2'b00)? digit0:
                   (iCount16[15:14] == 2'b01)? digit1:
                   (iCount16[15:14] == 2'b10)? digit2:
                   (iCount16[15:14] == 2'b11)? digit3:
                   digit0;

assign an = (iCount16[15:14] == 2'b00)? 4'b1110:
            (iCount16[15:14] == 2'b01)? 4'b1101:
            (iCount16[15:14] == 2'b10)? 4'b1011:
            (iCount16[15:14] == 2'b11)? 4'b0111:
            4'b1110; 

assign ca = iDigitOut[6];
assign cb = iDigitOut[5];
assign cc = iDigitOut[4];
assign cd = iDigitOut[3];
assign ce = iDigitOut[2];
assign cf = iDigitOut[1];
assign cg = iDigitOut[0];
endmodule
