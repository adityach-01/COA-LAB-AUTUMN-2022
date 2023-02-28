// Behavioral design of a counter
module counter(CLK, reset, out);
    input CLK, reset;
    output[3:0] out;

    reg[3:0] cnt = 4'b0;

    always@(posedge CLK or posedge reset)
    begin
        if(reset) cnt <= 0;
        else cnt <= cnt + 1;
    end

    assign out = cnt;

endmodule


