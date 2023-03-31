`timescale 1ns / 1ns
// `include "CLA_16bit_LookaheadUnit.v"

module test();

    reg[15:0] A,B;
    wire[15:0] sum;
    wire carry;
    CLA_16bit_LookAheadUnit cal1(A,B,1'b0,sum,carry);

    initial begin
        

        $monitor("A = %d B = %d Sum = %d Carry = %b",A,B,sum,carry);

        {A,B} = {16'd5, 16'd9}; #20;
        {A,B} = {16'd111, 16'd41}; #20;
        {A,B} = {16'd15, 16'd9}; #20;
        {A,B} = {16'd2, 16'd3}; #20;

        // Working perfectly

    end

endmodule