`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/17/2020 06:07:23 PM
//
// Module Name: bit_counter_rx
//
// Description: The Bit Counter module within RX counts the number of bit periods
// that has elapsed, and asserts done when then expected number of bit periods has
// elapsed.  The expected number of bits is based on the number of data bits
// followed by the potential eighth and parity bits.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module bit_counter_rx(
    input clock,
    input reset,
    input btu,
    input doit,
    input eight,
    input pen,
    output done
    );
    
    reg [18:0] counter_reg;
    wire [18:0] counter;
    wire [3:0] size;
    
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
    
    //DONE MUX
    assign size =   ({eight, pen} == 2'b00) ? 4'd08:
                    ({eight, pen} == 2'b01) ? 4'd09:
                    ({eight, pen} == 2'b10) ? 4'd09:
                    ({eight, pen} == 2'b11) ? 4'd10:
                    4'd08;
    
    //DONE
    assign done = (counter_reg == size) ? 1'b1 : 1'b0;
    
    
endmodule
