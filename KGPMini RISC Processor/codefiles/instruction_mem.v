`timescale 1ns / 1ps

module instruction_memory(clk,address_in, instruction_out);
    input wire clk;
    input wire[9:0] address_in;
    output wire[31:0] instruction_out;

instr_mem instructionMemory (
  .clka(clk), // input clka
  .addra(address_in), // input [9 : 0] addra
  .douta(instruction_out) // output [31 : 0] douta
);

endmodule
