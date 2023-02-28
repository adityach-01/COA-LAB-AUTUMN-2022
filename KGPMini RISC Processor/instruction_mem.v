`timescale 1ns / 1ps

module instruction_memory(clk,address_in, instruction_out);
    input wire clk;
    input wire[9:0] address_in;
    output wire[31:0] instruction_out;

    reg[31:0] register[1024:0];
    reg[31:0] buffer;

    initial begin
        $readmemb("assembler/memory.txt", register, 0);
    end

    always@(posedge clk)
    begin
        buffer <= register[address_in];
    end

    assign instruction_out = buffer;
    // assign instruction_out = register[address_in];

endmodule
