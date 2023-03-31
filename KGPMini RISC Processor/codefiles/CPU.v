`timescale 1ns / 1ps
// `include "program_counter_unit.v"
// `include "control_unit.v"
// `include "jump_unit.v"
// `include "arithmetic_and_memory_unit.v"

module clock_div(clkin, clkout, reset);
    input clkin, reset;
    output reg clkout = 1'd0;

    reg[31:0] c = 32'd0;
    reg[31:0] DELAY = 32'd20000;

    always@(posedge clkin or posedge reset)
    begin
        if(reset)
        begin
            c = 32'd0;
            clkout = 0;
        end
			
		else
		begin
			c = c+1;

			if(c == DELAY)
            begin
                c = 32'd0;
                clkout = ~clkout;
            end
		end
    end
endmodule

module CPU(
    input wire clkin,reset,cont,
    output wire[31:0] out
);

    // variables instantiation
    wire[5:0] opcode;
    wire DataPCSel,RegSelect,RegWrite,MemRead,MemWrite,MemtoReg,AdSel,unconditional,halt, clk_out, clk;
    wire[2:0] conditional, flags, ALUop;
    wire[1:0] ALUinSel;

    wire[31:0] PCin,ALUresult, address, next_address;
	 
	 clock_div divider(clkin, clk, reset);

    control_unit cu(opcode,reset,DataPCSel, RegSelect, RegWrite, MemRead, MemWrite, MemtoReg, AdSel, unconditional, halt,
    conditional, ALUop,ALUinSel);

    arithmetic_and_memory_unit au(PCin,clk_out,reset,RegWrite,MemRead,MemWrite,MemtoReg,DataPCSel,RegSelect,ALUop,ALUinSel,ALUresult, address,out,flags,opcode);

    program_counter_unit pcu(next_address,clk, reset, cont, halt, PCin, clk_out);

    jump_unit ju(PCin, address, ALUresult, AdSel,unconditional, conditional, flags, next_address);

endmodule

