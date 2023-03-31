`timescale 1ns / 1ps
// `include "regfile.v"

module test12();
    reg[4:0] readReg1, readReg2, writeReg;
    wire[31:0] data1, data2;
    reg[31:0] writeData;

    reg RegWrite, reset = 0, clk = 0;
  

    regfile r(.readReg1(readReg1), .readReg2(readReg2), .writeReg(writeReg), .data1(data1), .data2(data2), .clk(clk), .writeData(writeData), .RegWrite(RegWrite), .reset(reset));

    initial begin
        reset = 1; #10;
        // reset = 0; #10

        writeData = 32'd69;
        writeReg = 5'b0;
        RegWrite = 1;
        #40;
        readReg1 = 5'b0;
        readReg2 = 5'd23;
        $display("data1 xx = %d data2 = %d", data1, data2);

        writeData = 32'd35;
        writeReg = 5'b1;
        RegWrite = 1; 
        #40;

        RegWrite = 0;
        readReg1 = 5'b0;
        readReg2 = 5'b1;

        $monitor("data1 = %d data2 = %d", data1, data2);

        $finish;
        
    end

    always begin
        clk = ~clk;
        #10;
    end
endmodule