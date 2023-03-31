`timescale 1ns / 1ns
// `include "CLA_4bit_augmented.v"

module test();
    reg[3:0] A,B;
    wire[3:0] sum;
    wire P,G;
    wire carry;

    carry_look_adder_augmented c(A,B,1'b0,sum,P,G);

    initial begin
        
        $monitor("A = %b%b%b%b B = %b%b%b%b Sum = %b%b%b%b P = %b G = %b" ,A[3],A[2],A[1],A[0],B[3],B[2],B[1],B[0],sum[3],sum[2],sum[1],sum[0],P,G);

        {A,B} = {4'd5, 4'd9}; #20;
        {A,B} = {4'd11, 4'd4}; #20;
        {A,B} = {4'd15, 4'd9}; #20;
        {A,B} = {4'd2, 4'd3}; #20;

        // Working perfectly

    end

endmodule
