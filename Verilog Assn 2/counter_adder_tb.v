`include "counter_adder.v"

module test();

    reg CLK = 0, reset = 1;
    wire[3:0] out;
    counter_final c(CLK, out, reset);

    always begin
        CLK = ~CLK;
        #10;
    end

    initial begin
        $monitor("count = %b%b%b%b", out[3],out[2],out[1],out[0]);

        // resetting the counter
        reset = 1;
        #5;
        reset = 0;
        #2000
        
        $finish;
    end

endmodule