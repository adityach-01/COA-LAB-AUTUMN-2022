//`include "rippleadder_16bit.v"

module rippleAdder_32bit(A,B,Cinit,Sum,C);
    input[31:0] A,B;
    output[31:0] Sum;
    input Cinit;
    output C;

    wire ripplecarry;
    rippleAdder_16bit r1(A[15:0],B[15:0],Cinit,Sum[15:0],ripplecarry);
    rippleAdder_16bit r2(A[31:16],B[31:16],ripplecarry,Sum[31:16],C);

endmodule