//`include "CLA_4bit.v"

module wrapper(input clk, input rst, input[15:0] in1, input[15:0] in2, output reg[15:0] out);
reg[15:0] in1_reg;
reg[15:0] in2_reg;
wire[15:0] out_net;
wire C;

always@(posedge clk)
    begin
        if(rst)
            begin
                in1_reg<=15'd0;
                in2_reg<=15'd0;
                out<=15'd0;
            end
        else
            begin
                in1_reg<=in1;
                in2_reg<=in2;
                out<=out_net;
            end
    end
CLA_16bit_LookAheadUnit c1(in1_reg,in2_reg,1'b0,out_net,C);

endmodule