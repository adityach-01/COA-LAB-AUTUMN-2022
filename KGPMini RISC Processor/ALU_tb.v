`timescale 1ns / 1ps
// `include "ALU.v"

module test();
    reg[31:0] A,B;
    wire[31:0] out;
    wire[2:0] flags;
    reg[4:0] controls;

    ALU ALU1(A,B,controls,flags,out);
	// shift_module s(A,B,controls,out);

    // testing all the control signals
    initial begin
        $monitor("A = %d B = %d out = %d flags = %b%b%b",A,B,out,flags[0],flags[1],flags[2]);

        {A,B} = {32'd512, 32'd512};
        controls = 5'b10000; #20; // Addition

        {A,B} = {32'd512, 32'd1024}; #20;
        {A,B} = {32'd150, 32'd150}; #20;
        {A,B} = {32'd1243, 32'd10}; #20;
    end


endmodule