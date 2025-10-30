module vector_mac(output [psum_bw-1:0] psum_out,
    input  [bw-1:0] x0, x1, x2, x3,
    input  [bw-1:0] w0, w1, w2, w3,
    input  [psum_bw-1:0] psum_in);

    //params
    parameter bw = 4;
    parameter psum_bw = 16;

    wire signed [psum_bw-1:0] prod0, prod1, prod2, prod3; //products

    //4 mac modules
    mac #(.bw(bw), .psum_bw(psum_bw)) mac0 (.out(prod0), .a(x0), .b(w0), .c({psum_bw{1'b0}}));
    mac #(.bw(bw), .psum_bw(psum_bw)) mac1 (.out(prod1), .a(x1), .b(w1), .c({psum_bw{1'b0}}));
    mac #(.bw(bw), .psum_bw(psum_bw)) mac2 (.out(prod2), .a(x2), .b(w2), .c({psum_bw{1'b0}}));
    mac #(.bw(bw), .psum_bw(psum_bw)) mac3 (.out(prod3), .a(x3), .b(w3), .c({psum_bw{1'b0}}));

    //sum
    wire signed [psum_bw-1:0] sum01, sum23;
    assign sum01 = $signed(prod0) + $signed(prod1);
    assign sum23 = $signed(prod2) + $signed(prod3);

    //accumulate
    assign psum_out = sum01 + sum23 + $signed(psum_in);

endmodule