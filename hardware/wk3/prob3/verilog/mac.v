// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a;    // unsigned activation
input  [bw-1:0] b;    // signed weight
input  [psum_bw-1:0] c; // signed psum

wire signed [psum_bw-1:0] a_ext = {{(psum_bw-bw-1){1'b0}}, a};     // Zero extend
wire signed [psum_bw-1:0] b_ext = {{(psum_bw-bw-1){b[bw-1]}}, b};  // Sign extend

assign out = (a_ext * b_ext) + c;

endmodule
