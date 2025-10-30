module vector_mac(output [psum_bw-1:0] psum_out,
    input  [bw-1:0] x0, x1, x2, x3,
    input  [bw-1:0] w0, w1, w2, w3,
    input  [psum_bw-1:0] psum_in);

    //params
    parameter bw = 4;
    parameter psum_bw = 16;

    
    wire [psum_bw-1:0] x0_ext_unsigned = {{(psum_bw-bw){1'b0}}, x0};
    wire [psum_bw-1:0] x1_ext_unsigned = {{(psum_bw-bw){1'b0}}, x1};
    wire [psum_bw-1:0] x2_ext_unsigned = {{(psum_bw-bw){1'b0}}, x2};
    wire [psum_bw-1:0] x3_ext_unsigned = {{(psum_bw-bw){1'b0}}, x3};

    wire signed [psum_bw-1:0] x0_ext = $signed(x0_ext_unsigned);
    wire signed [psum_bw-1:0] x1_ext = $signed(x1_ext_unsigned);
    wire signed [psum_bw-1:0] x2_ext = $signed(x2_ext_unsigned);
    wire signed [psum_bw-1:0] x3_ext = $signed(x3_ext_unsigned);

    // Sign-extend w0-w3 (signed weights) to psum_bw
    wire signed [psum_bw-1:0] w0_ext = {{(psum_bw-bw){w0[bw-1]}}, w0};
    wire signed [psum_bw-1:0] w1_ext = {{(psum_bw-bw){w1[bw-1]}}, w1};
    wire signed [psum_bw-1:0] w2_ext = {{(psum_bw-bw){w2[bw-1]}}, w2};
    wire signed [psum_bw-1:0] w3_ext = {{(psum_bw-bw){w3[bw-1]}}, w3};

    // Calculate 4 products
    wire signed [psum_bw-1:0] prod0 = x0_ext * w0_ext;
    wire signed [psum_bw-1:0] prod1 = x1_ext * w1_ext;
    wire signed [psum_bw-1:0] prod2 = x2_ext * w2_ext;
    wire signed [psum_bw-1:0] prod3 = x3_ext * w3_ext;

    // Tree addition
    wire signed [psum_bw-1:0] sum01 = prod0 + prod1;
    wire signed [psum_bw-1:0] sum23 = prod2 + prod3;

    // Final accumulation: (x0*w0 + x1*w1 + x2*w2 + x3*w3) + psum_in
    assign psum_out = sum01 + sum23 + $signed(psum_in);

endmodule