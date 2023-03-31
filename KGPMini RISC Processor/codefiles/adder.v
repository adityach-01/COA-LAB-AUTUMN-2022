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

module rippleAdder_8bit(A,B,Cinit,Out,C);

    input[7:0] A,B;
    output[7:0] Out;
    input Cinit;
    output C;

    wire[6:0] carry;

    FullAdder f1(A[0],B[0],Cinit,Out[0],carry[0]);
    FullAdder f2(A[1],B[1],carry[0],Out[1],carry[1]);
    FullAdder f3(A[2],B[2],carry[1],Out[2],carry[2]);
    FullAdder f4(A[3],B[3],carry[2],Out[3],carry[3]);
    FullAdder f5(A[4],B[4],carry[3],Out[4],carry[4]);
    FullAdder f6(A[5],B[5],carry[4],Out[5],carry[5]);
    FullAdder f7(A[6],B[6],carry[5],Out[6],carry[6]);
    FullAdder f8(A[7],B[7],carry[6],Out[7],C);

endmodule

module rippleAdder_16bit(A,B,Cinit,Sum,C);
    input[15:0] A,B;
    output[15:0] Sum;
    input Cinit;
    output C;

    wire ripplecarry;
    rippleAdder_8bit r1(A[7:0],B[7:0],Cinit,Sum[7:0],ripplecarry);
    rippleAdder_8bit r2(A[15:8],B[15:8],ripplecarry,Sum[15:8],C);

endmodule

module rippleAdder_32bit(A,B,Cinit,Sum,C);
    input[31:0] A,B;
    output[31:0] Sum;
    input Cinit;
    output C;

    wire ripplecarry;
    rippleAdder_16bit r1(A[15:0],B[15:0],Cinit,Sum[15:0],ripplecarry);
    rippleAdder_16bit r2(A[31:16],B[31:16],ripplecarry,Sum[31:16],C);

endmodule