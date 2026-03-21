// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Wed Dec 11 17:02:18 2024
// Host        : WIN-T6A1S95DRJ2 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Documents/VivadoRepo/riscv/riscv.srcs/sources_1/ip/dist_mem_im/dist_mem_im_stub.v
// Design      : dist_mem_im
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *)
module dist_mem_im(a, spo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],spo[31:0]" */;
  input [3:0]a;
  output [31:0]spo;
endmodule
