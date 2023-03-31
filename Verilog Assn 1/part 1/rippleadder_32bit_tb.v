`timescale 1ns / 1ns
// `include "rippleadder_32bit.v"

module test();


    reg[31:0] A,B;
    wire[31:0] sum;
    wire carry;
    rippleAdder_32bit r(A,B,1'b0,sum,carry);

    initial begin
        

        $monitor("A = %d B = %d Sum = %d Carry = %b",A,B,sum,carry);

        {A,B} = {32'd5, 32'd9}; #20;
        {A,B} = {32'd111124, 32'd862164}; #20;
        {A,B} = {32'd151241, 32'd9}; #20;
        {A,B} = {32'd24221, 32'd3214}; #20;

        // Working perfectly

    end

endmodule
