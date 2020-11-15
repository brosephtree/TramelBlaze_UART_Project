`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 05:48:15 PM
// Design Name: 
// Module Name: PED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PED(
    input clock,
    input reset,
    input deb_sig,
    output ped_sig
    );
    
    reg sig_delay;
    
    always @ (posedge clock, posedge reset)
        begin
        if (reset) sig_delay <= 1'b0;
        else sig_delay <= deb_sig;
        end
      
    assign ped_sig = deb_sig & ~sig_delay;
    
endmodule
