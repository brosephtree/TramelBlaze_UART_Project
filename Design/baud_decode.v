`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 04/28/2020 05:21:43 PM
//
// Module Name: baud_decode
//
// Description: The Baud Decoder module converts the baud[3:0] signal into the
// amount of clock cycles required for a bit period of the selected baud rate.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module baud_decode(
    input [3:0] baud,
    output reg [18:0] bit_period
    );
    
    parameter CLK_FREQ = 100 * 10**6;           //clock at 100 MHz
    
    always @*
        case (baud)
            4'h0: bit_period <= CLK_FREQ / 300;
            4'h1: bit_period <= CLK_FREQ / 1200;
            4'h2: bit_period <= CLK_FREQ / 2400;
            4'h3: bit_period <= CLK_FREQ / 4800;
            4'h4: bit_period <= CLK_FREQ / 9600;
            4'h5: bit_period <= CLK_FREQ / 19200;
            4'h6: bit_period <= CLK_FREQ / 38400;
            4'h7: bit_period <= CLK_FREQ / 57600;
            4'h8: bit_period <= CLK_FREQ / 115200;
            4'h9: bit_period <= CLK_FREQ / 230400;
            4'ha: bit_period <= CLK_FREQ / 460800;
            4'hb: bit_period <= CLK_FREQ / 921600;
            default: bit_period <= CLK_FREQ / 300;
        endcase
    
endmodule
