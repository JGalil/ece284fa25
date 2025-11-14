// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  wire [psum_bw*col*(row+1)-1:0] psum_temp;

  wire [col*(row+1)-1:0] valid_temp;

  wire [2*(row+1)-1:0] inst_temp;

  assign psum_temp[psum_bw*col-1:0] = in_n;

  genvar i;

  generate;
    for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
        .clk(clk),
        .reset(reset),
        .in_w(in_w[bw*i-1:bw*(i-1)]),
        .inst_w(inst_w[2*i-1:2*(i-1)]),
        .in_n(psum_temp[psum_bw*col*i-1: psum_bw*col*(i-1)]),
        .out_s(psum_temp[psum_bw*co*(i+1)-1:psum_bw*col*i]),
        .valid(valid_temp[col*i-1:col*(i-1)])
      );
    end
  endgenerate

  

  assign out_s = psum_temp[psum_bw*col*(row+1)-1:psum_bw*col*row];
  assign valid = valid_temp[col*(row+1)-1:col*row];

  always @ (posedge clk) begin
    if(reset) begin
      inst_temp <= 0;
    end
    else begin
      inst_temp[1:0] <= inst_w;
      for(j = 1; j < row+1; j = j+1) begin
        inst_temp[2*(j+1)-1:2*j] <= inst_temp[2*j-1:2*j];
      end
    end
  end



endmodule
