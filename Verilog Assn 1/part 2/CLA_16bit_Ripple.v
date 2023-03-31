`include "CLA_4bit.v"

module CLA_16bit_ripple(A,B,cin,S,Carry);
    input[15:0] A,B;
    input cin;
    output[15:0] S;
    output Carry;
    wire[2:0] ripplecarry;
    
    carry_look_adder ca1(A[3:0],B[3:0],cin,S[3:0],ripplecarry[0]);
    carry_look_adder ca2(A[7:4],B[7:4],ripplecarry[0],S[7:4],ripplecarry[1]);
    carry_look_adder ca3(A[11:8],B[11:8],ripplecarry[1],S[11:8],ripplecarry[2]);
    carry_look_adder ca4(A[15:12],B[15:12],ripplecarry[2],S[15:12],Carry);
endmodule



