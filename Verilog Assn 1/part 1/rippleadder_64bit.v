//include "rippleadder_32bit.v"

module rippleAdder_64bit(A,B,Cinit,Sum,C);
    input[63:0] A,B;
    output[63:0] Sum;
    input Cinit;
    output C;

    wire ripplecarry;
    rippleAdder_32bit r1(A[31:0],B[31:0],Cinit,Sum[31:0],ripplecarry);
    rippleAdder_32bit r2(A[63:32],B[63:32],ripplecarry,Sum[63:32],C);

endmodule
