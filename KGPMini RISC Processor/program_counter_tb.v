`timescale 1ns / 1ps
// `include "program_counter.v"

module test();
    reg[31:0] next = 32'd34;
    reg clk = 0, reset = 0;
    wire[31:0] out;

    program_counter pc(next,out,clk,reset);

    initial begin
        reset = 1; #20;
        reset = 0; #20;
        $monitor("out_addr = %d",out);

        next = 32'd69; #40;
        next = 32'd23; #40;
        next = 32'd24; #40;
        next = 32'd25; #40;

        reset = 1; #20;

        $finish;
    end

    always begin
        clk = ~clk;
        #20;
    end
endmodule