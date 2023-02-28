`timescale 1ns / 1ps
// `include "smallckt.v"

module test();
    reg[4:0] r1,r2,ALUc = 5'b0;
    reg regw = 0,clk=0,reset=0,memw=0,memr=0;
    wire[31:0] dout;

    circuit c(r1,r2,regw,clk,reset,ALUc,memw,memr,dout);

    initial begin
        reset = 1; #5;
        reset = 0; #5;
        r1 = 5'b0;
        r2 = 5'b1;
        regw = 0;
        memr = 1;
        #10;
        $display("dataout = %d",dout);

        regw = 1;

        /*<---- STEP 2 ---> */
        // Had to introduce a delay ??
        #10;
        regw = 0;
        $display("dataout = %d",dout);
        #10;

        #20;
        regw = 1;
        #1;
        regw = 0;
        $display("dataout = %d",dout);

        $finish;
    end

    always begin
        #20
        clk = ~clk;
    end
endmodule

// components working fine but problems are being faced in timing.
// Do not know how to deal with clock and control signal changing at the same time ??
// How to accomodate these issues in the original design ??