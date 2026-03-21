// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Sun Jun 25 10:42:59 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/Multi_8CH32.v
// Design      : Multi_8CH32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module Multi_8CH32(clk, rst, EN, Switch, point_in, LES, data0, data1, data2, 
  data3, data4, data5, data6, data7, point_out, LE_out, Disp_num)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,Switch[2:0],point_in[63:0],LES[63:0],data0[31:0],data1[31:0],data2[31:0],data3[31:0],data4[31:0],data5[31:0],data6[31:0],data7[31:0],point_out[7:0],LE_out[7:0],Disp_num[31:0]" */;
  input clk;
  input rst;
  input EN;
  input [2:0]Switch;
  input [63:0]point_in;
  input [63:0]LES;
  input [31:0]data0;
  input [31:0]data1;
  input [31:0]data2;
  input [31:0]data3;
  input [31:0]data4;
  input [31:0]data5;
  input [31:0]data6;
  input [31:0]data7;
  output [7:0]point_out;
  output [7:0]LE_out;
  output [31:0]Disp_num;
endmodule
