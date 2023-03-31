`timescale 1ns / 1ps
// `include "program_counter.v"

module MUX_2X1_1bit(A,B,out,sel);
    input wire A,B,sel;
    output wire out;

    assign out = sel ? B : A;
endmodule

// Not complete, need external and internal halt signal and clock wrapper
module wrapper(clkext, clk, cont, halt);
    input wire clkext, cont, halt;
    output wire clk;
    // wire haltf;
    // or o1(haltf, halt, cont);
    MUX_2X1_1bit mx1(clkext,cont,clk,halt);
endmodule

module program_counter_unit(
    input wire[31:0] next_address,
    input wire clkext, reset, cont, halt,
    output wire[31:0] PCin,
    output wire clk
);
    wrapper wc(clkext, clk, cont, halt);
    program_counter pc(next_address, PCin, clk, reset);

endmodule