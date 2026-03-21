// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Sun Jun 25 15:02:33 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/SSeg7.v
// Design      : SSeg7
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module SSeg7(clk, rst, SW0, flash, Hexs, point, LES, seg_an, seg_sout)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,SW0,flash,Hexs[31:0],point[7:0],LES[7:0],seg_an[7:0],seg_sout[7:0]" */;
  input clk;
  input rst;
  input SW0;
  input flash;
  input [31:0]Hexs;
  input [7:0]point;
  input [7:0]LES;
  output [7:0]seg_an;
  output [7:0]seg_sout;
endmodule
