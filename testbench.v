`timescale 1ns / 1ps

`define CYCLE 5

module testbench #(parameter DATA_WIDTH = 15) ();
reg clk, rst;
reg [DATA_WIDTH-1:0] in_X, in_Y;
wire [DATA_WIDTH-1:0] out_X_1, out_X_2, out_Y_1, out_Y_2;
wire [DATA_WIDTH-1:0] out_theta;

CORDIC CORDIC(.clk(clk), .rst(rst), .in_X(in_X), .in_Y(in_Y), .out_X_1(out_X_1), .out_X_2(out_X_2), .out_Y_1(out_Y_1), .out_Y_2(out_Y_2), .out_theta(out_theta));

initial begin
    clk = 1'b0;     rst = 1'b0;
    #(`CYCLE/2.5)   rst = 1'b1;
    #(`CYCLE*20);
    #(`CYCLE/5)     rst = 1'b0;
    #(`CYCLE/2.5)   in_X = 4060;       in_Y = 536;
    #(`CYCLE*2)     in_X = 3248;       in_Y = 2492;
    #(`CYCLE*2)     in_X = 1568;       in_Y = 3784;
    #(`CYCLE*2)     in_X = -536;       in_Y = 4060;
    #(`CYCLE*2)     in_X = -2492;      in_Y = 3248;
    #(`CYCLE*2)     in_X = -3784;      in_Y = 1568;
    #(`CYCLE*2)     in_X = -4060;      in_Y = -536;
    #(`CYCLE*2)     in_X = -3248;      in_Y = -2492;
    #(`CYCLE*2)     in_X = 1568;       in_Y = -3784;
    #(`CYCLE*2)     in_X = 536;        in_Y = -4060;
    #(`CYCLE*2)     in_X = 2492;       in_Y = -3248;
    #(`CYCLE*2)     in_X = 3784;       in_Y = -1568;
    #(`CYCLE*2)     in_X = 0;          in_Y = 0;
    #(`CYCLE*28)    $finish;
end

always #(`CYCLE) clk=~clk;

endmodule
