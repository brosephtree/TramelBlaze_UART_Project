`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/01/2020 04:14:47 PM
//
// Module Name: bit_counter
//
// Description: The Bit Counter module within TX counts the number of bit periods
// that has elapsed, and asserts done when 11 bit periods have elapsed.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module bit_counter(
    input clock,
    input reset,
    input btu,
    input doit,
    output done
    );
    
    reg [18:0] counter_reg;
    wire [18:0] counter;
    
    //mux
    assign counter =    ({doit, btu} == 2'b10) ? (counter_reg):
                        ({doit, btu} == 2'b11) ? (counter_reg + 1): 0;
    
    //counter register
    always @ (posedge clock)
        begin
        if (reset)
            counter_reg <= 0;
        else
            counter_reg <= counter;
        end
    
    assign done = (counter_reg == 4'd11) ? 1'b1 : 1'b0;
    
    
endmodule
