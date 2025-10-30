module vector_mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg [bw-1:0] x0, x1, x2, x3;
reg [bw-1:0] w0, w1, w2, w3;
reg [psum_bw-1:0] psum_in;
wire [psum_bw-1:0] psum_out;
reg [psum_bw-1:0] expected_out = 0;

integer w_file;
integer x_file;
integer w_scan;
integer x_scan;

integer x_dec[0:3];
integer w_dec[0:3];
integer i;

// Convert signed decimal to 4-bit representation
function [3:0] w_bin;
    input integer weight;
    begin
        if (weight > -1)
            w_bin[3] = 0;
        else begin
            w_bin[3] = 1;
            weight = weight + 8;
        end

        if (weight > 3) begin
            w_bin[2] = 1;
            weight = weight - 4;
        end
        else 
            w_bin[2] = 0;

        if (weight > 1) begin
            w_bin[1] = 1;
            weight = weight - 2;
        end
        else 
            w_bin[1] = 0;

        if (weight > 0)
            w_bin[0] = 1;
        else 
            w_bin[0] = 0;
    end
endfunction

// Convert unsigned decimal to 4-bit
function [3:0] x_bin;
    input integer value;
    begin
        x_bin = value[3:0];
    end
endfunction

// Expected output calculation
function [psum_bw-1:0] vector_mac_predicted;
    input [bw-1:0] x0, x1, x2, x3;
    input [bw-1:0] w0, w1, w2, w3;
    input [psum_bw-1:0] psum_in;
    reg signed [psum_bw-1:0] x0_ext, x1_ext, x2_ext, x3_ext;
    reg signed [psum_bw-1:0] w0_ext, w1_ext, w2_ext, w3_ext;
    reg signed [psum_bw-1:0] result;
    begin
        // Zero-extend activations
        x0_ext = {{(psum_bw-bw){1'b0}}, x0};
        x1_ext = {{(psum_bw-bw){1'b0}}, x1};
        x2_ext = {{(psum_bw-bw){1'b0}}, x2};
        x3_ext = {{(psum_bw-bw){1'b0}}, x3};
        
        // Sign-extend weights
        w0_ext = {{(psum_bw-bw){w0[bw-1]}}, w0};
        w1_ext = {{(psum_bw-bw){w1[bw-1]}}, w1};
        w2_ext = {{(psum_bw-bw){w2[bw-1]}}, w2};
        w3_ext = {{(psum_bw-bw){w3[bw-1]}}, w3};
        
        result = (x0_ext * w0_ext) + (x1_ext * w1_ext) + 
                 (x2_ext * w2_ext) + (x3_ext * w3_ext) + $signed(psum_in);
        vector_mac_predicted = result;
    end
endfunction

// DUT instantiation
vector_mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) dut (
    .clk(clk),
    .psum_out(psum_out),
    .x0(x0), .x1(x1), .x2(x2), .x3(x3),
    .w0(w0), .w1(w1), .w2(w2), .w3(w3),
    .psum_in(psum_in)
);

initial begin
    w_file = $fopen("b_data.txt", "r");
    x_file = $fopen("a_data.txt", "r");

    if (w_file == 0 || x_file == 0) begin
        $display("Error: Could not open data files");
        $finish;
    end

    $dumpfile("vector_mac_tb.vcd");
    $dumpvars(0, vector_mac_tb);

    // Initialize
    psum_in = 0;
    x0 = 0; x1 = 0; x2 = 0; x3 = 0;
    w0 = 0; w1 = 0; w2 = 0; w3 = 0;

    // Initial clock cycles
    #1 clk = 1'b0;
    #1 clk = 1'b1;
    #1 clk = 1'b0;

    $display("-------------------- Computation start --------------------");
    $display("Cycle | x0  x1  x2  x3 | w0  w1  w2  w3 | psum_in | psum_out | expected | match");
    $display("------|----------------|----------------|---------|----------|----------|------");

    // Process data (assuming 10 values means 2.5 cycles, but likely means we process in groups)
    // Read 4 values at a time from each file
    for (i = 0; i < 3; i = i + 1) begin  // Adjust based on your data file
        #1 clk = 1'b1;
        #1 clk = 1'b0;

        // Read 4 activations
        x_scan = $fscanf(x_file, "%d\n", x_dec[0]);
        x_scan = $fscanf(x_file, "%d\n", x_dec[1]);
        x_scan = $fscanf(x_file, "%d\n", x_dec[2]);
        x_scan = $fscanf(x_file, "%d\n", x_dec[3]);

        // Read 4 weights
        w_scan = $fscanf(w_file, "%d\n", w_dec[0]);
        w_scan = $fscanf(w_file, "%d\n", w_dec[1]);
        w_scan = $fscanf(w_file, "%d\n", w_dec[2]);
        w_scan = $fscanf(w_file, "%d\n", w_dec[3]);

        // Convert to binary
        x0 = x_bin(x_dec[0]);
        x1 = x_bin(x_dec[1]);
        x2 = x_bin(x_dec[2]);
        x3 = x_bin(x_dec[3]);

        w0 = w_bin(w_dec[0]);
        w1 = w_bin(w_dec[1]);
        w2 = w_bin(w_dec[2]);
        w3 = w_bin(w_dec[3]);

        psum_in = expected_out;

        // Calculate expected
        expected_out = vector_mac_predicted(x0, x1, x2, x3, w0, w1, w2, w3, psum_in);

        // Wait for output (account for pipeline)
        #1 clk = 1'b1;
        #1 clk = 1'b0;

        $display("%5d | %2d %2d %2d %2d | %2d %2d %2d %2d | %7d | %8d | %8d | %s",
                 i, x0, x1, x2, x3,
                 $signed(w0), $signed(w1), $signed(w2), $signed(w3),
                 $signed(psum_in), $signed(psum_out), $signed(expected_out),
                 (psum_out === expected_out) ? "PASS" : "FAIL");
    end

    #1 clk = 1'b1;
    #1 clk = 1'b0;

    $display("-------------------- Computation completed --------------------");

    $fclose(x_file);
    $fclose(w_file);

    #10 $finish;
end

endmodule