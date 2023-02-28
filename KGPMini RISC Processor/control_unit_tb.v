`timescale 1ns / 1ps
// `include "control_unit.v"

module test();
    reg[5:0] opcode;
    reg reset = 0;
    wire DataPCSel, RegSelect, RegWrite, MemRead, MemWrite, MemtoReg, AdSel, unconditional, halt;
    wire[2:0] conditional, ALUop;
    wire[1:0] ALUinSel;

    control_unit c(opcode,reset,DataPCSel, RegSelect, RegWrite, MemRead, MemWrite, MemtoReg, AdSel, unconditional, halt,conditional, ALUop,ALUinSel);

    initial begin
        opcode = 6'b000001;#6;
        $display("ALUinSel = %b%b", ALUinSel[1], ALUinSel[0]);
    end

endmodule