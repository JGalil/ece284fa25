// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] x0;
reg  [bw-1:0] x1;
reg  [bw-1:0] x2;
reg  [bw-1:0] x3;
reg  [bw-1:0] w0;
reg  [bw-1:0] w1;
reg  [bw-1:0] w2;
reg  [bw-1:0] w3;
reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x0_dec;
integer x1_dec;
integer x2_dec;
integer x3_dec;
integer w0_dec;
integer w1_dec;
integer w2_dec;
integer w3_dec;



integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0)
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
  input integer weight;
  begin
    x_bin = weight[3:0];
  end
endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;

    input [bw-1:0] x0;
    input [bw-1:0] x1;
    input [bw-1:0] x2;
    input [bw-1:0] x3;
    input [bw-1:0] w0;
    input [bw-1:0] w1;
    input [bw-1:0] w2;
    input [bw-1:0] w3;
    input [psum_bw-1:0] c;
    reg signed [psum_bw-1:0] x0e;
    reg signed [psum_bw-1:0] x1e;
    reg signed [psum_bw-1:0] x2e;
    reg signed [psum_bw-1:0] x3e;
    reg signed [psum_bw-1:0] w0e;
    reg signed [psum_bw-1:0] w1e;
    reg signed [psum_bw-1:0] w2e;
    reg signed [psum_bw-1:0] w3e;
    reg signed [psum_bw-1:0] result;
    begin

        x0e = {{(psum_bw-bw){1'b0}}, x0};
        x1e = {{(psum_bw-bw){1'b0}}, x1};
        x2e = {{(psum_bw-bw){1'b0}}, x2};
        x3e = {{(psum_bw-bw){1'b0}}, x3};
        
        
        w0e = {{(psum_bw-bw){w0[bw-1]}}, w0};
        w1e = {{(psum_bw-bw){w1[bw-1]}}, w1};
        w2e = {{(psum_bw-bw){w2[bw-1]}}, w2};
        w3e = {{(psum_bw-bw){w3[bw-1]}}, w3};
        
        result = (x0e * w0e) + (x1e * w1e) + (x2e * w2e) + (x3e * w3e) + $signed(c);
        mac_predicted = result;
    end

endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	      .clk(clk),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .w0(w0),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .c(c),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);

     x0 = x_bin(x0_dec); // unsigned number
     x1 = x_bin(x1_dec);
     x2 = x_bin(x2_dec);
     x3 = x_bin(x3_dec);
     w0 = w_bin(w0_dec); // signed number
     w1 = w_bin(w1_dec);
     w2 = w_bin(w2_dec);
     w3 = w_bin(w3_dec);
     c = expected_out;
     expected_out = mac_predicted(x0, x1, x2, x3, w0, w1, w2, w3, c);
     

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




