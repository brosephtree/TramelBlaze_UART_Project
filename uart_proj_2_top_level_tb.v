`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// 
// Create Date: 05/24/2020 04:44:52 PM
//
// Module Name: uart_proj_2_top_level_tb
//
// Description: Top level test bench of simulation.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_proj_2_top_level_tb;
    parameter CLK_FREQ = 100 * 10**6;           //clock at 100 MHz
    
    reg clock, reset;
    reg [3:0] baud;
    reg eight, pen, ohel, rx;
    
    wire tx;
    wire [15:0] led;

    tramelblaze_uart_project_2_top_level #(
        .CLK_FREQ(CLK_FREQ)
        )
    u0 (
        .clock(clock),
        .reset(reset),
        .baud(baud),
        .eight(eight),
        .pen(pen),
        .ohel(ohel),
        .rx(rx),
        .tx(tx),
        .led(led)
        );

    reg [7:0] mem [0:999];
    integer i, j, data;
    
    always #5 clock = ~clock;
    
    initial begin
    
    clock = 0;
    reset = 0;
    baud = 4'b0111;
    eight = 1;
    pen = 1;
    ohel = 1;
    rx = 1;
    
    data = 7 + eight;
    
    mem[0] <= 8'b01101010;  //j
    mem[1] <= 8'b01101111;  //o
    mem[2] <= 8'b01110011;  //s
    mem[3] <= 8'b01100101;  //e
    mem[4] <= 8'b01110000;  //p
    mem[5] <= 8'b01101000;  //h
    mem[6] <= 8'b00001000;  //BACKSPACE
    mem[7] <= 8'b01000000;  //@
    mem[8] <= 8'b00101010;  //*


//----------------------------------------------------
//------------------------RSET------------------------
//----------------------------------------------------
    @ (negedge clock)
        reset = 1;
    @ (negedge clock)
        reset = 0;

//----------------------------------------------------
//-----------------------RXTEST-----------------------
//----------------------------------------------------
    //skip beginning banner
    #8_000_000
    
    //for loop over keystrokes saved in mem
    for (i=0; i<8; i=i+1)           //looping through keystrokes 0-7
        begin
        #17_361                     //10^9 / 57600 = 17361.1111111111
        rx = 0;                     //start bit
        for (j=0; j<data; j=j+1)
            begin
            #17_361
            rx = mem[i][j];         //data bits
            end
        #17_361
        rx =    ({pen, ohel} == 2'b10) ? ^(mem[i]): //parity bit
                ({pen, ohel} == 2'b11) ? ~^(mem[i]):
                1;
        #17_361
        rx = 1;                     //end bit
        end

    #600_000
    //for loop over * keystroke
    for (i=8; i<9; i=i+1)           //looping through keystroke 8
        begin
        #17_361                     //10^9 / 57600 = 17361.1111111111
        rx = 0;                     //start bit
        for (j=0; j<data; j=j+1)
            begin
            #17_361
            rx = mem[i][j];         //data bits
            end
        #17_361
        rx =    ({pen, ohel} == 2'b10) ? ^(mem[i]): //parity bit
                ({pen, ohel} == 2'b11) ? ~^(mem[i]):
                1;
        #17_361
        rx = 1;                     //end bit
        end

    end

endmodule
