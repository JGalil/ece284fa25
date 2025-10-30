// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a;    // unsigned activation
input  [bw-1:0] b;    // signed weight
input  [psum_bw-1:0] c; // signed psum

wire [psum_bw-1:0] a_ext_unsigned = {{(psum_bw-bw){1'b0}}, a};
wire signed [psum_bw-1:0] a_ext = $signed(a_ext_unsigned);

// Sign-extend 'b'
wire signed [psum_bw-1:0] b_ext = {{(psum_bw-bw){b[bw-1]}}, b};

assign out = $signed(a_ext * b_ext) + c;

endmodule
