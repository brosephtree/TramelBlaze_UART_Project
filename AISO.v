`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/26/2020 12:17:57 AM
//
// Module Name: AISO
//
// Description: The Asynchronous In Synchronous Out module converts an ansynchronous
// inputs into a synchronous signal.  This will prevent any metastability issues that
// may arise.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module AISO(
    input clock,
    input a_reset,
    output s_reset
    );
    
    reg q_meta,			// synchonization flop
		 q_ok;			// "ok" flop
	
	always @ (posedge clock, posedge a_reset)
		if (a_reset) begin
			q_meta <= 1'b0;
			q_ok 	 <= 1'b0;
		end
		else begin
			q_meta <= 1'b1;	 // Vcc
			q_ok 	 <= q_meta;
		end
			
	/*
		invert the sync reset so that when the flops get reset, reset signal
		to the system is 1.
	 */
	assign s_reset = ~q_ok;
    
endmodule
