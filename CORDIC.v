`timescale 1ns / 1ps
module CORDIC #(parameter DATA_WIDTH = 15)
(clk, rst, in_X, in_Y, out_X_1, out_X_2, out_Y_1, out_Y_2, out_theta);
input clk, rst;
input [DATA_WIDTH-1:0] in_X, in_Y;
output [DATA_WIDTH-1:0] out_X_1, out_X_2, out_Y_1, out_Y_2;
output [DATA_WIDTH-1:0] out_theta;

wire [DATA_WIDTH-1:0] in_X0, in_X1, in_X2, in_X3, in_X4, in_X5, in_X6, in_X7, in_X8, in_X9, in_X10, in_X11;
(* dont_touch = "yes" *) wire [DATA_WIDTH-1:0] in_X12, in_Y12;
wire [DATA_WIDTH-1:0] in_Y0, in_Y1, in_Y2, in_Y3, in_Y4, in_Y5, in_Y6, in_Y7, in_Y8, in_Y9, in_Y10, in_Y11;
(* dont_touch = "yes" *) wire [DATA_WIDTH-1:0] in_th0, in_th1, in_th2, in_th3, in_th4, in_th5, in_th6, in_th7, in_th8, in_th9, in_th10, in_th11;



initial_stage initial_stage(.clk(clk), .rst(rst), .X_in(in_X), .Y_in(in_Y), .X_out(in_X0), .Y_out(in_Y0), .theta_out(in_th0));
stage stage_00(.clk(clk), .rst(rst), .i_th(0),  .X_in(in_X0),  .Y_in(in_Y0),  .X_out(in_X1),  .Y_out(in_Y1),  .theta_acc_in(in_th0),  .theta_rotate(3217), .theta_acc_out(in_th1));
stage stage_01(.clk(clk), .rst(rst), .i_th(1),  .X_in(in_X1),  .Y_in(in_Y1),  .X_out(in_X2),  .Y_out(in_Y2),  .theta_acc_in(in_th1),  .theta_rotate(1899), .theta_acc_out(in_th2));
stage stage_02(.clk(clk), .rst(rst), .i_th(2),  .X_in(in_X2),  .Y_in(in_Y2),  .X_out(in_X3),  .Y_out(in_Y3),  .theta_acc_in(in_th2),  .theta_rotate(1003), .theta_acc_out(in_th3));
stage stage_03(.clk(clk), .rst(rst), .i_th(3),  .X_in(in_X3),  .Y_in(in_Y3),  .X_out(in_X4),  .Y_out(in_Y4),  .theta_acc_in(in_th3),  .theta_rotate(509),  .theta_acc_out(in_th4));
stage stage_04(.clk(clk), .rst(rst), .i_th(4),  .X_in(in_X4),  .Y_in(in_Y4),  .X_out(in_X5),  .Y_out(in_Y5),  .theta_acc_in(in_th4),  .theta_rotate(256),  .theta_acc_out(in_th5));
stage stage_05(.clk(clk), .rst(rst), .i_th(5),  .X_in(in_X5),  .Y_in(in_Y5),  .X_out(in_X6),  .Y_out(in_Y6),  .theta_acc_in(in_th5),  .theta_rotate(128),  .theta_acc_out(in_th6));
stage stage_06(.clk(clk), .rst(rst), .i_th(6),  .X_in(in_X6),  .Y_in(in_Y6),  .X_out(in_X7),  .Y_out(in_Y7),  .theta_acc_in(in_th6),  .theta_rotate(64),   .theta_acc_out(in_th7));
stage stage_07(.clk(clk), .rst(rst), .i_th(7),  .X_in(in_X7),  .Y_in(in_Y7),  .X_out(in_X8),  .Y_out(in_Y8),  .theta_acc_in(in_th7),  .theta_rotate(32),   .theta_acc_out(in_th8));
stage stage_08(.clk(clk), .rst(rst), .i_th(8),  .X_in(in_X8),  .Y_in(in_Y8),  .X_out(in_X9),  .Y_out(in_Y9),  .theta_acc_in(in_th8),  .theta_rotate(16),   .theta_acc_out(in_th9));
stage stage_09(.clk(clk), .rst(rst), .i_th(9),  .X_in(in_X9),  .Y_in(in_Y9),  .X_out(in_X10), .Y_out(in_Y10), .theta_acc_in(in_th9),  .theta_rotate(8),    .theta_acc_out(in_th10));
stage stage_10(.clk(clk), .rst(rst), .i_th(10), .X_in(in_X10), .Y_in(in_Y10), .X_out(in_X11), .Y_out(in_Y11), .theta_acc_in(in_th10), .theta_rotate(4),    .theta_acc_out(in_th11));
stage stage_11(.clk(clk), .rst(rst), .i_th(11), .X_in(in_X11), .Y_in(in_Y11), .X_out(out_X_1), .Y_out(out_Y_1), .theta_acc_in(in_th11), .theta_rotate(2),    .theta_acc_out(out_theta));

magnitude_func mag_func(.clk(clk), .rst(rst), .X_in(out_X_1), .Y_in(out_Y_1), .X_out(out_X_2), .Y_out(out_Y_2));


endmodule

// 15bits for radium : 1 signed-bits, 2 for integers, 12-bits for fraction
// 12 times micro-rotation