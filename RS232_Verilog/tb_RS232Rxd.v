`timescale 1ns / 1ps

module tb_RS232Rxd;

	// Inputs
	reg tb_Reset;
	reg tb_Clock16x;
	reg tb_Rxd;

	// Outputs
	wire [7:0] tb_DataOut1;
	wire [7:0] tb_DataOut2;

	// Instantiate the Unit Under Test (UUT)
	RS232Rxd uut (
		.Reset(tb_Reset), 
		.Clock16x(tb_Clock16x), 
		.Rxd(tb_Rxd), 
		.DataOut1(tb_DataOut1), 
		.DataOut2(tb_DataOut2)
	);

	always begin
		#1 tb_Clock16x = !tb_Clock16x;
	end

	initial begin
		// Initialize Inputs
		tb_Reset = 0;
		tb_Clock16x = 0;
		tb_Rxd = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

