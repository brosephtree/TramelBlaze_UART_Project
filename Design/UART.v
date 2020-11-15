`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 04/27/2020 08:00:18 PM
//
// Module Name: UART
//
// Description: UART contains both the transfer engine TX and receive engine RX.
// UART feeds the decoded baud signal into TX and RX, converts the TX and RX ready
// signals into a single interrupt pulse, and selects the appropriate RX output to 
// send to the TramelBlaze based on the protocol of the TramelBlaze.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module UART(
    input clock,
    input reset,
    input [3:0] baud,
    input eight,
    input pen,
    input ohel,
    input read_data,
    input read_status,
    input tx_load,
    input [7:0] tx_load_data,
    input rx,
    output reg [7:0] uart_dout,
    output uart_inter,
    output tx
    );

    parameter CLK_FREQ = 100 * 10**6;           //clock at 100 MHz

    wire tx_rdy;
    
    wire [18:0] bit_period, bit_offset;
    wire [7:0] rx_data;
    wire rx_rdy, p_err, f_err, ovf;
    
    reg tx_rdy_delay, rx_rdy_delay;
    wire tx_rdy_ped, rx_rdy_ped;

    assign bit_offset = (bit_period >> 1);
    
    //interrupt signal
    assign tx_rdy_ped = tx_rdy & ~tx_rdy_delay;
    assign rx_rdy_ped = rx_rdy & ~rx_rdy_delay;
    assign uart_inter = (tx_rdy_ped | rx_rdy_ped);
    
//----------------------------------------------------
//--------------------BAUD DECODER--------------------
//----------------------------------------------------
    baud_decode #(
        .CLK_FREQ(CLK_FREQ)
        )
    v0(
        .baud(baud),
        .bit_period(bit_period)
        );

//----------------------------------------------------
//-------------------------TX-------------------------
//----------------------------------------------------
    TX v1(
        .clock(clock),
        .reset(reset),
        .bit_period(bit_period),
        .eight(eight),
        .pen(pen),
        .ohel(ohel),
        .load(tx_load),
        .load_data(tx_load_data),
        .tx_rdy(tx_rdy),
        .tx(tx)
        );

//----------------------------------------------------
//-------------------------RX-------------------------
//----------------------------------------------------
    RX v2(
        .clock(clock),
        .reset(reset),
        .bit_period(bit_period),
        .bit_offset(bit_offset),
        .eight(eight),
        .pen(pen),
        .ohel(ohel),
        .clear(read_data),
        .rx(rx),
        .rx_data(rx_data),
        .rx_rdy(rx_rdy),
        .p_err(p_err),
        .f_err(f_err),
        .ovf(ovf)
        );

//----------------------------------------------------
//--------------------UART DATAOUT--------------------
//----------------------------------------------------
    always @*
        case ({read_status, read_data})
            2'b01: uart_dout = rx_data;
            2'b10: uart_dout = {3'b000, ovf, f_err, p_err, tx_rdy, rx_rdy};
            default: uart_dout = 8'h00;
        endcase

//----------------------------------------------------
//--------------------UART INTRUPT--------------------
//----------------------------------------------------
    //TX PED
    always @ (posedge clock)
        begin
        if (reset)
            tx_rdy_delay <= 0;
        else
            tx_rdy_delay <= tx_rdy;
        end
    
    
    //RX PED
    always @ (posedge clock)
        begin
        if (reset)
            rx_rdy_delay <= 0;
        else
            rx_rdy_delay <= rx_rdy;
        end
    
    


endmodule
