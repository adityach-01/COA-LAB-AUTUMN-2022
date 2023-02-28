`timescale 1ns / 1ps
// regfile worlking fine

module regfile(readReg1, readReg2, writeReg, data1, data2, clk, writeData, RegWrite, reset);
    input wire[4:0] readReg1, readReg2, writeReg;
    output wire[31:0] data1,data2;
    input wire[31:0] writeData;
    input wire RegWrite, clk, reset;    // Control Signal for writing on the write register

    reg[31:0] register[31:0];
    assign data1 = register[readReg1];
    assign data2 = register[readReg2];

    // how to ahve asynchronous reset without having to have multiple flip flops sensitivities ??
    always@(posedge clk)
    begin
        if(reset)
            begin
                register[0] <= 32'b0;
                register[1] <= 32'b0;
                register[2] <= 32'b0;
                register[3] <= 32'b0;
                register[4] <= 32'b0;
                register[5] <= 32'b0;
                register[6] <= 32'b0;
                register[7] <= 32'b0;
                register[8] <= 32'b0;
                register[9] <= 32'b0;
                register[10] <= 32'b0;
                register[11] <= 32'b0;
                register[12] <= 32'b0;
                register[13] <= 32'b0;
                register[14] <= 32'b0;
                register[15] <= 32'b0;
                register[16] <= 32'b0;
                register[17] <= 32'b0;
                register[18] <= 32'b0;
                register[19] <= 32'b0;
                register[20] <= 32'b0;
                register[21] <= 32'b0;
                register[22] <= 32'b0;
                register[23] <= 32'b0;
                register[24] <= 32'b0;
                register[25] <= 32'b0;
                register[26] <= 32'b0;
                register[27] <= 32'b0;
                register[28] <= 32'b0;
                register[29] <= 32'b0;
                register[30] <= 32'b0;
                register[31] <= 32'b0;
            end

        if(RegWrite)
            begin
                register[writeReg] <= writeData;
            end

        else
            begin
                register[writeReg] <= register[writeReg];
            end
    end

endmodule