`timescale 1ns / 1ps
// `include "regfile.v"
// `include "ALU.v"
// `include "data_mem.v"

module circuit(r1,r2,regw,clk,reset,ALUc,memw,memr,dout);
    input wire[4:0] r1,r2,ALUc;
    input wire regw,clk,reset,memw,memr;
    output wire[31:0] dout;

    wire[31:0] o1,o2,result;
    wire[2:0] flags;

    regfile r(r1,r2,r2,o1,o2,clk,dout,regw,reset);
    ALU a(o1,o2,ALUc,flags,result);
    data_memory d(result,dout,o2,memw,memr,clk);

endmodule