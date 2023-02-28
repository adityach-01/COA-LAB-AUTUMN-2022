`timescale 1ns / 1ps
// `include "ALU_control.v"

module test();
    reg[2:0] ALU;
    reg[5:0] funct;
    wire[4:0] out;

    ALU_control a1(ALU,funct,out);

    initial begin
        // $monitor("out = %b%b%b%b%b", out[4], out[3], out[2], out[1], out[0]);

        {ALU,funct} = 9'b001010101;
        #6;
        $display("out = %b%b%b%b%b", out[4], out[3], out[2], out[1], out[0]);
        {ALU,funct} = 9'b111000101;
        #10;
        $display("out = %b%b%b%b%b", out[4], out[3], out[2], out[1], out[0]);
        // #5;
        // {ALU,funct} = 9'b111001000;
        // #5;
        // {ALU,funct} = 9'b100010101;
        // #5;
        // {ALU,funct} = 9'b111010101;
        // #5;
    end
endmodule