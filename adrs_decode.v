`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 04/27/2020 08:16:12 PM
//
// Module Name: adrs_decode
//
// Description: The ADRS_DECODE module's purpose is to convert the 4-bit
// PORT_ID[3:0] into its corresponding address, and to output said address to the
// proper channel based on PORT_ID[15:14].
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module adrs_decode(
    input [15:0] PORT_ID,
    input READ_STROBE,
    input WRITE_STROBE,
    output reg [15:0] READS3,
    output reg [15:0] WRITES3,
    output reg [15:0] READS2,
    output reg [15:0] WRITES2,
    output reg [15:0] READS1,
    output reg [15:0] WRITES1,
    output reg [15:0] READS0,
    output reg [15:0] WRITES0
    );
    
    reg [15:0] adrs;
    
    //READ
    always @ *
        begin
        
        //default signals
        {READS0, READS1, READS2, READS3} <= 0;
        
        case (PORT_ID[15:14])
            2'b00:  if (READ_STROBE) READS0 <= adrs;
                    else READS0 <= 0;
            2'b01:  if (READ_STROBE) READS1 <= adrs;
                    else READS1 <= 0;
            2'b10:  if (READ_STROBE) READS2 <= adrs;
                    else READS2 <= 0;
            2'b11:  if (READ_STROBE) READS3 <= adrs;
                    else READS3 <= 0;
            default: {READS0, READS1, READS2, READS3} <= 0;
        endcase
        end
    
    //WRITE
    always @ *
        begin
        
        //default signals
        {WRITES0, WRITES1, WRITES2, WRITES3} <= 0;
        
        case (PORT_ID[15:14])
            2'b00:  if (WRITE_STROBE) WRITES0 <= adrs;
                    else WRITES0 <= 0;
            2'b01:  if (WRITE_STROBE) WRITES1 <= adrs;
                    else WRITES1 <= 0;
            2'b10:  if (WRITE_STROBE) WRITES2 <= adrs;
                    else WRITES2 <= 0;
            2'b11:  if (WRITE_STROBE) WRITES3 <= adrs;
                    else WRITES3 <= 0;
            default: {WRITES0, WRITES1, WRITES2, WRITES3} <= 0;
        endcase
        end
    
    //REGISTER MAP
    always @ *
        case (PORT_ID[3:0])
            4'h0: adrs <= 16'h0001;
            4'h1: adrs <= 16'h0002;
            4'h2: adrs <= 16'h0004;
            4'h3: adrs <= 16'h0008;
            4'h4: adrs <= 16'h0010;
            4'h5: adrs <= 16'h0020;
            4'h6: adrs <= 16'h0040;
            4'h7: adrs <= 16'h0080;
            4'h8: adrs <= 16'h0100;
            4'h9: adrs <= 16'h0200;
            4'ha: adrs <= 16'h0400;
            4'hb: adrs <= 16'h0800;
            4'hc: adrs <= 16'h1000;
            4'hd: adrs <= 16'h2000;
            4'he: adrs <= 16'h4000;
            4'hf: adrs <= 16'h8000;
            default: adrs <= 0;
        endcase
    
endmodule
