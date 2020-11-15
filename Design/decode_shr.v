`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 04/30/2020 05:55:29 PM
//
// Module Name: decode_shr
//
// Description: This module determines what is loaded into the trailing 2 bits
// of the shift register.  The Decoder passes any eighth bits and calculates any
// parity bits before passing it on, and fills any unused bits with end bits.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module decode_shr(
    input eight,
    input pen,
    input ohel,
    input [7:0] loaded_data,
    output reg [1:0] decoded
    );
    
    
    always @ *
        case ({eight, pen, ohel})
            3'b000: decoded = 2'b11;
            3'b001: decoded = 2'b11;
            3'b010: decoded = {1'b1, ^(loaded_data)};               //parity bit
            3'b011: decoded = {1'b1, ~^(loaded_data)};
            3'b100: decoded = {1'b1, loaded_data[7]};               //eighth bit
            3'b101: decoded = {1'b1, loaded_data[7]};
            3'b110: decoded = {^(loaded_data), loaded_data[7]};     //{parity, eighth} bit
            3'b111: decoded = {~^(loaded_data), loaded_data[7]};
            default: decoded = 2'b11;
        endcase
    
endmodule
