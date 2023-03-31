`timescale 1ns / 1ps
// `include "CPU.v"

module test5();
    reg clk = 0, reset = 0, cont= 0;
    wire[31:0] out;

    CPU c(clk,reset,cont,out);

    initial begin
        // reset = 0;#100;
        #98;
        reset = 1;#1;
        reset = 0;

        #1000;
        $finish;  
    end

    always@(posedge clk)
    begin
        $display("out = %d", out);
    end

    always begin
        #2;
        clk = ~clk;
    end
endmodule
