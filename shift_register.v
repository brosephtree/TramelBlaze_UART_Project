`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/01/2020 04:39:16 PM
//
// Module Name: shift_register
//
// Description: The Shift Register module in TX facilitates the serial transmission
// of the transmit engine.  Data is loaded into a register by TX, which then gets
// its LSB outputted as Tx of the UART.  When TX tells the Shift Register to shift,
// the register shifts right 1 bit and fills the new bit with 1, the idle bit.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_register(
    input clock,
    input reset,
    input [10:0] data_in,
    input load,
    input shift,
    output tx
    );
    
    reg [10:0] shift_reg;
    
    always @ (posedge clock)
        begin
        if (reset)
            shift_reg <= 11'b11111111111;
        else if (load)
            shift_reg <= data_in;
        else if (shift)
            shift_reg <= {1'b1, shift_reg[10:1]};
        else
            shift_reg <= shift_reg;
        end
        
    assign tx = shift_reg[0];
    
endmodule
