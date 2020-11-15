`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Joseph Nguyen
// Create Date: 05/19/2020 06:26:34 PM
//
// Module Name: RxSM
//
// Description: The RX State Machine converts the asynchronous rx signal into
// signals that function using the FPGA clock.  Depending on the state of the RXSM,
// different outputs will be asserted to coordinate the time-keeping modules of RX.
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module RxSM(
    input clock,
    input reset,
    input rx,
    input done,
    input btu,
    output start,
    output doit
    );

    //parameters for STATES
    parameter   IDLE = 2'b00, 
                DC = 2'b01,         //Data Collection
                START = 2'b11;
    
    //register map
    reg [1:0]   p_s,    //present state
                n_s,    //next state
                p_o,    //present output (start, doit)
                n_o;    //next output

    assign {start, doit} = p_o;

    //register assignments
    always @ (posedge clock)
        begin
        if (reset)
            begin
            p_s <= IDLE;
            p_o <= 2'b00;
            end
        else
            begin
            p_s <= n_s;
            p_o <= n_o;
            end
        end

//----------------------------------------------------
//--------------------STATEMACHINE--------------------
//----------------------------------------------------
    always @*
        case (p_s)
            
            IDLE: begin
                if (~rx)
                    begin
                    n_s = START;
                    n_o = 2'b11;
                    end
                else
                    begin
                    n_s = IDLE;
                    n_o = 2'b00;
                    end
            end
            
            START: begin
                if (~rx & ~btu)
                    begin
                    n_s = START;
                    n_o = 2'b11;
                    end
                else if (~rx & btu)
                    begin
                    n_s = DC;
                    n_o = 2'b01;
                    end
                else
                    begin
                    n_s = IDLE;
                    n_o = 2'b00;
                    end
            end
            
            DC: begin
                if (~done)
                    begin
                    n_s = DC;
                    n_o = 2'b01;
                    end
                else
                    begin
                    n_s = IDLE;
                    n_o = 2'b00;
                    end
            end
            
            default: begin
                n_s = IDLE;
                n_o = 2'b00;
                end
        
        endcase

endmodule
