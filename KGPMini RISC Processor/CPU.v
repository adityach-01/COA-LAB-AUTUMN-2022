`timescale 1ns / 1ps
// `include "program_counter_unit.v"
// `include "control_unit.v"
// `include "jump_unit.v"
// `include "arithmetic_and_memory_unit.v"

module CPU(
    input wire clk,reset,cont,
    output wire[31:0] out
);

    // variables instantiation
    wire[5:0] opcode;
    wire DataPCSel,RegSelect,RegWrite,MemRead,MemWrite,MemtoReg,AdSel,unconditional,halt, clk_out;
    wire[2:0] conditional, flags, ALUop;
    wire[1:0] ALUinSel;

    wire[31:0] PCin,ALUresult, address, next_address;

    control_unit cu(opcode,reset,DataPCSel, RegSelect, RegWrite, MemRead, MemWrite, MemtoReg, AdSel, unconditional, halt,
    conditional, ALUop,ALUinSel);

    arithmetic_and_memory_unit au(PCin,clk_out,reset,RegWrite,MemRead,MemWrite,MemtoReg,DataPCSel,RegSelect,ALUop,ALUinSel,ALUresult, address,out,flags,opcode);

    program_counter_unit pcu(next_address,clk, reset, cont, halt, PCin, clk_out);

    jump_unit ju(PCin, address, ALUresult, AdSel,unconditional, conditional, flags, next_address);

endmodule

