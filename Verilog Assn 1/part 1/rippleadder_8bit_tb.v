`timescale 1ns / 1ns
// `include "rippleadder_8bit.v"

module test();


    reg[7:0] A,B;
    wire[7:0] sum;
    wire carry;
    rippleAdder_8bit r(A,B,1'b0,sum,carry);

    initial begin
        
        $monitor("A = %b%b%b%b%b%b%b%b B = %b%b%b%b%b%b%b%b Sum = %b%b%b%b%b%b%b%b Carry= %b" ,A[7],A[6],A[5],A[4],A[3],A[2],A[1],A[0],B[7],B[6],B[5],B[4],B[3],B[2],B[1],B[0],sum[7],sum[6],sum[5],sum[4],sum[3],sum[2],sum[1],sum[0],carry);

        {A,B} = {8'd5, 8'd9}; #20;
        {A,B} = {8'd111, 8'd41}; #20;
        {A,B} = {8'd15, 8'd9}; #20;
        {A,B} = {8'd2, 8'd3}; #20;

        // Working perfectly

    end

endmodule
