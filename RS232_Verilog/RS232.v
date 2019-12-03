`timescale 1ns / 1ps

module RS232(
    input Reset,
    input Clock16x,
    input Rxd,
    input Send,
    input [7:0] DataIn,
    output [7:0] DataOut1,
    output [7:0] DataOut2,
    output Txd
    );

RS232Rxd RS232Rxd_inst
(
    .Reset (Reset),
    .Clock16x (Clock16x),
    .Rxd (Rxd),
    .DataOut1 (DataOut1),
    .DataOut2 (DataOut2)
);

RS232Txd RS232Txd_inst
(
    .Reset (Reset),
    .Clock16x (Clock16x),
    .Send (Send),
    .DataIn (DataIn),
    .Txd  (Txd)
);

endmodule
