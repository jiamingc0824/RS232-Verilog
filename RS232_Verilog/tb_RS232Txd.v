`timescale 1ns / 1ps

module tb_RS232Txd;

	// Inputs
	reg tb_Reset;
	reg tb_Clock16x;
	reg tb_Send;
	reg [7:0] tb_DataIn;

	// Outputs
	wire tb_Txd;

	// Instantiate the Unit Under Test (UUT)
	RS232Txd uut (
		.Reset(tb_Reset), 
		.Clock16x(tb_Clock16x), 
		.Send(tb_Send), 
		.DataIn(tb_DataIn), 
		.Txd(tb_Txd)
	);

	always begin
		#1 tb_Clock16x = !tb_Clock16x;
	end

	initial begin
		// Initialize Inputs
		tb_Reset = 0;
		tb_Clock16x = 0;
		tb_Send = 0;
		tb_DataIn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		tb_Reset = 1;
        #2;
      	tb_Reset = 0;
      	tb_Send  = 0;
      	#1;
		tb_DataIn = 8'b10101010;
		#1;
      	tb_Send = 1;
      	#4;
      	tb_Send = 0;
      	#64;
      	tb_Send = 1;
      	#4;
      	tb_Send = 0;
      	#100;
	end
      
endmodule

