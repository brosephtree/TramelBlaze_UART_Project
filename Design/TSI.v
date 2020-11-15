`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/25/2020 08:43:22 PM
//
// Module Name: TSI
//
// Description: The Technology Specific Instantiation module instantiates primitive
// I/O buffers specifically made for Xilinx's 7 Series FPGAs.  These buffers will
// allow all inputs and outputs to meet timing requirements.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module TSI(
    input clock_i,
    input reset_i,
    input [3:0] baud_i,
    input [2:0] switches_i,
    input rx_i,
    input tx_i,
    input [15:0] led_i,
    output clock_o,
    output reset_o,
    output [3:0] baud_o,
    output [2:0] switches_o,
    output rx_o,
    output tx_o,
    output [15:0] led_o
    );
    
    //inputs
    BUFG clock(
        .I(clock_i),
        .O(clock_o)
        );
    
    IBUF reset(
        .I(reset_i),
        .O(reset_o)
        );
    
    IBUF baud [3:0](
        .I(baud_i),
        .O(baud_o)
        );
    
    IBUF switches [2:0](
        .I(switches_i),
        .O(switches_o)
        );
    
    IBUF rx(
        .I(rx_i),
        .O(rx_o)
        );
    
    //outputs
    OBUF tx(
        .I(tx_i),
        .O(tx_o)
        );
    
    OBUF led [15:0](
        .I(led_i),
        .O(led_o)
        );
    
endmodule
