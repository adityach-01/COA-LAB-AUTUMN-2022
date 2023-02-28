
// Simplified carry lookahead adder for addition by 1
module carry_lookahead_optimised(A,out);
    input[3:0] A;
    output[3:0] out;

    // These are the equations that we obtain after optimising the carry look ahead adder
    /*
    S0 = ~A0
    S1 = A1 ^ A0
    S2 = A2 ^ (A0 & A1)
    S3 = A3 ^ (A0 & A1 & A2)
    */

    not(out[0], A[0]);
    xor(out[1], A[0], A[1]);
    xor(out[2], A[2], A[0]&A[1]);
    xor(out[3], A[3], A[0]&A[1]&A[2]);

endmodule

// DFF with asynchronous reset
// When reset = 1, Q = 0 irrespective of the clock signal
module Dff(D,CLK,Q, reset);

    input D,CLK, reset;
    output Q;

    // wire can be assigned the value of a register

    reg Z = 0;
    assign Q = Z;

    // if the reset signal is set, the DFF store value is 0 irrespective of the clock signal
    always@(posedge CLK or posedge reset)
    begin
        if(reset) Z = 0;
        else Z = D;
    end

endmodule

// module for counter that uses adder and flip flops to count
// architecture design in report
module counter(CLK, dff_out, reset);
    input CLK, reset;
    output[3:0] dff_out;


    wire[3:0] sum_out;
    wire[3:0] dff_out;
    wire C;

    Dff d1(sum_out[0], CLK, dff_out[0], reset);
    Dff d2(sum_out[1], CLK, dff_out[1], reset);
    Dff d3(sum_out[2], CLK, dff_out[2], reset);
    Dff d4(sum_out[3], CLK, dff_out[3], reset);

    // optimised carry look ahead adder for addition by 1
    carry_lookahead_optimised cp(dff_out,sum_out);
    
endmodule


// Divides the clock frequency of the input clock by the value stored in the DELAY register variable
// In this case dividing factor has been kept at 5 for simulation on computer
// But for FPGA simulation, the divising factor should be 5000000.
module clock_div(clkin, clkout, reset);
    input clkin, reset;
    output reg clkout;

    reg[31:0] c = 32'd0;
    reg[31:0] DELAY = 32'd5;

    always@(posedge clkin or posedge reset)
    begin
        if(reset)
        begin
            c <= 32'd0;
            clkout = 0;
        end

        c <= c+1;

        if(c == DELAY)
        begin
            c <= 32'd0;
            clkout = ~clkout;
        end
    end

endmodule

// Final Module that takes in input from the system clock and then gives the delayed clock, which is then given to the counter
module counter_final(CLK, out, reset);
    input CLK, reset;
    output[3:0] out;

    wire delayed_clk;
    clock_div ckldiv(CLK, delayed_clk, reset);
    counter c(delayed_clk, out, reset);
endmodule
