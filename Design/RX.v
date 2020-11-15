`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/17/2020 12:12:45 AM
//
// Module Name: RX
//
// Description: RX uses the signals of the RX State Machine to coordinate the
// time-keeping modules and the shift register in receiving asynchronous inputs
// from an external UART before sending the received code to the TramelBlaze.
// RX also calculates error flags to highlight faulty transmitions from the 
// external UART.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module RX(
    input clock,
    input reset,
    input [18:0] bit_period,
    input [18:0] bit_offset,
    input eight,
    input pen,
    input ohel,
    input clear,
    input rx,
    output [7:0] rx_data,
    output reg rx_rdy,
    output reg p_err,
    output reg f_err,
    output reg ovf
    );


    wire btu, done, start, doit;
    reg done_d1;
    
    wire [18:0] baud_final;
    
    wire [9:0] shift_reg, remapped;
    wire mux_0, mux_1, mux_2, mux_3;


//----------------------------------------------------
//------------------RX STATE MACHINE------------------
//----------------------------------------------------
    RxSM v0(
        .clock(clock),
        .reset(reset),
        .rx(rx),
        .done(done),
        .btu(btu),
        .start(start),
        .doit(doit)
        );

//----------------------------------------------------
//------------------BIT TIME COUNTER------------------
//----------------------------------------------------
    //baud mux
    assign baud_final = (start) ? bit_offset : bit_period;
    
    bit_time_counter v1(
        .clock(clock),
        .reset(reset),
        .doit(doit),
        .bit_period(baud_final),
        .btu(btu)
        );

//----------------------------------------------------
//---------------------BIT COUNTR---------------------
//----------------------------------------------------
    bit_counter_rx v2(
        .clock(clock),
        .reset(reset),
        .btu(btu),
        .doit((doit & ~start)),
        .eight(eight),
        .pen(pen),
        .done(done)
        );

    //DONE DELAY FLOP
    always @ (posedge clock)
        begin
        if (reset)
            done_d1 <= 0;
        else
            done_d1 <= done;
        end

//----------------------------------------------------
//-------------------SHIFT REGISTER-------------------
//----------------------------------------------------
    Shift_reg v3(
        .clock(clock),
        .reset(reset),
        .shift(btu & ~start),
        .rx(rx),
        .shift_reg(shift_reg)
        );

//----------------------------------------------------
//---------------------REMAPPING----------------------
//----------------------------------------------------
    remapping v4(
        .d_in(shift_reg),
        .eight(eight),
        .pen(pen),
        .d_out(remapped)
        );

    assign rx_data = (eight == 1'b1) ? remapped[7:0]: {1'b0,remapped[6:0]};

//----------------------------------------------------
//-----------------------FLAGS------------------------
//----------------------------------------------------
    //Rx Ready
    always @ (posedge clock)
        begin
        if (reset)
            rx_rdy <= 0;
        else if (done_d1)
            rx_rdy <= 1;
        else if (clear)
            rx_rdy <= 0;
        else
            rx_rdy <= rx_rdy;
        end
    
    //Parity Error
    assign mux_0 = (eight == 1'b1) ? remapped[7] : 0;
    assign mux_1 = (ohel == 1'b1) ? ~^({mux_0, remapped[6:0]}) : ^({mux_0, remapped[6:0]});
    assign mux_2 = (eight == 1'b1) ? remapped[8] : remapped[7];
    
    always @ (posedge clock)
        begin
        if (reset)
            p_err <= 0;
        else if (pen & ^({mux_1, mux_2}) & done)
            p_err <= 1;
        else if (clear)
            p_err <= 0;
        else
            p_err <= p_err;
        end
    
    //Framing Error
    assign mux_3 =  ({eight, pen} == 2'b00) ? remapped[7]:
                    ({eight, pen} == 2'b01) ? remapped[8]:
                    ({eight, pen} == 2'b10) ? remapped[8]:
                    ({eight, pen} == 2'b11) ? remapped[9]:
                    0;
    
    always @ (posedge clock)
        begin
        if (reset)
            f_err <= 0;
        else if (done & ~mux_3)
            f_err <= 1;
        else if (clear)
            f_err <= 0;
        else
            f_err <= f_err;
        end
    
    //Overflow Error
    always @ (posedge clock)
        begin
        if (reset)
            ovf <= 0;
        else if (rx_rdy & done)
            ovf <= 1;
        else if (clear)
            ovf <= 0;
        else
            ovf <= ovf;
        end


endmodule
