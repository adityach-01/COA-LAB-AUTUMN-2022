`timescale 1ns / 1ps
// `include "jump_unit.v"

module test9();
    reg[31:0] PCin = 32'd2, address = 32'd35, res = 32'd45;
    reg AdSel=0,unconditional=0;
    reg[2:0] conditional = 3'b0, flags=3'b0;
    wire[31:0] next_address;

    jump_unit ju(PCin,address,res,AdSel,unconditional,conditional,flags,next_address);

    initial begin
        #6;
        $display("next_addr = %d",next_address);
    end

endmodule