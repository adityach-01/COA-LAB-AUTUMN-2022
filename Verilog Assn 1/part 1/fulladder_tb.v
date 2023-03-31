`timescale 1ns / 1ns
//`include "fulladder.v"

module test();

    reg A,B, cin;
    wire sum;
    wire carry;
    FullAdder a(A,B,cin,sum,carry);

    initial begin
    

        $monitor("A = %b B = %b Cin = %b Sum = %b Carry = %b",A,B,cin,sum,carry);

        {A,B,cin} = {1'd0, 1'd0, 1'd0}; #20;
        {A,B,cin} = {1'd0, 1'd1, 1'd0}; #20;
        {A,B,cin} = {1'd1, 1'd0, 1'd1}; #20;
        {A,B,cin} = {1'd1, 1'd1, 1'd1}; #20;

        // Working perfectly

    end

endmodule