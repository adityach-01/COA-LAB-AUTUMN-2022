`timescale 1ns/1ns

module halfadder(A,B,S,C);

    input A,B;
    output S,C;

    assign S = A^B;
    assign C = A&B;

endmodule

module FullAdder(A,B,Cin,S,Cout);

    input A,B,Cin;
    output S,Cout;

    wire sum1;       // output sum of 1 st half adder
    wire carry1;     // output carry of 1st half adder
    wire carry2;     // output carry of 2nd half adder 

    // output sum of 2nd half adder is the output sum of the full adder
    // output carry is the OR of the carry output of half adder 1 and half adder 2

    halfadder h1(A,B,sum1,carry1);
    halfadder h2(sum1,Cin,S,carry2);

    xor(Cout, carry1, carry2);

endmodule

module rippleAdder_4bit(A,Cinit,Out,C);

    input[3:0] A;
    output[3:0] Out;
    input Cinit;
    output C;

    wire[2:0] carry;

    FullAdder f1(A[0],1'b1,Cinit,Out[0],carry[0]);
    FullAdder f2(A[1],1'b0,carry[0],Out[1],carry[1]);
    FullAdder f3(A[2],1'b0,carry[1],Out[2],carry[2]);
    FullAdder f4(A[3],1'b0,carry[2],Out[3],C);
    
endmodule

module carry_lookahead_optimised(A,out);
    input[3:0] A;
    output[3:0] out;

    // These are the equations that we obtain after optimising the carry look ahead adder
    /*
    S0 = ~A0
    S1 = A1 ^ A0
    S2 = A2 ^ (A0 & A1)
    S3 = A3 ^ (A0 & A1 & A2)
    */

    not(out[0], A[0]);
    xor(out[1], A[0], A[1]);
    xor(out[2], A[2], A[0]&A[1]);
    xor(out[3], A[3], A[0]&A[1]&A[2]);

endmodule

// D flip flop working fine, use this as a sample code for future references
// Remember this implementation fo the flip flop, better to not have a variable type for input and output value

module Dff(D,CLK,Q, reset);

    input D,CLK, reset;
    output Q;

    // wire can be assigned the value of a register

    reg Z = 0;
    assign Q = Z;

    always@(posedge CLK or posedge reset)
    begin
        if(reset) Z = 0;
        else Z = D;
    end

endmodule

module counter(CLK, dff_out, reset);
    input CLK, reset;
    output[3:0] dff_out;

    // reg[3:0] in1 = {0,0,0,1};

    wire[3:0] sum_out;
    wire[3:0] dff_out;
    wire C;

    Dff d1(sum_out[0], CLK, dff_out[0], reset);
    Dff d2(sum_out[1], CLK, dff_out[1], reset);
    Dff d3(sum_out[2], CLK, dff_out[2], reset);
    Dff d4(sum_out[3], CLK, dff_out[3], reset);

    // rippleAdder_4bit r1(dff_out, 1'b0, sum_out, C);
    carry_lookahead_optimised cp(dff_out,sum_out);

    // assign count = dff_out;
    
endmodule

module test();

    reg CLK = 0, reset = 1;
    wire[3:0] out;
    counter c(CLK, out, reset);

    always begin
        CLK = ~CLK;
        #10;
    end

    initial begin
        $monitor("count = %b%b%b%b", out[3],out[2],out[1],out[0]);
        reset = 1;
        #5;
        reset = 0;
        #200
        
        $finish;
    end

endmodule