`include "LookAheadCarryUnit.v"
`include "CLA_4bit_augmented.v"

module CLA_16bit_LookAheadUnit(A,B,cin,S,carry);
    input[15:0] A,B;
    output[15:0] S;
    input cin;
    output carry;

    wire[3:0] carry_out;
    wire[3:0] p_input, g_input;

    carry_look_adder_augmented c1(A[3:0],B[3:0],cin,S[3:0],p_input[0],g_input[0]);
    carry_look_adder_augmented c2(A[7:4],B[7:4],carry_out[0],S[7:4],p_input[1],g_input[1]);
    carry_look_adder_augmented c3(A[11:8],B[11:8],carry_out[1],S[11:8],p_input[2],g_input[2]);
    carry_look_adder_augmented c4(A[15:12],B[15:12],carry_out[2],S[15:12],p_input[3],g_input[3]);

    lookahead_carry_unit lu1(cin,p_input[0],g_input[0],p_input[1],g_input[1],p_input[2],g_input[2],p_input[3],g_input[3],carry_out[0],carry_out[1],carry_out[2],carry_out[3]);

    assign carry = carry_out[3];

endmodule


