`include "counter_behav.v"

module test();
    reg CLK = 0, reset = 0;
    wire[3:0] out;
    counter c(CLK, reset, out);

    always begin
        CLK = ~CLK;
        #10;
    end

    initial begin
        $monitor("count = %b%b%b%b", out[3],out[2],out[1],out[0]);
        #300;

        $finish;
    end
endmodule