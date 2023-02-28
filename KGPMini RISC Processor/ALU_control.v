`timescale 1ns / 1ps

module ALU_control(ALUop,funct,out);
    input wire[2:0] ALUop;
    input wire[5:0] funct;
    output wire[4:0] out;

    reg [4:0] controls;
    assign out = controls;
    always@*
        casex({ALUop,funct})
            9'b000xxxxxx :  controls <= 5'b00000; // Non arithmetic op
            9'b001xxxxxx :  controls <= 5'b00011; // shift left logical
            9'b010xxxxxx :  controls <= 5'b00111; // shift right logical
            9'b011xxxxxx :  controls <= 5'b01111; // shift right arithmetic
            9'b100xxxxxx :  controls <= 5'b01100; // complement immidiate
            9'b101xxxxxx :  controls <= 5'b10000; // for beq instruction
            9'b111000001 :  controls <= 5'b00000; // add rs,rt
            9'b111000010 :  controls <= 5'b01100; // comp rs,rt
            9'b111000011 :  controls <= 5'b00001; // and rs,rt
            9'b111000100 :  controls <= 5'b00010; // xor rs,rt
            9'b111000101 :  controls <= 5'b10000; // diff rs,rt
            9'b111000110 :  controls <= 5'b00011; // shllv rs,rt
            9'b111000111 :  controls <= 5'b00111; // shrl rs,rt
            9'b111001000 :  controls <= 5'b01111; // shrav rs,rt
            default:  controls <= 5'b00000; // any other op
        endcase

endmodule