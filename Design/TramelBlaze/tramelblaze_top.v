`timescale 1ns/1ns

	module tramelblaze_top (CLK, RESET, IN_PORT, INTERRUPT, 
                        OUT_PORT, PORT_ID, READ_STROBE, WRITE_STROBE, INTERRUPT_ACK);

input         CLK;
input         RESET;
input  [15:0] IN_PORT;
input         INTERRUPT;

output [15:0] OUT_PORT;
output [15:0] PORT_ID;
output        READ_STROBE;
output        WRITE_STROBE;
output        INTERRUPT_ACK;

wire   [15:0] INSTRUCTION;
wire   [11:0] ADDRESS;

tramelblaze tramelblaze(
      .CLK(CLK), 
      .RESET(RESET), 
      .IN_PORT(IN_PORT), 
      .INTERRUPT(INTERRUPT), 
      .OUT_PORT(OUT_PORT), 
      .PORT_ID(PORT_ID), 
      .READ_STROBE(READ_STROBE), 
      .WRITE_STROBE(WRITE_STROBE), 
      .INTERRUPT_ACK(INTERRUPT_ACK),
      .ADDRESS(ADDRESS),
      .INSTRUCTION(INSTRUCTION)
      );
                
tb_rom ROM(
      .clka(CLK),                   // input clka
      .addra(ADDRESS),              // input [11 : 0] addra
      .douta(INSTRUCTION)           // output [15 : 0] douta
      );

endmodule
