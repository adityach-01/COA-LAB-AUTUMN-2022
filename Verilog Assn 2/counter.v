`timescale 1ns/1ns

module tffx(T,clk,Q);
    input T,clk;
    output Q;

    reg Z = 0;
    assign Q = Z;

    always@(negedge clk)
    begin
        if(T == 0) Z = Q;
        else Z = ~Q;
    end

endmodule

module bitcounter(clk, out);
    input clk;
    output[3:0] out;

    // out[0] is the LSB and out[3] is the MSB of te counter

    tffx t1(1'b1,clk,out[0]);
    tffx t2(1'b1, out[0], out[1]);
    tffx t3(1'b1, out[1], out[2]);
    tffx t4(1'b1, out[2], out[3]);

endmodule

module test();
    wire[3:0] out;
    reg clk = 1;
    bitcounter x(clk,out);

    always begin
        clk = ~clk;
        #5;
    end

    initial begin
        $monitor("counter val = %b%b%b%b", out[3], out[2], out[1], out[0]);
        #200;
        $finish;
    end

endmodule

// General tips :
// Do not use variable data types in input and output in a module, use it when absolute necessary
// Register cannot be assigned a wire value, but a wire can be assigneed a register value. Can be equated but no continuous assignment
// In test bench, inputs are going to be registers but output can be register or wire, wire in more number of cases.
