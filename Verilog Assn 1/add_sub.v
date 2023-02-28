//`include "rippleadder_8bit.v"

module Compute(A,B,control,Out,C);
    input[7:0] A,B;
    wire[7:0] in;
    input control;
    output C;
    output[7:0] Out;

    // we will do A-B if the control bit is 1, else we will do A+B
    // to calculate the 2s compliment of B, we XOR it with the control bit and send the conrol bit to the first carry bit of the ripple adder
    // integer i = 0;

    xor(in[0],B[0],control);
    xor(in[1],B[1],control);
    xor(in[2],B[2],control);
    xor(in[3],B[3],control);
    xor(in[4],B[4],control);
    xor(in[5],B[5],control);
    xor(in[6],B[6],control);
    xor(in[7],B[7],control);

    rippleAdder_8bit r1(A,in,control,Out,C);

endmodule