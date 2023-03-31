`timescale 1ns / 1ps
// `include "instruction_mem.v"

module test7();
    reg[31:0] add_in;
    wire[31:0] i_out;

    instruction_memory i1(add_in,i_out);

    initial begin
        $monitor("instruction = %b%b%b%b", i_out[3], i_out[2], i_out[1], i_out[0]);
        add_in = 32'b0; #5;
        add_in = 32'd1; #5;
        add_in = 32'd2; #5;
        add_in = 32'd3; #5;
        add_in = 32'd4; #5;

    end
endmodule