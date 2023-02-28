// This is the verilog code of a carry look ahead adder that computes the sum of 2 4-bit numbers

module compute_c0(P,G,cin,Out);
    input[3:0] P,G;
    input cin;
    output Out;

    assign Out = (G[0])+(P[0]&cin);
endmodule

module compute_c1(P,G,cin,Out);
    input[3:0] P,G;
    input cin;
    output Out;

    assign Out = (G[1])+(P[1]&G[0])+(P[1]&P[0]&cin);
endmodule

module compute_c2(P,G,cin,Out);
    input[3:0] P,G;
    input cin;
    output Out;

    assign Out = (G[2])+(P[2]&G[1])+(P[2]&P[1]&G[0])+(P[2]&P[1]&P[0]&cin);
endmodule

module compute_c3(P,G,cin,Out);
    input[3:0] P,G;
    input cin;
    output Out;

    assign Out = (G[3])+(P[3]&G[2])+(P[3]&P[2]&G[1])+(P[3]&P[2]&P[1]&G[0])+(P[3]&P[2]&P[1]&P[0]&cin);
endmodule

module carry_look_adder(A,B,cin,S,C);
    input[3:0] A,B;
    output[3:0] S;
    input cin;
    output C;

    wire[3:0] P,G;

    and(G[0],A[0],B[0]);
    and(G[1],A[1],B[1]);
    and(G[2],A[2],B[2]);
    and(G[3],A[3],B[3]);

    xor(P[0],A[0],B[0]);
    xor(P[1],A[1],B[1]);
    xor(P[2],A[2],B[2]);
    xor(P[3],A[3],B[3]);

    wire[3:0] carry;

    compute_c0 c0(P,G,cin,carry[0]);
    compute_c1 c1(P,G,cin,carry[1]);
    compute_c2 c2(P,G,cin,carry[2]);
    compute_c3 c3(P,G,cin,carry[3]);

    xor(S[0],P[0],cin);
    xor(S[1],P[1],carry[0]);
    xor(S[2],P[2],carry[1]);
    xor(S[3],P[3],carry[2]);

    assign C = carry[3];
endmodule

