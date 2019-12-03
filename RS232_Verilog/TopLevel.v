`timescale 1ns / 1ps

module TopLevel(
    input Rxd,
    input Send,
    input Reset,
    input SystemClock,
    input [7:0] DataIn,
    output Txd,
    output [3:0] An,
    output Ca,
    output Cb,
    output Cc,
    output Cd,
    output Ce,
    output Cf,
    output Cg
    );

wire iClock16x;
wire [6:0] iDigitOut3;
wire [6:0] iDigitOut2;
wire [6:0] iDigitOut1;
wire [6:0] iDigitOut0;
wire [7:0] iDataOut1;
wire [7:0] iDataOut2;
reg [8:0] iCount9;

always@(posedge SystemClock)
begin
    if (Reset == 1'b1 || iCount9 == 9'b101000101) begin
        iCount9 <= 9'b000000000;   
    end else begin
        iCount9 <= iCount9 + 1'b1;
    end
end

assign iClock16x = iCount9[8];

RS232 RS232_inst
(
    .Reset (Reset),
    .Clock16x (iClock16x),
    .Rxd (Rxd),
    .Send (Send),
    .DataIn (DataIn),
    .DataOut1 (iDataOut1),
    .DataOut2 (iDataOut2),
    .Txd (Txd)
);

D4to7Decoder D4to7Decoder_inst1
(
    .q (iDataOut1[3:0]),
    .seg (iDigitOut0)
);

D4to7Decoder D4to7Decoder_inst2
(
    .q (iDataOut1[7:4]),
    .seg (iDigitOut1)
);

D4to7Decoder D4to7Decoder_inst3
(
    .q (iDataOut2[3:0]),
    .seg (iDigitOut2)
);

D4to7Decoder D4to7Decoder_inst4
(
    .q (iDataOut2[7:4]),
    .seg (iDigitOut3)
);
Scan4Digit Scan4Digit_inst
(
    .digit0 (iDigitOut0),
    .digit1 (iDigitOut1),
    .digit2 (iDigitOut2),
    .digit3 (iDigitOut3),
    .clock (SystemClock),
    .an (An),
    .ca (Ca),
    .cb (Cb),
    .cc (Cc),
    .cd (Cd),
    .ce (Ce),
    .cf (Cf),
    .cg (Cg)
);

endmodule
