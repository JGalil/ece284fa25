// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, x0, x1, x2, x3, w0, w1, w2, w3, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] x0, x1, x2, x3;
input  [bw-1:0] w0, w1, w2, w3;
input  [psum_bw-1:0] c;
input  clk;

reg    [bw-1:0] x0_q;
reg    [bw-1:0] x1_q;
reg    [bw-1:0] x2_q;
reg    [bw-1:0] x3_q;
reg    [bw-1:0] w0_q;
reg    [bw-1:0] w1_q;
reg    [bw-1:0] w2_q;
reg    [bw-1:0] w3_q;
reg    [psum_bw-1:0] c_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .x0(x0_q),
        .x1(x1_q),
        .x2(x2_q),
        .x3(x3_q),
        .w0(w0_q),
        .w1(w1_q),
        .w2(w2_q),
        .w3(w3_q),
        .c(c_q),
	.out(out)
); 

always @ (posedge clk) begin
        x0 <= x0_q;
        x1 <= x1_q;
        x2 <= x2_q;
        x3 <= x3_q;
        w0 <= w0_q;
        w1 <= w1_q;
        w2 <= w2_q;
        w3 <= w3_q;
end

endmodule
