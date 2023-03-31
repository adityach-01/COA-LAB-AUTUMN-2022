`timescale 1ns / 1ps
// `include "data_mem.v"

module test6();
    reg[31:0] a_in, data;
    wire[31:0] data_out;
    reg clk = 0,MemRead = 0, MemWrite = 0;

    data_memory d(a_in,data_out,data,MemWrite, MemRead, clk);

    initial begin
        MemRead = 0;
        a_in = 32'd1;
        data = 32'd69;
        #1;
        $display("data = %d",data_out);

        $finish;

    end

    always begin
        #20;
        clk = ~clk;
    end
endmodule