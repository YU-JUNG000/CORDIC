`timescale 1ns / 1ps
module stage #(parameter DATA_WIDTH = 15) 
(clk, rst, i_th,  X_in, Y_in, X_out, Y_out, theta_acc_in, theta_rotate, theta_acc_out);

input clk, rst;
(* dont_touch = "yes" *) input signed [DATA_WIDTH-1:0] X_in, Y_in;
input signed [DATA_WIDTH-1:0] theta_acc_in;
input [3:0] i_th;
input signed [DATA_WIDTH-1:0] theta_rotate;
(* dont_touch = "yes" *) output reg signed [DATA_WIDTH-1:0] X_out, Y_out;
output reg signed [DATA_WIDTH-1:0] theta_acc_out;

wire signed [DATA_WIDTH:0] X_sft;
wire signed [DATA_WIDTH:0] Y_sft;
assign X_sft = X_in >>> i_th;
assign Y_sft = Y_in >>> i_th;

always @(posedge clk) begin
    if (rst) begin
        X_out <= 0;
        Y_out <= 0;
        theta_acc_out <= 0;
    end
    else begin
        if (X_in != 0) begin
            if (Y_in < 0) begin
                X_out <= X_in - Y_sft;
                Y_out <= Y_in + X_sft;
                theta_acc_out <= theta_acc_in + theta_rotate;       
            end
            else begin
                X_out <= X_in + Y_sft;
                Y_out <= Y_in - X_sft; 
                theta_acc_out <= theta_acc_in - theta_rotate;    
            end
        end
    end
end




endmodule
