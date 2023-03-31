`timescale 1ns / 1ns
// `include "halfadder.v"

module test();

    reg A,B;
    wire sum;
    wire carry;
    halfadder a(A,B,sum,carry);

    initial begin
    

        $monitor("A = %b B = %b Sum = %b Carry = %b",A,B,sum,carry);

        {A,B} = {1'd0, 1'd0}; #20;
        {A,B} = {1'd0, 1'd1}; #20;
        {A,B} = {1'd1, 1'd0}; #20;
        {A,B} = {1'd1, 1'd1}; #20;

        // Working perfectly

    end

endmodule