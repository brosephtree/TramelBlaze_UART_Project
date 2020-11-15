`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/01/2020 03:54:22 PM
//
// Module Name: bit_time_counter
//
// Description: The Bit Time Counter module counts the number of clock cycles in a
// bit period before emitting a pulse that lasts 1 clock cycle.  The counter has
// an idle state and an active "doit" state.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module bit_time_counter(
    input clock,
    input reset,
    input doit,
    input [18:0] bit_period,
    output btu
    );
    
    reg [18:0] counter_reg;
    wire [18:0] counter;
    
    //mux
    assign counter = ({doit, btu} == 2'b10) ? (counter_reg + 1): 0;
    
    //counter register
    always @ (posedge clock)
        begin
        if (reset)
            counter_reg <= 0;
        else
            counter_reg <= counter;
        end
    
    //BTU
    assign btu = (bit_period == counter_reg) ? 1'b1 : 1'b0;
    
endmodule
