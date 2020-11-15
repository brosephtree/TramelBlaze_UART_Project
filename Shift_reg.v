`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/19/2020 07:13:26 PM
//
// Module Name: Shift_reg
//
// Description: The Shift Register module in RX facilitates the serial reception
// of the receive engine.  This module contains a register to load incoming bits
// from the external UART.  When RX tells the Shift Register to shift, the
// register shifts right 1 bit and fills the new bit with the serial input.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module Shift_reg(
    input clock,
    input reset,
    input shift,
    input rx,
    output reg [9:0] shift_reg
    );

    always @ (posedge clock)
        begin
        if (reset)
            shift_reg <= 0;
        else if (shift)
            shift_reg <= {rx, shift_reg[9:1]};
        else
            shift_reg <= shift_reg;
        end

endmodule
