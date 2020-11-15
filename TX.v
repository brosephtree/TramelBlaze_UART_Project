`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/17/2020 12:12:30 AM
//
// Module Name: TX
//
// Description: TX serially transmits data via a shift register.  When engaged,
// TX coordinates the time-keeping modules, data processing modules, and shift 
// register module to deliver a final Tx signal used by the UART.  TX also sends
// signals to the TramelBlaze when it is ready for the next transmission.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module TX(
    input clock,
    input reset,
    input [18:0] bit_period,
    input eight,
    input pen,
    input ohel,
    input load,
    input [7:0] load_data,
    output reg tx_rdy,
    output tx
    );
    
    reg doit, write_d1, done_d1;
    reg [7:0] loaded_data;
    
    wire btu, done;
    wire [1:0] decoded;


    //TX RDY SR FLOP
    always @ (posedge clock)
        begin
        if (reset)
            tx_rdy <= 1;
        else if (load)
            tx_rdy <= 0;
        else if (done_d1)
            tx_rdy <= 1;
        else
            tx_rdy <= tx_rdy;
        end
    
    //DOIT SR FLOP
    always @ (posedge clock)
        begin
        if (reset)
            doit <= 0;
        else if (load)
            doit <= 1;
        else if (done)
            doit <= 0;
        else
            doit <= doit;
        end
    
    //reg8
    always @ (posedge clock)
        begin
        if (reset)
            loaded_data <= 0;
        else if (load)
            loaded_data <= load_data;
        else
            loaded_data <= loaded_data;
        end
    
    //LOAD DELAY FLOP
    always @ (posedge clock)
        begin
        if (reset)
            write_d1 <= 0;
        else
            write_d1 <= load;
        end

//----------------------------------------------------
//------------------BIT TIME COUNTER------------------
//----------------------------------------------------
    bit_time_counter v0(
        .clock(clock),
        .reset(reset),
        .doit(doit),
        .bit_period(bit_period),
        .btu(btu)
        );

//----------------------------------------------------
//---------------------BIT COUNTR---------------------
//----------------------------------------------------
    bit_counter v1(
        .clock(clock),
        .reset(reset),
        .btu(btu),
        .doit(doit),
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
//---------------------DECODE SHR---------------------
//----------------------------------------------------
    decode_shr v2(
        .loaded_data(loaded_data),
        .eight(eight),
        .pen(pen),
        .ohel(ohel),
        .decoded(decoded)
        );

//----------------------------------------------------
//-------------------SHIFT REGISTER-------------------
//----------------------------------------------------
    shift_register v3(
        .clock(clock),
        .reset(reset),
        .data_in({decoded, loaded_data[6:0], 2'b01}),
        .load(write_d1),
        .shift(btu),
        .tx(tx)
        );

endmodule
