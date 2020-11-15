`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/15/2020 11:58:39 PM
//
// Module Name: tramelblaze_uart_project_2_top_level
//
// Description: Top level of TramelBlaze SoPC with full UART project.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module tramelblaze_uart_project_2_top_level(clock,reset,eight,pen,ohel,rx,baud,tx,led);

    input   clock, 
            reset,
            eight,
            pen,
            ohel,             //odd high even low
            rx;
    input [3:0] baud;
    
    output tx;
    output [15:0] led;

    parameter CLK_FREQ = 100 * 10**6;           //clock at 100 MHz
    
    wire s_reset;

    reg sr_flop;
    wire [7:0] uart_dout;
    wire uart_inter;

    wire READ_STROBE, WRITE_STROBE, INTERRUPT_ACK;
    wire [15:0] OUT_PORT, PORT_ID;
    wire [15:0] READS3, READS2, READS1, READS0, WRITES3, WRITES2, WRITES1, WRITES0;
    
    //TSI I/O wires
    wire clock_TSI, reset_TSI, eight_TSI, pen_TSI, ohel_TSI, rx_TSI, tx_TSI;
    wire [3:0] baud_TSI;
    wire [15:0] led_TSI;

//----------------------------------------------------
//------------------------TSI-------------------------
//----------------------------------------------------
    //buffer for inputs
    TSI TSI(
        .clock_i(clock),
        .reset_i(reset),
        .baud_i(baud),
        .switches_i({eight, pen, ohel}),
        .rx_i(rx),
        .tx_i(tx_TSI),
        .led_i(led_TSI),
        .clock_o(clock_TSI),
        .reset_o(reset_TSI),
        .baud_o(baud_TSI),
        .switches_o({eight_TSI, pen_TSI, ohel_TSI}),
        .rx_o(rx_TSI),
        .tx_o(tx),
        .led_o(led)
        );

//----------------------------------------------------
//------------------------AISO------------------------
//----------------------------------------------------
    AISO AISO(
        .clock(clock_TSI),
        .a_reset(reset_TSI),
        .s_reset(s_reset)
        );

//----------------------------------------------------
//------------------------UART------------------------
//----------------------------------------------------
    UART UART(
        .clock(clock_TSI),
        .reset(s_reset),
        .baud(baud_TSI),
        .eight(eight_TSI),
        .pen(pen_TSI),
        .ohel(ohel_TSI),
        .read_data(READS0[0]),
        .read_status(READS0[1]),
        .tx_load(WRITES0[0]),
        .tx_load_data(OUT_PORT[7:0]),
        .rx(rx_TSI),
        .uart_dout(uart_dout),
        .uart_inter(uart_inter),
        .tx(tx_TSI)
        );

//----------------------------------------------------
//---------------------TRAMLBLAZE---------------------
//----------------------------------------------------
    //SR flop
    always @ (posedge clock_TSI)
        begin
        if (s_reset)
            sr_flop <= 1'b0;
        else if (uart_inter)
            sr_flop <= 1'b1;
        else if (INTERRUPT_ACK)
            sr_flop <= 1'b0;
        else
            sr_flop <= sr_flop;
        end
    
    tramelblaze_top TB(
        .CLK(clock_TSI), 
        .RESET(s_reset), 
        .IN_PORT({8'h00, uart_dout}),
        .INTERRUPT(sr_flop), 
        .OUT_PORT(OUT_PORT), 
        .PORT_ID(PORT_ID), 
        .READ_STROBE(READ_STROBE),
        .WRITE_STROBE(WRITE_STROBE), 
        .INTERRUPT_ACK(INTERRUPT_ACK)
        );

//----------------------------------------------------
//---------------------ADRS_DCODE---------------------
//----------------------------------------------------
    adrs_decode ADRS_DECODE(
        .PORT_ID(PORT_ID),
        .READ_STROBE(READ_STROBE), 
        .WRITE_STROBE(WRITE_STROBE),
        .READS3(READS3),
        .WRITES3(WRITES3),
        .READS2(READS2),
        .WRITES2(WRITES2),
        .READS1(READS1),
        .WRITES1(WRITES1),
        .READS0(READS0),
        .WRITES0(WRITES0)
        );

//----------------------------------------------------
//-------------------------LED------------------------
//----------------------------------------------------
    LED LED(
        .clock(clock_TSI),
        .reset(s_reset),
        .D(OUT_PORT),
        .LD(WRITES0[1]),
        .led(led_TSI)
        );
    

endmodule
