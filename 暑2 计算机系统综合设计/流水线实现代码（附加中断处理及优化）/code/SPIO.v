// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Jun 20 18:40:00 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/SPIO.v
// Design      : SPIO
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module SPIO(clk, rst, EN, P_Data, counter_set, LED_out, led, 
  GPIOf0)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,P_Data[31:0],counter_set[1:0],LED_out[15:0],led[15:0],GPIOf0[13:0]" */;
  input clk;
  input rst;
  input EN;
  input [31:0]P_Data;
  output [1:0]counter_set;
  output [15:0]LED_out;
  output [15:0]led;
  output [13:0]GPIOf0;
endmodule
