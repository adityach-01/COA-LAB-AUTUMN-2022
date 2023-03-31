// This verilog code of a 4-bit CLA gives P and G signals as output
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

module carry_look_adder_augmented(A,B,cin,S,Pg,Gg);
    input[3:0] A,B;
    output[3:0] S;
    output Pg, Gg;
    input cin;

    wire[3:0] P,G;

    // computing carry generate
    and(G[0],A[0],B[0]);
    and(G[1],A[1],B[1]);
    and(G[2],A[2],B[2]);
    and(G[3],A[3],B[3]);

    // computing carry propogate
    xor(P[0],A[0],B[0]);
    xor(P[1],A[1],B[1]);
    xor(P[2],A[2],B[2]);
    xor(P[3],A[3],B[3]);

    wire[3:0] carry;

    // computing the carry bits of the adder
    compute_c0 c0(P,G,cin,carry[0]);
    compute_c1 c1(P,G,cin,carry[1]);
    compute_c2 c2(P,G,cin,carry[2]);
    compute_c3 c3(P,G,cin,carry[3]);

    // Assigning the sum bits
    xor(S[0],P[0],cin);
    xor(S[1],P[1],carry[0]);
    xor(S[2],P[2],carry[1]);
    xor(S[3],P[3],carry[2]);

    // Now we calculate the group carry propogate and group carry generate as outputs of the augmented adder
    assign Pg = P[3] & P[2] & P[1] & P[0];
	assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

