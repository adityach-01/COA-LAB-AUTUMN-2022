`timescale 1ns / 1ns
//`include "add_sub.v"

module test();

    reg[7:0] A,B;
    wire[7:0] ans;
    wire carry;
    Compute c(A,B,1'b1,ans,carry);

    initial begin
        
        $monitor("A = %d B = %d Ans = %d Carry = %b",A,B,ans,carry);

        {A,B} = {8'd15, 8'd11}; #20;
        {A,B} = {8'd111, 8'd41}; #20;
        {A,B} = {8'd15, 8'd9}; #20;
        {A,B} = {8'd3, 8'd2}; #20;

        // Working perfectly

    end

endmodule