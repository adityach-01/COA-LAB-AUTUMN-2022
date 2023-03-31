//include "halfadder.v"

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


