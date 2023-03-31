`timescale 1ns / 1ps

module program_counter(next_addr, out_addr, clk, reset);
    input wire[31:0] next_addr;
    output wire[31:0] out_addr;
    input wire clk, reset;
    reg[31:0] buffer;
    wire[31:0] out_addr_temp;

    always@(posedge clk or posedge reset)
    begin
        if(reset) buffer = 32'b0;
        else buffer = next_addr;
    end

    
    assign out_addr = buffer;
endmodule