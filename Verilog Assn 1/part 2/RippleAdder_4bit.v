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

module rippleAdder_4bit(A,B,Cinit,Out,C);

    input[3:0] A,B;
    output[3:0] Out;
    input Cinit;
    output C;

    wire[2:0] carry;

    FullAdder f1(A[0],B[0],Cinit,Out[0],carry[0]);
    FullAdder f2(A[1],B[1],carry[0],Out[1],carry[1]);
    FullAdder f3(A[2],B[2],carry[1],Out[2],carry[2]);
    FullAdder f4(A[3],B[3],carry[2],Out[3],C);

endmodule