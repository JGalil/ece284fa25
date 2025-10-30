// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a;    // unsigned activation
input  [bw-1:0] b;    // signed weight
input  [psum_bw-1:0] c; // signed psum

wire signed [2*bw:0] mult;

wire signed [psum_bw-1:0] add;

assign mult = {1'b0, a} * {{b[bw-1]}, b};
assign add = {{(psum_bw - (2*bw+1)){mult[2*bw]}}, mult};
assign out = add + c;

endmodule
