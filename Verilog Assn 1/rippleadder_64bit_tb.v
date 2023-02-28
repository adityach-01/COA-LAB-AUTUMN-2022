`timescale 1ns / 1ns
// `include "rippleadder_64bit.v"

module test();

    reg[63:0] A;
    reg[63:0] B;
    wire[63:0] sum;
    wire carry;

    rippleAdder_64bit r(A,B,1'b0,sum,carry);

    initial begin

        $monitor("A = %d B = %d Sum = %d Carry = %b",A,B,sum,carry);

        {A,B} = {64'd534, 64'd923}; #20;
        {A,B} = {64'd111, 64'd4133}; #20;
        {A,B} = {64'd1513, 64'd1535}; #20;
        {A,B} = {64'd2, 64'd3}; #20;
        // Working perfectly

    end

endmodule
