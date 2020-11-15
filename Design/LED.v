`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/25/2020 09:11:35 PM
//
// Module Name: LED
//
// Description: LED contains the register used by the TramelBlaze to facilitate the
// LED walkdown.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module LED(
    input clock,
    input reset,
    input [15:0] D,
    input LD,
    output reg [15:0] led
    );
    
    always @ (posedge clock)
        begin
        if (reset)
            led <= 16'h0001;
        else if (LD)
            led <= D;
        else
            led <= led;
        end
    
endmodule
