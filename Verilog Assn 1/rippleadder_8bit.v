//include "fulladder.v"

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