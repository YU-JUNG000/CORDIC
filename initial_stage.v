`timescale 1ns / 1ps
module initial_stage #(parameter DATA_WIDTH = 15) 
(clk, rst,  X_in, Y_in, X_out, Y_out, theta_out);

input clk, rst;
(* dont_touch = "yes" *) input signed [DATA_WIDTH-1:0] X_in, Y_in;
(* dont_touch = "yes" *) output reg signed [DATA_WIDTH-1:0] X_out, Y_out;
output reg signed [DATA_WIDTH-1:0] theta_out;

always @(posedge clk) begin
    if (rst) begin
        X_out <= 0;
        Y_out <= 0;
        theta_out <= 0;
    end
    else begin
        Y_out <= Y_in;
        theta_out <= 0;
        if (X_in[DATA_WIDTH-1])
            X_out <= ~X_in + 1'b1;
        else
            X_out <= X_in;
    end
end

endmodule

// 我今天很開心! 我叫陳於容
