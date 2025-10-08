// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

wire a_sign = a_q[bw-1];
wire b_sign = b_q[bw-1];
wire [bw-2:0] a_mag = a_q[bw-2:0];
wire [bw-2:0] b_mag = b_q[bw-2:0];
wire [psum_bw-2:0] psum_mag = psum_q[psum_bw-2:0];
wire psum_sign = psum_q[psum_bw-1];

wire prod_sign = a_sign ^ b_sign;
wire [psum_bw-2:0] prod_mag = a_mag * b_mag;

assign out = psum_q;

// Your code goes here
always @(posedge clk or negedge reset) begin
    if(!reset) begin
        a_q <= 0;
        b_q <= 0;
        psum_q <= 0;
    end
    else begin
        a_q <= A;
        b_q <= B;
        if(acc == 1) begin
            if(format == 0) begin
                psum_q <= psum_q + (a_q * b_q);
            end
            else begin
                if(psum_sign == prod_sign) begin
                    psum_q <= {psum_sign, (psum_mag + prod_mag)};
                end
                else begin
                    if (psum_mag >= prod_mag) begin
                        psum_q <= {psum_sign, (psum_mag - prod_mag)};
                    end else begin
                        psum_q <= {prod_sign, (prod_mag - psum_mag)};
                    end
                end
            end
        end
    end
end


endmodule
