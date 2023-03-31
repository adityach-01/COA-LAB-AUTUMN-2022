//include "rippleadder_8bit.v"

module rippleAdder_16bit(A,B,Cinit,Sum,C);
    input[15:0] A,B;
    output[15:0] Sum;
    input Cinit;
    output C;

    wire ripplecarry;
    rippleAdder_8bit r1(A[7:0],B[7:0],Cinit,Sum[7:0],ripplecarry);
    rippleAdder_8bit r2(A[15:8],B[15:8],ripplecarry,Sum[15:8],C);

endmodule