// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac (out, x0, x1, x2, x3, w0, w1, w2, w3, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] x0, x1, x2, x3; // unsigned activation
input  [bw-1:0] w0, w1, w2, w3;    // signed weight
input  [psum_bw-1:0] c; // signed psum

wire [bw-1:0] x0_us = x0, x1_us = x1, x2_us = x2, x3_us = x3;
wire signed [bw-1:0] w0_s = w0, w1_s = w1, w2_s = w2, w3_s = w3;

wire signed [2*bw-1:0] p0 = $signed(x0) * $signed({1'b0, w0});
wire signed [2*bw-1:0] prod0 = p0[2*bw-1:0];

wire signed [2*bw-1:0] p1 = $signed(x1) * $signed({1'b0, w1});
wire signed [2*bw-1:0] prod1 = p1[2*bw-1:0];

wire signed [2*bw-1:0] p2 = $signed(x2) * $signed({1'b0, w2});
wire signed [2*bw-1:0] prod2 = p2[2*bw-1:0];

wire signed [2*bw-1:0] p3 = $signed(x3) * $signed({1'b0, w3});
wire signed [2*bw-1:0] prod3 = p3[2*bw-1:0];

wire signed [2*bw:0] sum01 = prod0 + prod1;
wire signed [2*bw:0] sum23 = prod2 + prod3;
wire signed [psum_bw-1:0] sum = sum01 + sum23;

assign out = sum + c;

endmodule
