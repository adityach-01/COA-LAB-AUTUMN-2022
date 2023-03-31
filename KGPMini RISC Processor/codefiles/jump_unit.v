`timescale 1ns / 1ps
// `include "jump_control.v"
// `include "ALU.v"

module jump_unit(
    input wire[31:0] PCin, address, ALUresult,
    input wire AdSel,unconditional,
    input wire[2:0] conditional, flags,
    output wire[31:0] next_address
);

    wire[31:0] sel_addr;
    MUX_2X1 mx1(address,ALUresult,sel_addr,AdSel);

    wire jump_signal;
    jump_control jc(conditional, flags, jump_signal);

    // or jump_signal and unconditional
    wire final_ad_sel;
    or o1(final_ad_sel,jump_signal,unconditional);

    // increment program counter
    // PCin = PCin + 1
    wire[31:0] increment_PC;
    wire useless_carry;
    adder_module incPC(PCin,32'b1,increment_PC,useless_carry);

    // pass the result in the MUX
    MUX_2X1 mx2(increment_PC,sel_addr,next_address,final_ad_sel);


endmodule