// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module vector_mac_wrapper (clk, out, a, b, cinput clk,
    output [psum_bw-1:0] psum_out,
    input  [bw-1:0] x0, x1, x2, x3,
    input  [bw-1:0] w0, w1, w2, w3,
    input  [psum_bw-1:0] psum_in
);

parameter bw = 4;
parameter psum_bw = 16;

reg [bw-1:0] x0_q, x1_q, x2_q, x3_q;
reg [bw-1:0] w0_q, w1_q, w2_q, w3_q;
reg [psum_bw-1:0] psum_in_q;

vector_mac #(.bw(bw), .psum_bw(psum_bw)) vector_mac_instance (
    .psum_out(psum_out),
    .x0(x0_q), .x1(x1_q), .x2(x2_q), .x3(x3_q),
    .w0(w0_q), .w1(w1_q), .w2(w2_q), .w3(w3_q),
    .psum_in(psum_in_q)
);

always @(posedge clk) begin
    x0_q <= x0;
    x1_q <= x1;
    x2_q <= x2;
    x3_q <= x3;
    w0_q <= w0;
    w1_q <= w1;
    w2_q <= w2;
    w3_q <= w3;
    psum_in_q <= psum_in;
end

endmodule
