`timescale 1ns / 1ps
module magnitude_func  #(parameter DATA_WIDTH = 15) 
(clk, rst, X_in, Y_in, X_out, Y_out);

input clk, rst;
(* dont_touch = "yes" *) input signed [DATA_WIDTH-1:0] X_in, Y_in;
(* dont_touch = "yes" *) output reg signed [DATA_WIDTH-1:0] X_out, Y_out;

wire signed [DATA_WIDTH-1:0] x1, x2, x3, x4, x5;
wire signed [DATA_WIDTH-1:0] y1, y2, y3, y4, y5; 
assign x1 = X_in >>> 1;
assign x2 = X_in >>> 3;
assign x3 = X_in >>> 6;
assign x4 = X_in >>> 9;
assign x5 = X_in >>> 12;

assign y1 = Y_in >>> 1;
assign y2 = Y_in >>> 3;
assign y3 = Y_in >>> 6;
assign y4 = Y_in >>> 9;
assign y5 = Y_in >>> 12;




always @(posedge clk) begin
    if (rst) begin
        X_out <= 0;
        Y_out <= 0;
    end
    else begin
        X_out <= x1 + x2 - x3 - x4 - x5;
        Y_out <= y1 + y2 - y3 - y4 - y5;
    end
end




endmodule
