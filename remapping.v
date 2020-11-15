`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/19/2020 07:26:13 PM
//
// Module Name: remapping
//
// Description: The Remapping module "right justifies" the shift register of the
// receive engine, allowing d_out[6:0] to always contain the data bits of a
// transmission while d_out[9:7] holds any auxiliary bits and the stop bit.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module remapping(
    input [9:0] d_in,
    input eight,
    input pen,
    output reg [9:0] d_out
    );

    always @ *
        case ({eight, pen})
            2'b00: d_out = {2'b00, d_in[9:2]};
            2'b01: d_out = {1'b0, d_in[9:1]};
            2'b10: d_out = {1'b0, d_in[9:1]};
            2'b11: d_out = d_in;
        endcase

endmodule
