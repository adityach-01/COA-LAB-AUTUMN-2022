// In this we will use the augmented adder and use a lookahead carry module for determining the carry of the next CLA

module lookahead_carry_unit(cin,p0,g0,p4,g4,p8,g8,p12,g12,c4,c8,c12,c16);
    input cin,p0,g0,p4,g4,p8,g8,p12,g12;
    output c4,c8,c12,c16;

    assign c4 = (g0) + (p0&cin);
    assign c8 = (g4)+(p4&g0)+(cin&p4&p0);
    assign c12 = (g8)+(p8&g4)+(p8&p4&g0)+(p8&p4&p0&cin);
    assign c16 = (g12)+(g8&p12)+(g4&p12&p8)+(p12&p8&p4&g0)+(p12&p8&p4&p0&cin);
endmodule

