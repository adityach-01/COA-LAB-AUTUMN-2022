`timescale 1ns / 1ps
// `include "jump_control.v"

module test();
    reg[2:0] condition, flags;
    wire out;

    // flags[0] = sign flag
    // flags[1] = zero flag
    // flags[2] = carry flag

    jump_control jc(condition,flags,out);

    initial begin
        $monitor("out = %b",out);
        {condition, flags} = 6'b101101;#10;
    end
endmodule