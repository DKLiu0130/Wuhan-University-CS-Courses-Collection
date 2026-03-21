// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Dec  9 18:58:58 2024
// Host        : WIN-T6A1S95DRJ2 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               D:/Documents/VivadoRepo/riscv/riscv.sim/sim_1/synth/func/xsim/riscv_func_synth.v
// Design      : riscv
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module addr_controller
   (Q,
    sw_i_IBUF,
    clk_used_BUFG,
    \data_out_reg[0]_0 );
  output [4:0]Q;
  input [0:0]sw_i_IBUF;
  input clk_used_BUFG;
  input \data_out_reg[0]_0 ;

  wire [4:0]Q;
  wire clk_used_BUFG;
  wire \data_out[0]_i_1__0_n_0 ;
  wire \data_out[4]_i_1_n_0 ;
  wire \data_out_reg[0]_0 ;
  wire [4:1]p_1_in;
  wire [0:0]sw_i_IBUF;

  LUT1 #(
    .INIT(2'h1)) 
    \data_out[0]_i_1__0 
       (.I0(Q[0]),
        .O(\data_out[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \data_out[1]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(p_1_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \data_out[2]_i_1 
       (.I0(Q[2]),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(p_1_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \data_out[3]_i_1 
       (.I0(Q[3]),
        .I1(Q[2]),
        .I2(Q[1]),
        .I3(Q[0]),
        .O(p_1_in[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \data_out[4]_i_1 
       (.I0(sw_i_IBUF),
        .O(\data_out[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \data_out[4]_i_2 
       (.I0(Q[4]),
        .I1(Q[3]),
        .I2(Q[2]),
        .I3(Q[1]),
        .I4(Q[0]),
        .O(p_1_in[4]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[0] 
       (.C(clk_used_BUFG),
        .CE(\data_out[4]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[0]_i_1__0_n_0 ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[1] 
       (.C(clk_used_BUFG),
        .CE(\data_out[4]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(p_1_in[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[2] 
       (.C(clk_used_BUFG),
        .CE(\data_out[4]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(p_1_in[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[3] 
       (.C(clk_used_BUFG),
        .CE(\data_out[4]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(p_1_in[3]),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[4] 
       (.C(clk_used_BUFG),
        .CE(\data_out[4]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(p_1_in[4]),
        .Q(Q[4]));
endmodule

(* ORIG_REF_NAME = "addr_controller" *) 
module addr_controller__parameterized0
   (\data_out_reg[1]_0 ,
    \selector_reg[0] ,
    \data_out_reg[1]_1 ,
    \data_out_reg[2]_0 ,
    \data_out_reg[2]_1 ,
    \data_out_reg[2]_2 ,
    sw_i_IBUF,
    \disp_seg_o_OBUF[6]_inst_i_3 ,
    Q,
    \disp_seg_o_OBUF[6]_inst_i_3_0 ,
    \disp_seg_o_OBUF[6]_inst_i_3_1 ,
    \disp_seg_o_OBUF[6]_inst_i_7_0 ,
    \disp_seg_o_OBUF[6]_inst_i_7_1 ,
    clk_used_BUFG,
    \data_out_reg[0]_0 );
  output \data_out_reg[1]_0 ;
  output \selector_reg[0] ;
  output \data_out_reg[1]_1 ;
  output \data_out_reg[2]_0 ;
  output \data_out_reg[2]_1 ;
  output \data_out_reg[2]_2 ;
  input [1:0]sw_i_IBUF;
  input \disp_seg_o_OBUF[6]_inst_i_3 ;
  input [0:0]Q;
  input \disp_seg_o_OBUF[6]_inst_i_3_0 ;
  input \disp_seg_o_OBUF[6]_inst_i_3_1 ;
  input [4:0]\disp_seg_o_OBUF[6]_inst_i_7_0 ;
  input [4:0]\disp_seg_o_OBUF[6]_inst_i_7_1 ;
  input clk_used_BUFG;
  input \data_out_reg[0]_0 ;

  wire [0:0]Q;
  wire clk_used_BUFG;
  wire \data_out[0]_i_1_n_0 ;
  wire \data_out[1]_i_1_n_0 ;
  wire \data_out[2]_i_1_n_0 ;
  wire \data_out[2]_i_2_n_0 ;
  wire \data_out_reg[0]_0 ;
  wire \data_out_reg[1]_0 ;
  wire \data_out_reg[1]_1 ;
  wire \data_out_reg[2]_0 ;
  wire \data_out_reg[2]_1 ;
  wire \data_out_reg[2]_2 ;
  wire \data_out_reg_n_0_[0] ;
  wire \data_out_reg_n_0_[1] ;
  wire \data_out_reg_n_0_[2] ;
  wire \disp_seg_o_OBUF[6]_inst_i_23_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_25_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_3 ;
  wire \disp_seg_o_OBUF[6]_inst_i_3_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_3_1 ;
  wire [4:0]\disp_seg_o_OBUF[6]_inst_i_7_0 ;
  wire [4:0]\disp_seg_o_OBUF[6]_inst_i_7_1 ;
  wire \selector_reg[0] ;
  wire [1:0]sw_i_IBUF;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h0D)) 
    \data_out[0]_i_1 
       (.I0(\data_out_reg_n_0_[2] ),
        .I1(\data_out_reg_n_0_[1] ),
        .I2(\data_out_reg_n_0_[0] ),
        .O(\data_out[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \data_out[1]_i_1 
       (.I0(\data_out_reg_n_0_[1] ),
        .I1(\data_out_reg_n_0_[0] ),
        .O(\data_out[1]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \data_out[2]_i_1 
       (.I0(sw_i_IBUF[0]),
        .O(\data_out[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h68)) 
    \data_out[2]_i_2 
       (.I0(\data_out_reg_n_0_[2] ),
        .I1(\data_out_reg_n_0_[1] ),
        .I2(\data_out_reg_n_0_[0] ),
        .O(\data_out[2]_i_2_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[0] 
       (.C(clk_used_BUFG),
        .CE(\data_out[2]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[0]_i_1_n_0 ),
        .Q(\data_out_reg_n_0_[0] ));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[1] 
       (.C(clk_used_BUFG),
        .CE(\data_out[2]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[1]_i_1_n_0 ),
        .Q(\data_out_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[2] 
       (.C(clk_used_BUFG),
        .CE(\data_out[2]_i_1_n_0 ),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[2]_i_2_n_0 ),
        .Q(\data_out_reg_n_0_[2] ));
  LUT6 #(
    .INIT(64'h5555555545444555)) 
    \disp_seg_o_OBUF[5]_inst_i_7 
       (.I0(\data_out_reg_n_0_[2] ),
        .I1(Q),
        .I2(\disp_seg_o_OBUF[6]_inst_i_7_1 [2]),
        .I3(\data_out_reg_n_0_[0] ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_7_0 [2]),
        .I5(\data_out_reg_n_0_[1] ),
        .O(\data_out_reg[2]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0020)) 
    \disp_seg_o_OBUF[6]_inst_i_12 
       (.I0(sw_i_IBUF[1]),
        .I1(\data_out_reg_n_0_[1] ),
        .I2(\data_out_reg_n_0_[2] ),
        .I3(\data_out_reg_n_0_[0] ),
        .O(\data_out_reg[1]_1 ));
  LUT6 #(
    .INIT(64'hAAAAAAAA0000A808)) 
    \disp_seg_o_OBUF[6]_inst_i_23 
       (.I0(sw_i_IBUF[1]),
        .I1(\disp_seg_o_OBUF[6]_inst_i_7_0 [4]),
        .I2(\data_out_reg_n_0_[0] ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_7_1 [4]),
        .I4(\data_out_reg_n_0_[1] ),
        .I5(\data_out_reg_n_0_[2] ),
        .O(\disp_seg_o_OBUF[6]_inst_i_23_n_0 ));
  LUT6 #(
    .INIT(64'h00001A1FFFFFFFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_25 
       (.I0(\data_out_reg_n_0_[1] ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_7_1 [0]),
        .I2(\data_out_reg_n_0_[0] ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_7_0 [0]),
        .I4(\data_out_reg_n_0_[2] ),
        .I5(sw_i_IBUF[1]),
        .O(\disp_seg_o_OBUF[6]_inst_i_25_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFBF)) 
    \disp_seg_o_OBUF[6]_inst_i_31 
       (.I0(\data_out_reg_n_0_[1] ),
        .I1(\data_out_reg_n_0_[2] ),
        .I2(sw_i_IBUF[1]),
        .I3(\data_out_reg_n_0_[0] ),
        .O(\data_out_reg[1]_0 ));
  LUT6 #(
    .INIT(64'h5555555545444555)) 
    \disp_seg_o_OBUF[6]_inst_i_45 
       (.I0(\data_out_reg_n_0_[2] ),
        .I1(Q),
        .I2(\disp_seg_o_OBUF[6]_inst_i_7_1 [1]),
        .I3(\data_out_reg_n_0_[0] ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_7_0 [1]),
        .I5(\data_out_reg_n_0_[1] ),
        .O(\data_out_reg[2]_0 ));
  LUT6 #(
    .INIT(64'h5555555545444555)) 
    \disp_seg_o_OBUF[6]_inst_i_53 
       (.I0(\data_out_reg_n_0_[2] ),
        .I1(Q),
        .I2(\disp_seg_o_OBUF[6]_inst_i_7_1 [3]),
        .I3(\data_out_reg_n_0_[0] ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_7_0 [3]),
        .I5(\data_out_reg_n_0_[1] ),
        .O(\data_out_reg[2]_1 ));
  LUT6 #(
    .INIT(64'hFFFB0000FFFBFFFB)) 
    \disp_seg_o_OBUF[6]_inst_i_7 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_3 ),
        .I1(Q),
        .I2(\disp_seg_o_OBUF[6]_inst_i_3_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_23_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_3_1 ),
        .I5(\disp_seg_o_OBUF[6]_inst_i_25_n_0 ),
        .O(\selector_reg[0] ));
endmodule

module clk_divider
   (clk_used,
    clk,
    sw_i_IBUF,
    S);
  output clk_used;
  input clk;
  input [0:0]sw_i_IBUF;
  input [0:0]S;

  wire [0:0]S;
  wire clk;
  wire clk_used;
  wire \counter[0]_i_2__0_n_0 ;
  wire [24:24]counter_reg;
  wire \counter_reg[0]_i_1__0_n_0 ;
  wire \counter_reg[0]_i_1__0_n_1 ;
  wire \counter_reg[0]_i_1__0_n_2 ;
  wire \counter_reg[0]_i_1__0_n_3 ;
  wire \counter_reg[0]_i_1__0_n_4 ;
  wire \counter_reg[0]_i_1__0_n_5 ;
  wire \counter_reg[0]_i_1__0_n_6 ;
  wire \counter_reg[0]_i_1__0_n_7 ;
  wire \counter_reg[12]_i_1__0_n_0 ;
  wire \counter_reg[12]_i_1__0_n_1 ;
  wire \counter_reg[12]_i_1__0_n_2 ;
  wire \counter_reg[12]_i_1__0_n_3 ;
  wire \counter_reg[12]_i_1__0_n_4 ;
  wire \counter_reg[12]_i_1__0_n_5 ;
  wire \counter_reg[12]_i_1__0_n_6 ;
  wire \counter_reg[12]_i_1__0_n_7 ;
  wire \counter_reg[16]_i_1__0_n_0 ;
  wire \counter_reg[16]_i_1__0_n_1 ;
  wire \counter_reg[16]_i_1__0_n_2 ;
  wire \counter_reg[16]_i_1__0_n_3 ;
  wire \counter_reg[16]_i_1__0_n_4 ;
  wire \counter_reg[16]_i_1__0_n_5 ;
  wire \counter_reg[16]_i_1__0_n_6 ;
  wire \counter_reg[16]_i_1__0_n_7 ;
  wire \counter_reg[20]_i_1__0_n_0 ;
  wire \counter_reg[20]_i_1__0_n_1 ;
  wire \counter_reg[20]_i_1__0_n_2 ;
  wire \counter_reg[20]_i_1__0_n_3 ;
  wire \counter_reg[20]_i_1__0_n_4 ;
  wire \counter_reg[20]_i_1__0_n_5 ;
  wire \counter_reg[20]_i_1__0_n_6 ;
  wire \counter_reg[20]_i_1__0_n_7 ;
  wire \counter_reg[24]_i_1__0_n_7 ;
  wire \counter_reg[4]_i_1__0_n_0 ;
  wire \counter_reg[4]_i_1__0_n_1 ;
  wire \counter_reg[4]_i_1__0_n_2 ;
  wire \counter_reg[4]_i_1__0_n_3 ;
  wire \counter_reg[4]_i_1__0_n_4 ;
  wire \counter_reg[4]_i_1__0_n_5 ;
  wire \counter_reg[4]_i_1__0_n_6 ;
  wire \counter_reg[4]_i_1__0_n_7 ;
  wire \counter_reg[8]_i_1__0_n_0 ;
  wire \counter_reg[8]_i_1__0_n_1 ;
  wire \counter_reg[8]_i_1__0_n_2 ;
  wire \counter_reg[8]_i_1__0_n_3 ;
  wire \counter_reg[8]_i_1__0_n_4 ;
  wire \counter_reg[8]_i_1__0_n_5 ;
  wire \counter_reg[8]_i_1__0_n_6 ;
  wire \counter_reg[8]_i_1__0_n_7 ;
  wire \counter_reg_n_0_[0] ;
  wire \counter_reg_n_0_[10] ;
  wire \counter_reg_n_0_[11] ;
  wire \counter_reg_n_0_[12] ;
  wire \counter_reg_n_0_[13] ;
  wire \counter_reg_n_0_[14] ;
  wire \counter_reg_n_0_[15] ;
  wire \counter_reg_n_0_[16] ;
  wire \counter_reg_n_0_[17] ;
  wire \counter_reg_n_0_[18] ;
  wire \counter_reg_n_0_[19] ;
  wire \counter_reg_n_0_[1] ;
  wire \counter_reg_n_0_[20] ;
  wire \counter_reg_n_0_[21] ;
  wire \counter_reg_n_0_[22] ;
  wire \counter_reg_n_0_[23] ;
  wire \counter_reg_n_0_[2] ;
  wire \counter_reg_n_0_[3] ;
  wire \counter_reg_n_0_[4] ;
  wire \counter_reg_n_0_[5] ;
  wire \counter_reg_n_0_[6] ;
  wire \counter_reg_n_0_[7] ;
  wire \counter_reg_n_0_[8] ;
  wire \counter_reg_n_0_[9] ;
  wire [0:0]sw_i_IBUF;
  wire [3:0]\NLW_counter_reg[24]_i_1__0_CO_UNCONNECTED ;
  wire [3:1]\NLW_counter_reg[24]_i_1__0_O_UNCONNECTED ;

  LUT3 #(
    .INIT(8'hB8)) 
    clk_used_BUFG_inst_i_1
       (.I0(counter_reg),
        .I1(sw_i_IBUF),
        .I2(S),
        .O(clk_used));
  LUT1 #(
    .INIT(2'h1)) 
    \counter[0]_i_2__0 
       (.I0(\counter_reg_n_0_[0] ),
        .O(\counter[0]_i_2__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__0_n_7 ),
        .Q(\counter_reg_n_0_[0] ),
        .R(1'b0));
  CARRY4 \counter_reg[0]_i_1__0 
       (.CI(1'b0),
        .CO({\counter_reg[0]_i_1__0_n_0 ,\counter_reg[0]_i_1__0_n_1 ,\counter_reg[0]_i_1__0_n_2 ,\counter_reg[0]_i_1__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\counter_reg[0]_i_1__0_n_4 ,\counter_reg[0]_i_1__0_n_5 ,\counter_reg[0]_i_1__0_n_6 ,\counter_reg[0]_i_1__0_n_7 }),
        .S({\counter_reg_n_0_[3] ,\counter_reg_n_0_[2] ,\counter_reg_n_0_[1] ,\counter[0]_i_2__0_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__0_n_5 ),
        .Q(\counter_reg_n_0_[10] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__0_n_4 ),
        .Q(\counter_reg_n_0_[11] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1__0_n_7 ),
        .Q(\counter_reg_n_0_[12] ),
        .R(1'b0));
  CARRY4 \counter_reg[12]_i_1__0 
       (.CI(\counter_reg[8]_i_1__0_n_0 ),
        .CO({\counter_reg[12]_i_1__0_n_0 ,\counter_reg[12]_i_1__0_n_1 ,\counter_reg[12]_i_1__0_n_2 ,\counter_reg[12]_i_1__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[12]_i_1__0_n_4 ,\counter_reg[12]_i_1__0_n_5 ,\counter_reg[12]_i_1__0_n_6 ,\counter_reg[12]_i_1__0_n_7 }),
        .S({\counter_reg_n_0_[15] ,\counter_reg_n_0_[14] ,\counter_reg_n_0_[13] ,\counter_reg_n_0_[12] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1__0_n_6 ),
        .Q(\counter_reg_n_0_[13] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1__0_n_5 ),
        .Q(\counter_reg_n_0_[14] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1__0_n_4 ),
        .Q(\counter_reg_n_0_[15] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1__0_n_7 ),
        .Q(\counter_reg_n_0_[16] ),
        .R(1'b0));
  CARRY4 \counter_reg[16]_i_1__0 
       (.CI(\counter_reg[12]_i_1__0_n_0 ),
        .CO({\counter_reg[16]_i_1__0_n_0 ,\counter_reg[16]_i_1__0_n_1 ,\counter_reg[16]_i_1__0_n_2 ,\counter_reg[16]_i_1__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[16]_i_1__0_n_4 ,\counter_reg[16]_i_1__0_n_5 ,\counter_reg[16]_i_1__0_n_6 ,\counter_reg[16]_i_1__0_n_7 }),
        .S({\counter_reg_n_0_[19] ,\counter_reg_n_0_[18] ,\counter_reg_n_0_[17] ,\counter_reg_n_0_[16] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1__0_n_6 ),
        .Q(\counter_reg_n_0_[17] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1__0_n_5 ),
        .Q(\counter_reg_n_0_[18] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1__0_n_4 ),
        .Q(\counter_reg_n_0_[19] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__0_n_6 ),
        .Q(\counter_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1__0_n_7 ),
        .Q(\counter_reg_n_0_[20] ),
        .R(1'b0));
  CARRY4 \counter_reg[20]_i_1__0 
       (.CI(\counter_reg[16]_i_1__0_n_0 ),
        .CO({\counter_reg[20]_i_1__0_n_0 ,\counter_reg[20]_i_1__0_n_1 ,\counter_reg[20]_i_1__0_n_2 ,\counter_reg[20]_i_1__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[20]_i_1__0_n_4 ,\counter_reg[20]_i_1__0_n_5 ,\counter_reg[20]_i_1__0_n_6 ,\counter_reg[20]_i_1__0_n_7 }),
        .S({\counter_reg_n_0_[23] ,\counter_reg_n_0_[22] ,\counter_reg_n_0_[21] ,\counter_reg_n_0_[20] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1__0_n_6 ),
        .Q(\counter_reg_n_0_[21] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1__0_n_5 ),
        .Q(\counter_reg_n_0_[22] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1__0_n_4 ),
        .Q(\counter_reg_n_0_[23] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[24] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1__0_n_7 ),
        .Q(counter_reg),
        .R(1'b0));
  CARRY4 \counter_reg[24]_i_1__0 
       (.CI(\counter_reg[20]_i_1__0_n_0 ),
        .CO(\NLW_counter_reg[24]_i_1__0_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_counter_reg[24]_i_1__0_O_UNCONNECTED [3:1],\counter_reg[24]_i_1__0_n_7 }),
        .S({1'b0,1'b0,1'b0,counter_reg}));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__0_n_5 ),
        .Q(\counter_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__0_n_4 ),
        .Q(\counter_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__0_n_7 ),
        .Q(\counter_reg_n_0_[4] ),
        .R(1'b0));
  CARRY4 \counter_reg[4]_i_1__0 
       (.CI(\counter_reg[0]_i_1__0_n_0 ),
        .CO({\counter_reg[4]_i_1__0_n_0 ,\counter_reg[4]_i_1__0_n_1 ,\counter_reg[4]_i_1__0_n_2 ,\counter_reg[4]_i_1__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[4]_i_1__0_n_4 ,\counter_reg[4]_i_1__0_n_5 ,\counter_reg[4]_i_1__0_n_6 ,\counter_reg[4]_i_1__0_n_7 }),
        .S({\counter_reg_n_0_[7] ,\counter_reg_n_0_[6] ,\counter_reg_n_0_[5] ,\counter_reg_n_0_[4] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__0_n_6 ),
        .Q(\counter_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__0_n_5 ),
        .Q(\counter_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__0_n_4 ),
        .Q(\counter_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__0_n_7 ),
        .Q(\counter_reg_n_0_[8] ),
        .R(1'b0));
  CARRY4 \counter_reg[8]_i_1__0 
       (.CI(\counter_reg[4]_i_1__0_n_0 ),
        .CO({\counter_reg[8]_i_1__0_n_0 ,\counter_reg[8]_i_1__0_n_1 ,\counter_reg[8]_i_1__0_n_2 ,\counter_reg[8]_i_1__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[8]_i_1__0_n_4 ,\counter_reg[8]_i_1__0_n_5 ,\counter_reg[8]_i_1__0_n_6 ,\counter_reg[8]_i_1__0_n_7 }),
        .S({\counter_reg_n_0_[11] ,\counter_reg_n_0_[10] ,\counter_reg_n_0_[9] ,\counter_reg_n_0_[8] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__0_n_6 ),
        .Q(\counter_reg_n_0_[9] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "clk_divider" *) 
module clk_divider__parameterized0
   (S,
    clk);
  output [0:0]S;
  input clk;

  wire [0:0]S;
  wire clk;
  wire \counter[0]_i_2_n_0 ;
  wire \counter_reg[0]_i_1_n_0 ;
  wire \counter_reg[0]_i_1_n_1 ;
  wire \counter_reg[0]_i_1_n_2 ;
  wire \counter_reg[0]_i_1_n_3 ;
  wire \counter_reg[0]_i_1_n_4 ;
  wire \counter_reg[0]_i_1_n_5 ;
  wire \counter_reg[0]_i_1_n_6 ;
  wire \counter_reg[0]_i_1_n_7 ;
  wire \counter_reg[12]_i_1_n_0 ;
  wire \counter_reg[12]_i_1_n_1 ;
  wire \counter_reg[12]_i_1_n_2 ;
  wire \counter_reg[12]_i_1_n_3 ;
  wire \counter_reg[12]_i_1_n_4 ;
  wire \counter_reg[12]_i_1_n_5 ;
  wire \counter_reg[12]_i_1_n_6 ;
  wire \counter_reg[12]_i_1_n_7 ;
  wire \counter_reg[16]_i_1_n_0 ;
  wire \counter_reg[16]_i_1_n_1 ;
  wire \counter_reg[16]_i_1_n_2 ;
  wire \counter_reg[16]_i_1_n_3 ;
  wire \counter_reg[16]_i_1_n_4 ;
  wire \counter_reg[16]_i_1_n_5 ;
  wire \counter_reg[16]_i_1_n_6 ;
  wire \counter_reg[16]_i_1_n_7 ;
  wire \counter_reg[20]_i_1_n_0 ;
  wire \counter_reg[20]_i_1_n_1 ;
  wire \counter_reg[20]_i_1_n_2 ;
  wire \counter_reg[20]_i_1_n_3 ;
  wire \counter_reg[20]_i_1_n_4 ;
  wire \counter_reg[20]_i_1_n_5 ;
  wire \counter_reg[20]_i_1_n_6 ;
  wire \counter_reg[20]_i_1_n_7 ;
  wire \counter_reg[24]_i_1_n_1 ;
  wire \counter_reg[24]_i_1_n_2 ;
  wire \counter_reg[24]_i_1_n_3 ;
  wire \counter_reg[24]_i_1_n_4 ;
  wire \counter_reg[24]_i_1_n_5 ;
  wire \counter_reg[24]_i_1_n_6 ;
  wire \counter_reg[24]_i_1_n_7 ;
  wire \counter_reg[4]_i_1_n_0 ;
  wire \counter_reg[4]_i_1_n_1 ;
  wire \counter_reg[4]_i_1_n_2 ;
  wire \counter_reg[4]_i_1_n_3 ;
  wire \counter_reg[4]_i_1_n_4 ;
  wire \counter_reg[4]_i_1_n_5 ;
  wire \counter_reg[4]_i_1_n_6 ;
  wire \counter_reg[4]_i_1_n_7 ;
  wire \counter_reg[8]_i_1_n_0 ;
  wire \counter_reg[8]_i_1_n_1 ;
  wire \counter_reg[8]_i_1_n_2 ;
  wire \counter_reg[8]_i_1_n_3 ;
  wire \counter_reg[8]_i_1_n_4 ;
  wire \counter_reg[8]_i_1_n_5 ;
  wire \counter_reg[8]_i_1_n_6 ;
  wire \counter_reg[8]_i_1_n_7 ;
  wire \counter_reg_n_0_[0] ;
  wire \counter_reg_n_0_[10] ;
  wire \counter_reg_n_0_[11] ;
  wire \counter_reg_n_0_[12] ;
  wire \counter_reg_n_0_[13] ;
  wire \counter_reg_n_0_[14] ;
  wire \counter_reg_n_0_[15] ;
  wire \counter_reg_n_0_[16] ;
  wire \counter_reg_n_0_[17] ;
  wire \counter_reg_n_0_[18] ;
  wire \counter_reg_n_0_[19] ;
  wire \counter_reg_n_0_[1] ;
  wire \counter_reg_n_0_[20] ;
  wire \counter_reg_n_0_[21] ;
  wire \counter_reg_n_0_[22] ;
  wire \counter_reg_n_0_[23] ;
  wire \counter_reg_n_0_[24] ;
  wire \counter_reg_n_0_[25] ;
  wire \counter_reg_n_0_[26] ;
  wire \counter_reg_n_0_[2] ;
  wire \counter_reg_n_0_[3] ;
  wire \counter_reg_n_0_[4] ;
  wire \counter_reg_n_0_[5] ;
  wire \counter_reg_n_0_[6] ;
  wire \counter_reg_n_0_[7] ;
  wire \counter_reg_n_0_[8] ;
  wire \counter_reg_n_0_[9] ;
  wire [3:3]\NLW_counter_reg[24]_i_1_CO_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \counter[0]_i_2 
       (.I0(\counter_reg_n_0_[0] ),
        .O(\counter[0]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[0] ),
        .R(1'b0));
  CARRY4 \counter_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\counter_reg[0]_i_1_n_0 ,\counter_reg[0]_i_1_n_1 ,\counter_reg[0]_i_1_n_2 ,\counter_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\counter_reg[0]_i_1_n_4 ,\counter_reg[0]_i_1_n_5 ,\counter_reg[0]_i_1_n_6 ,\counter_reg[0]_i_1_n_7 }),
        .S({\counter_reg_n_0_[3] ,\counter_reg_n_0_[2] ,\counter_reg_n_0_[1] ,\counter[0]_i_2_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[10] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[11] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[12] ),
        .R(1'b0));
  CARRY4 \counter_reg[12]_i_1 
       (.CI(\counter_reg[8]_i_1_n_0 ),
        .CO({\counter_reg[12]_i_1_n_0 ,\counter_reg[12]_i_1_n_1 ,\counter_reg[12]_i_1_n_2 ,\counter_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[12]_i_1_n_4 ,\counter_reg[12]_i_1_n_5 ,\counter_reg[12]_i_1_n_6 ,\counter_reg[12]_i_1_n_7 }),
        .S({\counter_reg_n_0_[15] ,\counter_reg_n_0_[14] ,\counter_reg_n_0_[13] ,\counter_reg_n_0_[12] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[13] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[14] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[15] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[16] ),
        .R(1'b0));
  CARRY4 \counter_reg[16]_i_1 
       (.CI(\counter_reg[12]_i_1_n_0 ),
        .CO({\counter_reg[16]_i_1_n_0 ,\counter_reg[16]_i_1_n_1 ,\counter_reg[16]_i_1_n_2 ,\counter_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[16]_i_1_n_4 ,\counter_reg[16]_i_1_n_5 ,\counter_reg[16]_i_1_n_6 ,\counter_reg[16]_i_1_n_7 }),
        .S({\counter_reg_n_0_[19] ,\counter_reg_n_0_[18] ,\counter_reg_n_0_[17] ,\counter_reg_n_0_[16] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[17] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[18] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[16]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[19] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[20] ),
        .R(1'b0));
  CARRY4 \counter_reg[20]_i_1 
       (.CI(\counter_reg[16]_i_1_n_0 ),
        .CO({\counter_reg[20]_i_1_n_0 ,\counter_reg[20]_i_1_n_1 ,\counter_reg[20]_i_1_n_2 ,\counter_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[20]_i_1_n_4 ,\counter_reg[20]_i_1_n_5 ,\counter_reg[20]_i_1_n_6 ,\counter_reg[20]_i_1_n_7 }),
        .S({\counter_reg_n_0_[23] ,\counter_reg_n_0_[22] ,\counter_reg_n_0_[21] ,\counter_reg_n_0_[20] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[21] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[22] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[20]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[23] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[24] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[24] ),
        .R(1'b0));
  CARRY4 \counter_reg[24]_i_1 
       (.CI(\counter_reg[20]_i_1_n_0 ),
        .CO({\NLW_counter_reg[24]_i_1_CO_UNCONNECTED [3],\counter_reg[24]_i_1_n_1 ,\counter_reg[24]_i_1_n_2 ,\counter_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[24]_i_1_n_4 ,\counter_reg[24]_i_1_n_5 ,\counter_reg[24]_i_1_n_6 ,\counter_reg[24]_i_1_n_7 }),
        .S({S,\counter_reg_n_0_[26] ,\counter_reg_n_0_[25] ,\counter_reg_n_0_[24] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[25] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[25] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[26] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[26] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[27] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[24]_i_1_n_4 ),
        .Q(S),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[4] ),
        .R(1'b0));
  CARRY4 \counter_reg[4]_i_1 
       (.CI(\counter_reg[0]_i_1_n_0 ),
        .CO({\counter_reg[4]_i_1_n_0 ,\counter_reg[4]_i_1_n_1 ,\counter_reg[4]_i_1_n_2 ,\counter_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[4]_i_1_n_4 ,\counter_reg[4]_i_1_n_5 ,\counter_reg[4]_i_1_n_6 ,\counter_reg[4]_i_1_n_7 }),
        .S({\counter_reg_n_0_[7] ,\counter_reg_n_0_[6] ,\counter_reg_n_0_[5] ,\counter_reg_n_0_[4] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1_n_5 ),
        .Q(\counter_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1_n_4 ),
        .Q(\counter_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1_n_7 ),
        .Q(\counter_reg_n_0_[8] ),
        .R(1'b0));
  CARRY4 \counter_reg[8]_i_1 
       (.CI(\counter_reg[4]_i_1_n_0 ),
        .CO({\counter_reg[8]_i_1_n_0 ,\counter_reg[8]_i_1_n_1 ,\counter_reg[8]_i_1_n_2 ,\counter_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[8]_i_1_n_4 ,\counter_reg[8]_i_1_n_5 ,\counter_reg[8]_i_1_n_6 ,\counter_reg[8]_i_1_n_7 }),
        .S({\counter_reg_n_0_[11] ,\counter_reg_n_0_[10] ,\counter_reg_n_0_[9] ,\counter_reg_n_0_[8] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1_n_6 ),
        .Q(\counter_reg_n_0_[9] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "clk_divider" *) 
module clk_divider__parameterized1
   (O643,
    clk);
  output O643;
  input clk;

  wire O643;
  wire clk;
  wire \counter[0]_i_2__1_n_0 ;
  wire \counter_reg[0]_i_1__1_n_0 ;
  wire \counter_reg[0]_i_1__1_n_1 ;
  wire \counter_reg[0]_i_1__1_n_2 ;
  wire \counter_reg[0]_i_1__1_n_3 ;
  wire \counter_reg[0]_i_1__1_n_4 ;
  wire \counter_reg[0]_i_1__1_n_5 ;
  wire \counter_reg[0]_i_1__1_n_6 ;
  wire \counter_reg[0]_i_1__1_n_7 ;
  wire \counter_reg[12]_i_1__1_n_7 ;
  wire \counter_reg[4]_i_1__1_n_0 ;
  wire \counter_reg[4]_i_1__1_n_1 ;
  wire \counter_reg[4]_i_1__1_n_2 ;
  wire \counter_reg[4]_i_1__1_n_3 ;
  wire \counter_reg[4]_i_1__1_n_4 ;
  wire \counter_reg[4]_i_1__1_n_5 ;
  wire \counter_reg[4]_i_1__1_n_6 ;
  wire \counter_reg[4]_i_1__1_n_7 ;
  wire \counter_reg[8]_i_1__1_n_0 ;
  wire \counter_reg[8]_i_1__1_n_1 ;
  wire \counter_reg[8]_i_1__1_n_2 ;
  wire \counter_reg[8]_i_1__1_n_3 ;
  wire \counter_reg[8]_i_1__1_n_4 ;
  wire \counter_reg[8]_i_1__1_n_5 ;
  wire \counter_reg[8]_i_1__1_n_6 ;
  wire \counter_reg[8]_i_1__1_n_7 ;
  wire \counter_reg_n_0_[0] ;
  wire \counter_reg_n_0_[10] ;
  wire \counter_reg_n_0_[11] ;
  wire \counter_reg_n_0_[1] ;
  wire \counter_reg_n_0_[2] ;
  wire \counter_reg_n_0_[3] ;
  wire \counter_reg_n_0_[4] ;
  wire \counter_reg_n_0_[5] ;
  wire \counter_reg_n_0_[6] ;
  wire \counter_reg_n_0_[7] ;
  wire \counter_reg_n_0_[8] ;
  wire \counter_reg_n_0_[9] ;
  wire [3:0]\NLW_counter_reg[12]_i_1__1_CO_UNCONNECTED ;
  wire [3:1]\NLW_counter_reg[12]_i_1__1_O_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \counter[0]_i_2__1 
       (.I0(\counter_reg_n_0_[0] ),
        .O(\counter[0]_i_2__1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__1_n_7 ),
        .Q(\counter_reg_n_0_[0] ),
        .R(1'b0));
  CARRY4 \counter_reg[0]_i_1__1 
       (.CI(1'b0),
        .CO({\counter_reg[0]_i_1__1_n_0 ,\counter_reg[0]_i_1__1_n_1 ,\counter_reg[0]_i_1__1_n_2 ,\counter_reg[0]_i_1__1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\counter_reg[0]_i_1__1_n_4 ,\counter_reg[0]_i_1__1_n_5 ,\counter_reg[0]_i_1__1_n_6 ,\counter_reg[0]_i_1__1_n_7 }),
        .S({\counter_reg_n_0_[3] ,\counter_reg_n_0_[2] ,\counter_reg_n_0_[1] ,\counter[0]_i_2__1_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__1_n_5 ),
        .Q(\counter_reg_n_0_[10] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__1_n_4 ),
        .Q(\counter_reg_n_0_[11] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[12]_i_1__1_n_7 ),
        .Q(O643),
        .R(1'b0));
  CARRY4 \counter_reg[12]_i_1__1 
       (.CI(\counter_reg[8]_i_1__1_n_0 ),
        .CO(\NLW_counter_reg[12]_i_1__1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_counter_reg[12]_i_1__1_O_UNCONNECTED [3:1],\counter_reg[12]_i_1__1_n_7 }),
        .S({1'b0,1'b0,1'b0,O643}));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__1_n_6 ),
        .Q(\counter_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__1_n_5 ),
        .Q(\counter_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[0]_i_1__1_n_4 ),
        .Q(\counter_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__1_n_7 ),
        .Q(\counter_reg_n_0_[4] ),
        .R(1'b0));
  CARRY4 \counter_reg[4]_i_1__1 
       (.CI(\counter_reg[0]_i_1__1_n_0 ),
        .CO({\counter_reg[4]_i_1__1_n_0 ,\counter_reg[4]_i_1__1_n_1 ,\counter_reg[4]_i_1__1_n_2 ,\counter_reg[4]_i_1__1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[4]_i_1__1_n_4 ,\counter_reg[4]_i_1__1_n_5 ,\counter_reg[4]_i_1__1_n_6 ,\counter_reg[4]_i_1__1_n_7 }),
        .S({\counter_reg_n_0_[7] ,\counter_reg_n_0_[6] ,\counter_reg_n_0_[5] ,\counter_reg_n_0_[4] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__1_n_6 ),
        .Q(\counter_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__1_n_5 ),
        .Q(\counter_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[4]_i_1__1_n_4 ),
        .Q(\counter_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__1_n_7 ),
        .Q(\counter_reg_n_0_[8] ),
        .R(1'b0));
  CARRY4 \counter_reg[8]_i_1__1 
       (.CI(\counter_reg[4]_i_1__1_n_0 ),
        .CO({\counter_reg[8]_i_1__1_n_0 ,\counter_reg[8]_i_1__1_n_1 ,\counter_reg[8]_i_1__1_n_2 ,\counter_reg[8]_i_1__1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\counter_reg[8]_i_1__1_n_4 ,\counter_reg[8]_i_1__1_n_5 ,\counter_reg[8]_i_1__1_n_6 ,\counter_reg[8]_i_1__1_n_7 }),
        .S({\counter_reg_n_0_[11] ,\counter_reg_n_0_[10] ,\counter_reg_n_0_[9] ,\counter_reg_n_0_[8] }));
  FDRE #(
    .INIT(1'b0)) 
    \counter_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(\counter_reg[8]_i_1__1_n_6 ),
        .Q(\counter_reg_n_0_[9] ),
        .R(1'b0));
endmodule

module data_memory
   (\disp_data_reg[29]_0 ,
    dm_disp_data,
    \disp_data_reg[28]_0 ,
    \disp_data_reg[26]_0 ,
    \disp_data_reg[30]_0 ,
    \disp_data_reg[27]_0 ,
    sw_i_IBUF,
    spo,
    Q,
    clk_used_BUFG);
  output \disp_data_reg[29]_0 ;
  output [4:0]dm_disp_data;
  output \disp_data_reg[28]_0 ;
  output \disp_data_reg[26]_0 ;
  output \disp_data_reg[30]_0 ;
  output \disp_data_reg[27]_0 ;
  input [1:0]sw_i_IBUF;
  input [0:0]spo;
  input [4:0]Q;
  input clk_used_BUFG;

  wire [4:0]Q;
  wire clk_used_BUFG;
  wire \disp_data_reg[26]_0 ;
  wire \disp_data_reg[27]_0 ;
  wire \disp_data_reg[28]_0 ;
  wire \disp_data_reg[29]_0 ;
  wire \disp_data_reg[30]_0 ;
  wire [4:0]dm_disp_data;
  wire [0:0]spo;
  wire [1:0]sw_i_IBUF;

  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[26] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(Q[0]),
        .Q(dm_disp_data[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[27] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(Q[1]),
        .Q(dm_disp_data[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[28] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(Q[2]),
        .Q(dm_disp_data[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[29] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(Q[3]),
        .Q(dm_disp_data[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[30] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(Q[4]),
        .Q(dm_disp_data[4]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \disp_seg_o_OBUF[5]_inst_i_11 
       (.I0(sw_i_IBUF[0]),
        .I1(dm_disp_data[4]),
        .O(\disp_data_reg[30]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \disp_seg_o_OBUF[5]_inst_i_9 
       (.I0(sw_i_IBUF[0]),
        .I1(dm_disp_data[3]),
        .O(\disp_data_reg[29]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \disp_seg_o_OBUF[6]_inst_i_22 
       (.I0(sw_i_IBUF[0]),
        .I1(dm_disp_data[2]),
        .O(\disp_data_reg[28]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h0777)) 
    \disp_seg_o_OBUF[6]_inst_i_36 
       (.I0(dm_disp_data[0]),
        .I1(sw_i_IBUF[0]),
        .I2(spo),
        .I3(sw_i_IBUF[1]),
        .O(\disp_data_reg[26]_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \disp_seg_o_OBUF[6]_inst_i_49 
       (.I0(dm_disp_data[1]),
        .I1(sw_i_IBUF[0]),
        .O(\disp_data_reg[27]_0 ));
endmodule

module disp_seg16x
   (Q,
    disp_seg_o_OBUF,
    \selector_reg[1]_0 ,
    disp_an_o_OBUF,
    \disp_seg_o[5] ,
    \disp_seg_o_OBUF[6]_inst_i_4_0 ,
    sw_i_IBUF,
    \disp_seg_o_OBUF[6]_inst_i_4_1 ,
    \disp_seg_o_OBUF[4]_inst_i_1_0 ,
    \disp_seg_o_OBUF[4]_inst_i_1_1 ,
    \disp_seg_o_OBUF[5]_inst_i_2_0 ,
    spo,
    \disp_seg_o_OBUF[5]_inst_i_3_0 ,
    dm_disp_data,
    \disp_seg_o_OBUF[6]_inst_i_3_0 ,
    \disp_seg_o_OBUF[6]_inst_i_6_0 ,
    \disp_seg_o_OBUF[6]_inst_i_6_1 ,
    \disp_seg_o_OBUF[6]_inst_i_4_2 ,
    \disp_seg_o_OBUF[5]_inst_i_2_1 ,
    \disp_seg_o_OBUF[6]_inst_i_20_0 ,
    \disp_seg_o_OBUF[5]_inst_i_1_0 ,
    \disp_seg_o_OBUF[5]_inst_i_1_1 ,
    \disp_seg_o_OBUF[5]_inst_i_1_2 ,
    O643);
  output [1:0]Q;
  output [6:0]disp_seg_o_OBUF;
  output \selector_reg[1]_0 ;
  output [7:0]disp_an_o_OBUF;
  input \disp_seg_o[5] ;
  input \disp_seg_o_OBUF[6]_inst_i_4_0 ;
  input [3:0]sw_i_IBUF;
  input \disp_seg_o_OBUF[6]_inst_i_4_1 ;
  input \disp_seg_o_OBUF[4]_inst_i_1_0 ;
  input \disp_seg_o_OBUF[4]_inst_i_1_1 ;
  input \disp_seg_o_OBUF[5]_inst_i_2_0 ;
  input [24:0]spo;
  input \disp_seg_o_OBUF[5]_inst_i_3_0 ;
  input [4:0]dm_disp_data;
  input \disp_seg_o_OBUF[6]_inst_i_3_0 ;
  input \disp_seg_o_OBUF[6]_inst_i_6_0 ;
  input \disp_seg_o_OBUF[6]_inst_i_6_1 ;
  input \disp_seg_o_OBUF[6]_inst_i_4_2 ;
  input \disp_seg_o_OBUF[5]_inst_i_2_1 ;
  input [2:0]\disp_seg_o_OBUF[6]_inst_i_20_0 ;
  input \disp_seg_o_OBUF[5]_inst_i_1_0 ;
  input \disp_seg_o_OBUF[5]_inst_i_1_1 ;
  input \disp_seg_o_OBUF[5]_inst_i_1_2 ;
  input O643;

  wire O643;
  wire [1:0]Q;
  wire [7:0]disp_an_o_OBUF;
  wire \disp_seg_o[5] ;
  wire [6:0]disp_seg_o_OBUF;
  wire \disp_seg_o_OBUF[4]_inst_i_1_0 ;
  wire \disp_seg_o_OBUF[4]_inst_i_1_1 ;
  wire \disp_seg_o_OBUF[5]_inst_i_10_n_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_1_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_1_1 ;
  wire \disp_seg_o_OBUF[5]_inst_i_1_2 ;
  wire \disp_seg_o_OBUF[5]_inst_i_2_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_2_1 ;
  wire \disp_seg_o_OBUF[5]_inst_i_2_n_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_3_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_3_n_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_5_n_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_6_n_0 ;
  wire \disp_seg_o_OBUF[5]_inst_i_8_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_10_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_11_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_13_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_14_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_16_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_17_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_18_n_0 ;
  wire [2:0]\disp_seg_o_OBUF[6]_inst_i_20_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_20_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_26_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_27_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_28_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_29_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_30_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_32_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_33_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_34_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_35_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_37_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_38_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_3_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_3_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_40_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_42_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_43_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_44_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_46_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_47_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_48_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_4_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_4_1 ;
  wire \disp_seg_o_OBUF[6]_inst_i_4_2 ;
  wire \disp_seg_o_OBUF[6]_inst_i_4_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_50_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_51_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_5_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_6_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_6_1 ;
  wire \disp_seg_o_OBUF[6]_inst_i_6_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_8_n_0 ;
  wire \disp_seg_o_OBUF[6]_inst_i_9_n_0 ;
  wire [4:0]dm_disp_data;
  wire [2:2]selector;
  wire \selector[0]_i_1_n_0 ;
  wire \selector[1]_i_1_n_0 ;
  wire \selector[2]_i_1_n_0 ;
  wire \selector_reg[1]_0 ;
  wire [24:0]spo;
  wire [3:0]sw_i_IBUF;

  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \disp_an_o_OBUF[0]_inst_i_1 
       (.I0(selector),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(disp_an_o_OBUF[0]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \disp_an_o_OBUF[1]_inst_i_1 
       (.I0(selector),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(disp_an_o_OBUF[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hFB)) 
    \disp_an_o_OBUF[2]_inst_i_1 
       (.I0(selector),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(disp_an_o_OBUF[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hBF)) 
    \disp_an_o_OBUF[3]_inst_i_1 
       (.I0(selector),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(disp_an_o_OBUF[3]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hEF)) 
    \disp_an_o_OBUF[4]_inst_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(selector),
        .O(disp_an_o_OBUF[4]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \disp_an_o_OBUF[5]_inst_i_1 
       (.I0(selector),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(disp_an_o_OBUF[5]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hDF)) 
    \disp_an_o_OBUF[6]_inst_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(selector),
        .O(disp_an_o_OBUF[6]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \disp_an_o_OBUF[7]_inst_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(selector),
        .O(disp_an_o_OBUF[7]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h2094)) 
    \disp_seg_o_OBUF[0]_inst_i_1 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_4_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .I3(\disp_seg_o_OBUF[5]_inst_i_2_n_0 ),
        .O(disp_seg_o_OBUF[0]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hA4C8)) 
    \disp_seg_o_OBUF[1]_inst_i_1 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_4_n_0 ),
        .I2(\disp_seg_o_OBUF[5]_inst_i_2_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .O(disp_seg_o_OBUF[1]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h8A04)) 
    \disp_seg_o_OBUF[2]_inst_i_1 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .I1(\disp_seg_o_OBUF[5]_inst_i_2_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_4_n_0 ),
        .O(disp_seg_o_OBUF[2]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hC214)) 
    \disp_seg_o_OBUF[3]_inst_i_1 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_4_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .I3(\disp_seg_o_OBUF[5]_inst_i_2_n_0 ),
        .O(disp_seg_o_OBUF[3]));
  LUT5 #(
    .INIT(32'h555D0050)) 
    \disp_seg_o_OBUF[4]_inst_i_1 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .I1(\disp_seg_o[5] ),
        .I2(\disp_seg_o_OBUF[5]_inst_i_3_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_5_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .O(disp_seg_o_OBUF[4]));
  LUT5 #(
    .INIT(32'h48480E08)) 
    \disp_seg_o_OBUF[5]_inst_i_1 
       (.I0(\disp_seg_o_OBUF[5]_inst_i_2_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .I3(\disp_seg_o[5] ),
        .I4(\disp_seg_o_OBUF[5]_inst_i_3_n_0 ),
        .O(disp_seg_o_OBUF[5]));
  LUT6 #(
    .INIT(64'h8888800080008000)) 
    \disp_seg_o_OBUF[5]_inst_i_10 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[22]),
        .I4(sw_i_IBUF[0]),
        .I5(dm_disp_data[3]),
        .O(\disp_seg_o_OBUF[5]_inst_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hBBBA0000FFFFFFFF)) 
    \disp_seg_o_OBUF[5]_inst_i_2 
       (.I0(selector),
        .I1(\disp_seg_o_OBUF[6]_inst_i_17_n_0 ),
        .I2(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I3(\disp_seg_o_OBUF[5]_inst_i_1_2 ),
        .I4(\disp_seg_o_OBUF[5]_inst_i_5_n_0 ),
        .I5(\disp_seg_o[5] ),
        .O(\disp_seg_o_OBUF[5]_inst_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFFF08AA)) 
    \disp_seg_o_OBUF[5]_inst_i_3 
       (.I0(\disp_seg_o_OBUF[5]_inst_i_6_n_0 ),
        .I1(sw_i_IBUF[1]),
        .I2(\disp_seg_o_OBUF[6]_inst_i_4_1 ),
        .I3(\disp_seg_o_OBUF[5]_inst_i_8_n_0 ),
        .I4(selector),
        .I5(\disp_seg_o_OBUF[6]_inst_i_10_n_0 ),
        .O(\disp_seg_o_OBUF[5]_inst_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    \disp_seg_o_OBUF[5]_inst_i_5 
       (.I0(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I1(\disp_seg_o_OBUF[5]_inst_i_2_0 ),
        .I2(\disp_seg_o_OBUF[5]_inst_i_10_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_14_n_0 ),
        .I4(selector),
        .O(\disp_seg_o_OBUF[5]_inst_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBBBBBBBBBAAA)) 
    \disp_seg_o_OBUF[5]_inst_i_6 
       (.I0(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_40_n_0 ),
        .I2(sw_i_IBUF[3]),
        .I3(spo[10]),
        .I4(\selector_reg[1]_0 ),
        .I5(\disp_seg_o_OBUF[5]_inst_i_3_0 ),
        .O(\disp_seg_o_OBUF[5]_inst_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAABBBABBBABBB)) 
    \disp_seg_o_OBUF[5]_inst_i_8 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_38_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_37_n_0 ),
        .I2(dm_disp_data[0]),
        .I3(sw_i_IBUF[0]),
        .I4(spo[1]),
        .I5(sw_i_IBUF[3]),
        .O(\disp_seg_o_OBUF[5]_inst_i_8_n_0 ));
  LUT5 #(
    .INIT(32'h0030C04A)) 
    \disp_seg_o_OBUF[6]_inst_i_1 
       (.I0(\disp_seg_o[5] ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_4_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_5_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ),
        .O(disp_seg_o_OBUF[6]));
  LUT6 #(
    .INIT(64'h0000000200000000)) 
    \disp_seg_o_OBUF[6]_inst_i_10 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_4_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_32_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_33_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_34_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_35_n_0 ),
        .I5(selector),
        .O(\disp_seg_o_OBUF[6]_inst_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hF200F2F2)) 
    \disp_seg_o_OBUF[6]_inst_i_11 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_4_2 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_37_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_38_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_4_1 ),
        .I4(sw_i_IBUF[1]),
        .O(\disp_seg_o_OBUF[6]_inst_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFF8F8F8)) 
    \disp_seg_o_OBUF[6]_inst_i_13 
       (.I0(sw_i_IBUF[0]),
        .I1(dm_disp_data[4]),
        .I2(\selector_reg[1]_0 ),
        .I3(spo[10]),
        .I4(sw_i_IBUF[3]),
        .I5(\disp_seg_o_OBUF[6]_inst_i_40_n_0 ),
        .O(\disp_seg_o_OBUF[6]_inst_i_13_n_0 ));
  LUT6 #(
    .INIT(64'h4444400040004000)) 
    \disp_seg_o_OBUF[6]_inst_i_14 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(sw_i_IBUF[0]),
        .I3(dm_disp_data[3]),
        .I4(spo[15]),
        .I5(sw_i_IBUF[3]),
        .O(\disp_seg_o_OBUF[6]_inst_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hBBBBBBABBBABBBAB)) 
    \disp_seg_o_OBUF[6]_inst_i_16 
       (.I0(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_42_n_0 ),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(spo[6]),
        .I5(sw_i_IBUF[3]),
        .O(\disp_seg_o_OBUF[6]_inst_i_16_n_0 ));
  LUT4 #(
    .INIT(16'hE0EE)) 
    \disp_seg_o_OBUF[6]_inst_i_17 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_43_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_44_n_0 ),
        .I2(\disp_seg_o_OBUF[5]_inst_i_2_1 ),
        .I3(sw_i_IBUF[1]),
        .O(\disp_seg_o_OBUF[6]_inst_i_17_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \disp_seg_o_OBUF[6]_inst_i_18 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_4_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_46_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_47_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_48_n_0 ),
        .O(\disp_seg_o_OBUF[6]_inst_i_18_n_0 ));
  LUT5 #(
    .INIT(32'h54FF5454)) 
    \disp_seg_o_OBUF[6]_inst_i_20 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_50_n_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_51_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_6_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_6_1 ),
        .I4(sw_i_IBUF[1]),
        .O(\disp_seg_o_OBUF[6]_inst_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h5F4F4F4F)) 
    \disp_seg_o_OBUF[6]_inst_i_26 
       (.I0(Q[0]),
        .I1(sw_i_IBUF[0]),
        .I2(Q[1]),
        .I3(sw_i_IBUF[3]),
        .I4(spo[5]),
        .O(\disp_seg_o_OBUF[6]_inst_i_26_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h22202020)) 
    \disp_seg_o_OBUF[6]_inst_i_27 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(sw_i_IBUF[0]),
        .I3(spo[18]),
        .I4(sw_i_IBUF[3]),
        .O(\disp_seg_o_OBUF[6]_inst_i_27_n_0 ));
  LUT6 #(
    .INIT(64'h8888800080008000)) 
    \disp_seg_o_OBUF[6]_inst_i_28 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(dm_disp_data[2]),
        .I3(sw_i_IBUF[0]),
        .I4(spo[21]),
        .I5(sw_i_IBUF[3]),
        .O(\disp_seg_o_OBUF[6]_inst_i_28_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h0008FFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_29 
       (.I0(sw_i_IBUF[3]),
        .I1(spo[11]),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(selector),
        .O(\disp_seg_o_OBUF[6]_inst_i_29_n_0 ));
  LUT6 #(
    .INIT(64'hFEAA0000FFFFFFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_3 
       (.I0(selector),
        .I1(Q[1]),
        .I2(\disp_seg_o_OBUF[5]_inst_i_1_1 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_8_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_9_n_0 ),
        .I5(\disp_seg_o[5] ),
        .O(\disp_seg_o_OBUF[6]_inst_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h4444400040004000)) 
    \disp_seg_o_OBUF[6]_inst_i_30 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[14]),
        .I4(sw_i_IBUF[0]),
        .I5(dm_disp_data[2]),
        .O(\disp_seg_o_OBUF[6]_inst_i_30_n_0 ));
  LUT6 #(
    .INIT(64'h8888800080008000)) 
    \disp_seg_o_OBUF[6]_inst_i_32 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[23]),
        .I4(sw_i_IBUF[0]),
        .I5(dm_disp_data[4]),
        .O(\disp_seg_o_OBUF[6]_inst_i_32_n_0 ));
  LUT6 #(
    .INIT(64'h2222200020002000)) 
    \disp_seg_o_OBUF[6]_inst_i_33 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(dm_disp_data[0]),
        .I3(sw_i_IBUF[0]),
        .I4(sw_i_IBUF[3]),
        .I5(spo[19]),
        .O(\disp_seg_o_OBUF[6]_inst_i_33_n_0 ));
  LUT6 #(
    .INIT(64'h1111100010001000)) 
    \disp_seg_o_OBUF[6]_inst_i_34 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[12]),
        .I4(sw_i_IBUF[0]),
        .I5(dm_disp_data[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_34_n_0 ));
  LUT6 #(
    .INIT(64'h4444400040004000)) 
    \disp_seg_o_OBUF[6]_inst_i_35 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[16]),
        .I4(sw_i_IBUF[0]),
        .I5(dm_disp_data[4]),
        .O(\disp_seg_o_OBUF[6]_inst_i_35_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hFEEE)) 
    \disp_seg_o_OBUF[6]_inst_i_37 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\disp_seg_o_OBUF[6]_inst_i_20_0 [1]),
        .I3(sw_i_IBUF[2]),
        .O(\disp_seg_o_OBUF[6]_inst_i_37_n_0 ));
  LUT6 #(
    .INIT(64'h0000007000700070)) 
    \disp_seg_o_OBUF[6]_inst_i_38 
       (.I0(sw_i_IBUF[3]),
        .I1(spo[3]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(dm_disp_data[4]),
        .I5(sw_i_IBUF[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_38_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \disp_seg_o_OBUF[6]_inst_i_39 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\selector_reg[1]_0 ));
  LUT6 #(
    .INIT(64'h45454544FFFFFFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_4 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_10_n_0 ),
        .I1(selector),
        .I2(\disp_seg_o_OBUF[6]_inst_i_11_n_0 ),
        .I3(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_13_n_0 ),
        .I5(\disp_seg_o[5] ),
        .O(\disp_seg_o_OBUF[6]_inst_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000077700000000)) 
    \disp_seg_o_OBUF[6]_inst_i_40 
       (.I0(dm_disp_data[0]),
        .I1(sw_i_IBUF[0]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[7]),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(\disp_seg_o_OBUF[6]_inst_i_40_n_0 ));
  LUT6 #(
    .INIT(64'h0777000000000000)) 
    \disp_seg_o_OBUF[6]_inst_i_42 
       (.I0(sw_i_IBUF[3]),
        .I1(spo[9]),
        .I2(sw_i_IBUF[0]),
        .I3(dm_disp_data[3]),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_42_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000777)) 
    \disp_seg_o_OBUF[6]_inst_i_43 
       (.I0(spo[0]),
        .I1(sw_i_IBUF[3]),
        .I2(sw_i_IBUF[2]),
        .I3(\disp_seg_o_OBUF[6]_inst_i_20_0 [0]),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_43_n_0 ));
  LUT6 #(
    .INIT(64'h0000007000700070)) 
    \disp_seg_o_OBUF[6]_inst_i_44 
       (.I0(sw_i_IBUF[3]),
        .I1(spo[2]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(dm_disp_data[3]),
        .I5(sw_i_IBUF[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_44_n_0 ));
  LUT6 #(
    .INIT(64'hC0804000FFFFFFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_46 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[17]),
        .I4(spo[24]),
        .I5(selector),
        .O(\disp_seg_o_OBUF[6]_inst_i_46_n_0 ));
  LUT6 #(
    .INIT(64'h2222200020002000)) 
    \disp_seg_o_OBUF[6]_inst_i_47 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[20]),
        .I4(dm_disp_data[1]),
        .I5(sw_i_IBUF[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_47_n_0 ));
  LUT6 #(
    .INIT(64'h1111100010001000)) 
    \disp_seg_o_OBUF[6]_inst_i_48 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(sw_i_IBUF[3]),
        .I3(spo[13]),
        .I4(dm_disp_data[1]),
        .I5(sw_i_IBUF[0]),
        .O(\disp_seg_o_OBUF[6]_inst_i_48_n_0 ));
  LUT6 #(
    .INIT(64'hFEFEFEFE0000FF00)) 
    \disp_seg_o_OBUF[6]_inst_i_5 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_14_n_0 ),
        .I1(\disp_seg_o_OBUF[4]_inst_i_1_1 ),
        .I2(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_16_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_17_n_0 ),
        .I5(selector),
        .O(\disp_seg_o_OBUF[6]_inst_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h0070)) 
    \disp_seg_o_OBUF[6]_inst_i_50 
       (.I0(spo[4]),
        .I1(sw_i_IBUF[3]),
        .I2(Q[0]),
        .I3(Q[1]),
        .O(\disp_seg_o_OBUF[6]_inst_i_50_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hFEEE)) 
    \disp_seg_o_OBUF[6]_inst_i_51 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(\disp_seg_o_OBUF[6]_inst_i_20_0 [2]),
        .I3(sw_i_IBUF[2]),
        .O(\disp_seg_o_OBUF[6]_inst_i_51_n_0 ));
  LUT6 #(
    .INIT(64'h55544444FFFFFFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_6 
       (.I0(\disp_seg_o_OBUF[6]_inst_i_18_n_0 ),
        .I1(selector),
        .I2(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I3(\disp_seg_o_OBUF[5]_inst_i_1_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_20_n_0 ),
        .I5(\disp_seg_o[5] ),
        .O(\disp_seg_o_OBUF[6]_inst_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFEFEFEFEFEEEEEEE)) 
    \disp_seg_o_OBUF[6]_inst_i_8 
       (.I0(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_26_n_0 ),
        .I2(Q[0]),
        .I3(sw_i_IBUF[3]),
        .I4(spo[8]),
        .I5(\disp_seg_o_OBUF[6]_inst_i_3_0 ),
        .O(\disp_seg_o_OBUF[6]_inst_i_8_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \disp_seg_o_OBUF[6]_inst_i_9 
       (.I0(\disp_seg_o_OBUF[4]_inst_i_1_0 ),
        .I1(\disp_seg_o_OBUF[6]_inst_i_27_n_0 ),
        .I2(\disp_seg_o_OBUF[6]_inst_i_28_n_0 ),
        .I3(\disp_seg_o_OBUF[6]_inst_i_29_n_0 ),
        .I4(\disp_seg_o_OBUF[6]_inst_i_30_n_0 ),
        .O(\disp_seg_o_OBUF[6]_inst_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \selector[0]_i_1 
       (.I0(Q[0]),
        .O(\selector[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \selector[1]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(\selector[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \selector[2]_i_1 
       (.I0(selector),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(\selector[2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \selector_reg[0] 
       (.C(O643),
        .CE(1'b1),
        .D(\selector[0]_i_1_n_0 ),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \selector_reg[1] 
       (.C(O643),
        .CE(1'b1),
        .D(\selector[1]_i_1_n_0 ),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \selector_reg[2] 
       (.C(O643),
        .CE(1'b1),
        .D(\selector[2]_i_1_n_0 ),
        .Q(selector),
        .R(1'b0));
endmodule

(* CHECK_LICENSE_TYPE = "dist_mem_im,dist_mem_gen_v8_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *) 
module dist_mem_im
   (a,
    spo);
  input [5:0]a;
  output [31:0]spo;

  wire [5:0]a;
  wire [31:0]spo;
  wire [31:0]NLW_U0_dpo_UNCONNECTED;
  wire [31:0]NLW_U0_qdpo_UNCONNECTED;
  wire [31:0]NLW_U0_qspo_UNCONNECTED;

  (* C_FAMILY = "artix7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "6" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "64" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "dist_mem_im.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "32" *) 
  dist_mem_im_dist_mem_gen_v8_0_12 U0
       (.a(a),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[31:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[31:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[31:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(spo),
        .we(1'b0));
endmodule

module dm_addr_controller
   (Q,
    sw_i_IBUF,
    clk_used_BUFG,
    \data_out_reg[5]_0 );
  output [4:0]Q;
  input [0:0]sw_i_IBUF;
  input clk_used_BUFG;
  input \data_out_reg[5]_0 ;

  wire [4:0]Q;
  wire clk_used_BUFG;
  wire [6:2]data_out;
  wire \data_out[6]_i_1_n_0 ;
  wire \data_out_reg[5]_0 ;
  wire [0:0]sw_i_IBUF;

  LUT1 #(
    .INIT(2'h1)) 
    \data_out[2]_i_1 
       (.I0(Q[0]),
        .O(data_out[2]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \data_out[3]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(data_out[3]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \data_out[4]_i_1 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(Q[2]),
        .O(data_out[4]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \data_out[5]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[3]),
        .O(data_out[5]));
  LUT1 #(
    .INIT(2'h1)) 
    \data_out[6]_i_1 
       (.I0(sw_i_IBUF),
        .O(\data_out[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \data_out[6]_i_2 
       (.I0(Q[4]),
        .I1(Q[2]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[3]),
        .O(data_out[6]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[2] 
       (.C(clk_used_BUFG),
        .CE(\data_out[6]_i_1_n_0 ),
        .CLR(\data_out_reg[5]_0 ),
        .D(data_out[2]),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[3] 
       (.C(clk_used_BUFG),
        .CE(\data_out[6]_i_1_n_0 ),
        .CLR(\data_out_reg[5]_0 ),
        .D(data_out[3]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[4] 
       (.C(clk_used_BUFG),
        .CE(\data_out[6]_i_1_n_0 ),
        .CLR(\data_out_reg[5]_0 ),
        .D(data_out[4]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[5] 
       (.C(clk_used_BUFG),
        .CE(\data_out[6]_i_1_n_0 ),
        .CLR(\data_out_reg[5]_0 ),
        .D(data_out[5]),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \data_out_reg[6] 
       (.C(clk_used_BUFG),
        .CE(\data_out[6]_i_1_n_0 ),
        .CLR(\data_out_reg[5]_0 ),
        .D(data_out[6]),
        .Q(Q[4]));
endmodule

module instruction_memory
   (spo,
    E,
    \bbstub_spo[9] ,
    \bbstub_spo[7] ,
    \bbstub_spo[11] ,
    \bbstub_spo[11]_0 ,
    \bbstub_spo[11]_1 ,
    \bbstub_spo[11]_2 ,
    \bbstub_spo[11]_3 ,
    \bbstub_spo[11]_4 ,
    \bbstub_spo[11]_5 ,
    \bbstub_spo[10] ,
    \bbstub_spo[9]_0 ,
    \bbstub_spo[11]_6 ,
    \bbstub_spo[9]_1 ,
    \bbstub_spo[11]_7 ,
    \bbstub_spo[9]_2 ,
    \bbstub_spo[11]_8 ,
    \bbstub_spo[11]_9 ,
    \bbstub_spo[11]_10 ,
    \bbstub_spo[11]_11 ,
    \bbstub_spo[10]_0 ,
    \bbstub_spo[11]_12 ,
    \bbstub_spo[10]_1 ,
    \bbstub_spo[9]_3 ,
    \bbstub_spo[9]_4 ,
    \bbstub_spo[7]_0 ,
    \bbstub_spo[8] ,
    \bbstub_spo[8]_0 ,
    \bbstub_spo[10]_2 ,
    \bbstub_spo[10]_3 ,
    \bbstub_spo[10]_4 ,
    \disp_data_reg[29] ,
    \selector_reg[1] ,
    \selector_reg[0] ,
    \disp_data_reg[0] ,
    \disp_data_reg[27] ,
    \bbstub_spo[9]_5 ,
    \selector_reg[0]_0 ,
    out,
    dm_disp_data,
    sw_i_IBUF,
    \disp_seg_o_OBUF[6]_inst_i_5 ,
    Q,
    \disp_seg_o_OBUF[5]_inst_i_2 ,
    \disp_seg_o_OBUF[6]_inst_i_7 ,
    \disp_seg_o_OBUF[6]_inst_i_6 );
  output [28:0]spo;
  output [0:0]E;
  output [0:0]\bbstub_spo[9] ;
  output [0:0]\bbstub_spo[7] ;
  output [0:0]\bbstub_spo[11] ;
  output [0:0]\bbstub_spo[11]_0 ;
  output [0:0]\bbstub_spo[11]_1 ;
  output [0:0]\bbstub_spo[11]_2 ;
  output [0:0]\bbstub_spo[11]_3 ;
  output [0:0]\bbstub_spo[11]_4 ;
  output [0:0]\bbstub_spo[11]_5 ;
  output [0:0]\bbstub_spo[10] ;
  output [0:0]\bbstub_spo[9]_0 ;
  output [0:0]\bbstub_spo[11]_6 ;
  output [0:0]\bbstub_spo[9]_1 ;
  output [0:0]\bbstub_spo[11]_7 ;
  output [0:0]\bbstub_spo[9]_2 ;
  output [0:0]\bbstub_spo[11]_8 ;
  output [0:0]\bbstub_spo[11]_9 ;
  output [0:0]\bbstub_spo[11]_10 ;
  output [0:0]\bbstub_spo[11]_11 ;
  output [0:0]\bbstub_spo[10]_0 ;
  output [0:0]\bbstub_spo[11]_12 ;
  output [0:0]\bbstub_spo[10]_1 ;
  output [0:0]\bbstub_spo[9]_3 ;
  output [0:0]\bbstub_spo[9]_4 ;
  output [0:0]\bbstub_spo[7]_0 ;
  output [0:0]\bbstub_spo[8] ;
  output [0:0]\bbstub_spo[8]_0 ;
  output [0:0]\bbstub_spo[10]_2 ;
  output [0:0]\bbstub_spo[10]_3 ;
  output [0:0]\bbstub_spo[10]_4 ;
  output \disp_data_reg[29] ;
  output \selector_reg[1] ;
  output \selector_reg[0] ;
  output \disp_data_reg[0] ;
  output \disp_data_reg[27] ;
  output [0:0]\bbstub_spo[9]_5 ;
  output \selector_reg[0]_0 ;
  input [4:0]out;
  input [1:0]dm_disp_data;
  input [2:0]sw_i_IBUF;
  input \disp_seg_o_OBUF[6]_inst_i_5 ;
  input [1:0]Q;
  input \disp_seg_o_OBUF[5]_inst_i_2 ;
  input [0:0]\disp_seg_o_OBUF[6]_inst_i_7 ;
  input \disp_seg_o_OBUF[6]_inst_i_6 ;

  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]\bbstub_spo[10] ;
  wire [0:0]\bbstub_spo[10]_0 ;
  wire [0:0]\bbstub_spo[10]_1 ;
  wire [0:0]\bbstub_spo[10]_2 ;
  wire [0:0]\bbstub_spo[10]_3 ;
  wire [0:0]\bbstub_spo[10]_4 ;
  wire [0:0]\bbstub_spo[11] ;
  wire [0:0]\bbstub_spo[11]_0 ;
  wire [0:0]\bbstub_spo[11]_1 ;
  wire [0:0]\bbstub_spo[11]_10 ;
  wire [0:0]\bbstub_spo[11]_11 ;
  wire [0:0]\bbstub_spo[11]_12 ;
  wire [0:0]\bbstub_spo[11]_2 ;
  wire [0:0]\bbstub_spo[11]_3 ;
  wire [0:0]\bbstub_spo[11]_4 ;
  wire [0:0]\bbstub_spo[11]_5 ;
  wire [0:0]\bbstub_spo[11]_6 ;
  wire [0:0]\bbstub_spo[11]_7 ;
  wire [0:0]\bbstub_spo[11]_8 ;
  wire [0:0]\bbstub_spo[11]_9 ;
  wire [0:0]\bbstub_spo[7] ;
  wire [0:0]\bbstub_spo[7]_0 ;
  wire [0:0]\bbstub_spo[8] ;
  wire [0:0]\bbstub_spo[8]_0 ;
  wire [0:0]\bbstub_spo[9] ;
  wire [0:0]\bbstub_spo[9]_0 ;
  wire [0:0]\bbstub_spo[9]_1 ;
  wire [0:0]\bbstub_spo[9]_2 ;
  wire [0:0]\bbstub_spo[9]_3 ;
  wire [0:0]\bbstub_spo[9]_4 ;
  wire [0:0]\bbstub_spo[9]_5 ;
  wire \disp_data_reg[0] ;
  wire \disp_data_reg[27] ;
  wire \disp_data_reg[29] ;
  wire \disp_seg_o_OBUF[5]_inst_i_2 ;
  wire \disp_seg_o_OBUF[6]_inst_i_5 ;
  wire \disp_seg_o_OBUF[6]_inst_i_6 ;
  wire [0:0]\disp_seg_o_OBUF[6]_inst_i_7 ;
  wire [1:0]dm_disp_data;
  wire [25:0]instr;
  wire [4:0]out;
  wire \selector_reg[0] ;
  wire \selector_reg[0]_0 ;
  wire \selector_reg[1] ;
  wire [28:0]spo;
  wire [2:0]sw_i_IBUF;

  LUT6 #(
    .INIT(64'hEFEFEF2FCF0FCF0F)) 
    \disp_seg_o_OBUF[5]_inst_i_4 
       (.I0(spo[7]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(\disp_seg_o_OBUF[5]_inst_i_2 ),
        .I4(spo[11]),
        .I5(sw_i_IBUF[2]),
        .O(\selector_reg[0] ));
  LUT6 #(
    .INIT(64'hAAAAAAAAFFEAEAEA)) 
    \disp_seg_o_OBUF[6]_inst_i_15 
       (.I0(\selector_reg[1] ),
        .I1(dm_disp_data[1]),
        .I2(sw_i_IBUF[0]),
        .I3(spo[26]),
        .I4(sw_i_IBUF[2]),
        .I5(\disp_seg_o_OBUF[6]_inst_i_5 ),
        .O(\disp_data_reg[29] ));
  LUT6 #(
    .INIT(64'h8F8F8C80FFFFFFFF)) 
    \disp_seg_o_OBUF[6]_inst_i_19 
       (.I0(spo[13]),
        .I1(sw_i_IBUF[2]),
        .I2(Q[0]),
        .I3(spo[9]),
        .I4(\disp_seg_o_OBUF[6]_inst_i_6 ),
        .I5(Q[1]),
        .O(\selector_reg[0]_0 ));
  LUT5 #(
    .INIT(32'hFFFFF888)) 
    \disp_seg_o_OBUF[6]_inst_i_24 
       (.I0(instr[0]),
        .I1(sw_i_IBUF[2]),
        .I2(sw_i_IBUF[1]),
        .I3(\disp_seg_o_OBUF[6]_inst_i_7 ),
        .I4(Q[0]),
        .O(\disp_data_reg[0] ));
  LUT6 #(
    .INIT(64'h00000000EECCFCCC)) 
    \disp_seg_o_OBUF[6]_inst_i_41 
       (.I0(instr[25]),
        .I1(sw_i_IBUF[0]),
        .I2(spo[15]),
        .I3(sw_i_IBUF[2]),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(\selector_reg[1] ));
  LUT4 #(
    .INIT(16'hF888)) 
    \disp_seg_o_OBUF[6]_inst_i_52 
       (.I0(instr[3]),
        .I1(sw_i_IBUF[2]),
        .I2(sw_i_IBUF[0]),
        .I3(dm_disp_data[0]),
        .O(\disp_data_reg[27] ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \register_file[0][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[9]),
        .I4(spo[7]),
        .O(\bbstub_spo[9] ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[10][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[7]),
        .I2(spo[8]),
        .I3(spo[5]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_8 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[11][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[9]),
        .I4(spo[8]),
        .O(\bbstub_spo[10] ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[12][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[5]),
        .I2(spo[8]),
        .I3(spo[6]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_9 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[13][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[7]),
        .I2(spo[5]),
        .I3(spo[9]),
        .I4(spo[8]),
        .O(\bbstub_spo[10]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[14][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[6]),
        .I2(spo[7]),
        .I3(spo[9]),
        .I4(spo[8]),
        .O(\bbstub_spo[10]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    \register_file[15][4]_i_1 
       (.I0(spo[9]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[8]),
        .I4(spo[7]),
        .O(\bbstub_spo[9]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \register_file[16][4]_i_1 
       (.I0(spo[9]),
        .I1(spo[7]),
        .I2(spo[6]),
        .I3(spo[8]),
        .I4(spo[5]),
        .O(\bbstub_spo[7] ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[17][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[7]),
        .I2(spo[9]),
        .I3(spo[8]),
        .I4(spo[6]),
        .O(\bbstub_spo[8]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[18][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[7]),
        .I2(spo[9]),
        .I3(spo[8]),
        .I4(spo[5]),
        .O(\bbstub_spo[7]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[19][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[7]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_6 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \register_file[1][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[7]),
        .I2(spo[6]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[20][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[5]),
        .I2(spo[9]),
        .I3(spo[8]),
        .I4(spo[6]),
        .O(\bbstub_spo[8] ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[21][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[7]),
        .I2(spo[5]),
        .I3(spo[6]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_11 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[22][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[6]),
        .I2(spo[7]),
        .I3(spo[5]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_12 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    \register_file[23][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[9]),
        .I4(spo[7]),
        .O(\bbstub_spo[9]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[24][4]_i_1 
       (.I0(spo[9]),
        .I1(spo[7]),
        .I2(spo[8]),
        .I3(spo[6]),
        .I4(spo[5]),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[25][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[9]),
        .I2(spo[5]),
        .I3(spo[6]),
        .I4(spo[8]),
        .O(\bbstub_spo[10]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[26][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[6]),
        .I2(spo[9]),
        .I3(spo[5]),
        .I4(spo[8]),
        .O(\bbstub_spo[10]_3 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    \register_file[27][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_7 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[28][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[7]),
        .I2(spo[9]),
        .I3(spo[5]),
        .I4(spo[8]),
        .O(\bbstub_spo[10]_4 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    \register_file[29][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[9]),
        .I2(spo[5]),
        .I3(spo[8]),
        .I4(spo[7]),
        .O(\bbstub_spo[9]_3 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \register_file[2][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[7]),
        .I2(spo[5]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_5 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h40000000)) 
    \register_file[30][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[6]),
        .I2(spo[9]),
        .I3(spo[8]),
        .I4(spo[7]),
        .O(\bbstub_spo[9]_4 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \register_file[31][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[9]),
        .I4(spo[7]),
        .O(\bbstub_spo[9]_5 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[3][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[7]),
        .I2(spo[6]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_1 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \register_file[4][4]_i_1 
       (.I0(spo[7]),
        .I1(spo[5]),
        .I2(spo[6]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_4 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[5][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[6]),
        .I2(spo[7]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[6][4]_i_1 
       (.I0(spo[6]),
        .I1(spo[5]),
        .I2(spo[7]),
        .I3(spo[8]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_3 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    \register_file[7][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[6]),
        .I2(spo[5]),
        .I3(spo[9]),
        .I4(spo[7]),
        .O(\bbstub_spo[9]_2 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \register_file[8][4]_i_1 
       (.I0(spo[8]),
        .I1(spo[7]),
        .I2(spo[6]),
        .I3(spo[5]),
        .I4(spo[9]),
        .O(\bbstub_spo[11] ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \register_file[9][4]_i_1 
       (.I0(spo[5]),
        .I1(spo[7]),
        .I2(spo[8]),
        .I3(spo[6]),
        .I4(spo[9]),
        .O(\bbstub_spo[11]_10 ));
  (* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *) 
  dist_mem_im u_im
       (.a({1'b0,out}),
        .spo({spo[28:23],instr[25],spo[22:2],instr[3],spo[1:0],instr[0]}));
endmodule

module pc
   (out,
    clk_used_BUFG,
    \pc_reg[4]_0 ,
    sw_i_IBUF);
  output [4:0]out;
  input clk_used_BUFG;
  input \pc_reg[4]_0 ;
  input [0:0]sw_i_IBUF;

  wire clk_used_BUFG;
  wire [1:0]npc;
  wire [4:0]out;
  wire \pc[2]_i_1_n_0 ;
  wire \pc[3]_i_1_n_0 ;
  wire \pc[4]_i_1_n_0 ;
  wire \pc[4]_i_2_n_0 ;
  wire \pc_reg[4]_0 ;
  wire [0:0]sw_i_IBUF;

  LUT1 #(
    .INIT(2'h1)) 
    \pc[0]_i_1 
       (.I0(out[0]),
        .O(npc[0]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \pc[1]_i_1 
       (.I0(out[0]),
        .I1(out[1]),
        .O(npc[1]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \pc[2]_i_1 
       (.I0(out[0]),
        .I1(out[1]),
        .I2(out[2]),
        .O(\pc[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \pc[3]_i_1 
       (.I0(out[2]),
        .I1(out[1]),
        .I2(out[0]),
        .I3(out[3]),
        .O(\pc[3]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \pc[4]_i_1 
       (.I0(sw_i_IBUF),
        .O(\pc[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \pc[4]_i_2 
       (.I0(out[3]),
        .I1(out[0]),
        .I2(out[1]),
        .I3(out[2]),
        .I4(out[4]),
        .O(\pc[4]_i_2_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \pc_reg[0] 
       (.C(clk_used_BUFG),
        .CE(\pc[4]_i_1_n_0 ),
        .CLR(\pc_reg[4]_0 ),
        .D(npc[0]),
        .Q(out[0]));
  FDCE #(
    .INIT(1'b0)) 
    \pc_reg[1] 
       (.C(clk_used_BUFG),
        .CE(\pc[4]_i_1_n_0 ),
        .CLR(\pc_reg[4]_0 ),
        .D(npc[1]),
        .Q(out[1]));
  FDCE #(
    .INIT(1'b0)) 
    \pc_reg[2] 
       (.C(clk_used_BUFG),
        .CE(\pc[4]_i_1_n_0 ),
        .CLR(\pc_reg[4]_0 ),
        .D(\pc[2]_i_1_n_0 ),
        .Q(out[2]));
  FDCE #(
    .INIT(1'b0)) 
    \pc_reg[3] 
       (.C(clk_used_BUFG),
        .CE(\pc[4]_i_1_n_0 ),
        .CLR(\pc_reg[4]_0 ),
        .D(\pc[3]_i_1_n_0 ),
        .Q(out[3]));
  FDCE #(
    .INIT(1'b0)) 
    \pc_reg[4] 
       (.C(clk_used_BUFG),
        .CE(\pc[4]_i_1_n_0 ),
        .CLR(\pc_reg[4]_0 ),
        .D(\pc[4]_i_2_n_0 ),
        .Q(out[4]));
endmodule

module register_file
   (\disp_data_reg[4]_0 ,
    \disp_data_reg[3]_0 ,
    rstn,
    \rs1_data_reg[4]_0 ,
    \rs2_data_reg[4]_0 ,
    spo,
    Q,
    sw_i_IBUF,
    E,
    clk_used_BUFG,
    \register_file_reg[29][4]_0 ,
    \register_file_reg[28][4]_0 ,
    \register_file_reg[27][4]_0 ,
    \register_file_reg[26][4]_0 ,
    \register_file_reg[25][4]_0 ,
    \register_file_reg[24][4]_0 ,
    \register_file_reg[23][4]_0 ,
    \register_file_reg[22][4]_0 ,
    \register_file_reg[21][4]_0 ,
    \register_file_reg[20][4]_0 ,
    \register_file_reg[19][4]_0 ,
    \register_file_reg[18][4]_0 ,
    \register_file_reg[17][4]_0 ,
    \register_file_reg[16][4]_0 ,
    \register_file_reg[15][4]_0 ,
    \register_file_reg[14][4]_0 ,
    \register_file_reg[13][4]_0 ,
    \register_file_reg[12][4]_0 ,
    \register_file_reg[11][4]_0 ,
    \register_file_reg[10][4]_0 ,
    \register_file_reg[9][4]_0 ,
    \register_file_reg[8][4]_0 ,
    \register_file_reg[7][4]_0 ,
    \register_file_reg[6][4]_0 ,
    \register_file_reg[5][4]_0 ,
    \register_file_reg[4][4]_0 ,
    \register_file_reg[3][4]_0 ,
    \register_file_reg[2][4]_0 ,
    \register_file_reg[1][4]_0 ,
    \register_file_reg[0][4]_0 ,
    rstn_IBUF,
    \register_file_reg[31][0]_0 );
  output \disp_data_reg[4]_0 ;
  output [3:0]\disp_data_reg[3]_0 ;
  output rstn;
  output [4:0]\rs1_data_reg[4]_0 ;
  output [4:0]\rs2_data_reg[4]_0 ;
  input [15:0]spo;
  input [4:0]Q;
  input [1:0]sw_i_IBUF;
  input [0:0]E;
  input clk_used_BUFG;
  input [0:0]\register_file_reg[29][4]_0 ;
  input [0:0]\register_file_reg[28][4]_0 ;
  input [0:0]\register_file_reg[27][4]_0 ;
  input [0:0]\register_file_reg[26][4]_0 ;
  input [0:0]\register_file_reg[25][4]_0 ;
  input [0:0]\register_file_reg[24][4]_0 ;
  input [0:0]\register_file_reg[23][4]_0 ;
  input [0:0]\register_file_reg[22][4]_0 ;
  input [0:0]\register_file_reg[21][4]_0 ;
  input [0:0]\register_file_reg[20][4]_0 ;
  input [0:0]\register_file_reg[19][4]_0 ;
  input [0:0]\register_file_reg[18][4]_0 ;
  input [0:0]\register_file_reg[17][4]_0 ;
  input [0:0]\register_file_reg[16][4]_0 ;
  input [0:0]\register_file_reg[15][4]_0 ;
  input [0:0]\register_file_reg[14][4]_0 ;
  input [0:0]\register_file_reg[13][4]_0 ;
  input [0:0]\register_file_reg[12][4]_0 ;
  input [0:0]\register_file_reg[11][4]_0 ;
  input [0:0]\register_file_reg[10][4]_0 ;
  input [0:0]\register_file_reg[9][4]_0 ;
  input [0:0]\register_file_reg[8][4]_0 ;
  input [0:0]\register_file_reg[7][4]_0 ;
  input [0:0]\register_file_reg[6][4]_0 ;
  input [0:0]\register_file_reg[5][4]_0 ;
  input [0:0]\register_file_reg[4][4]_0 ;
  input [0:0]\register_file_reg[3][4]_0 ;
  input [0:0]\register_file_reg[2][4]_0 ;
  input [0:0]\register_file_reg[1][4]_0 ;
  input [0:0]\register_file_reg[0][4]_0 ;
  input rstn_IBUF;
  input [0:0]\register_file_reg[31][0]_0 ;

  wire [0:0]E;
  wire [4:0]Q;
  wire clk_used_BUFG;
  wire \disp_data[0]_i_10_n_0 ;
  wire \disp_data[0]_i_11_n_0 ;
  wire \disp_data[0]_i_12_n_0 ;
  wire \disp_data[0]_i_13_n_0 ;
  wire \disp_data[0]_i_1_n_0 ;
  wire \disp_data[0]_i_6_n_0 ;
  wire \disp_data[0]_i_7_n_0 ;
  wire \disp_data[0]_i_8_n_0 ;
  wire \disp_data[0]_i_9_n_0 ;
  wire \disp_data[1]_i_10_n_0 ;
  wire \disp_data[1]_i_11_n_0 ;
  wire \disp_data[1]_i_12_n_0 ;
  wire \disp_data[1]_i_13_n_0 ;
  wire \disp_data[1]_i_1_n_0 ;
  wire \disp_data[1]_i_6_n_0 ;
  wire \disp_data[1]_i_7_n_0 ;
  wire \disp_data[1]_i_8_n_0 ;
  wire \disp_data[1]_i_9_n_0 ;
  wire \disp_data[2]_i_10_n_0 ;
  wire \disp_data[2]_i_11_n_0 ;
  wire \disp_data[2]_i_12_n_0 ;
  wire \disp_data[2]_i_13_n_0 ;
  wire \disp_data[2]_i_1_n_0 ;
  wire \disp_data[2]_i_6_n_0 ;
  wire \disp_data[2]_i_7_n_0 ;
  wire \disp_data[2]_i_8_n_0 ;
  wire \disp_data[2]_i_9_n_0 ;
  wire \disp_data[3]_i_10_n_0 ;
  wire \disp_data[3]_i_11_n_0 ;
  wire \disp_data[3]_i_12_n_0 ;
  wire \disp_data[3]_i_13_n_0 ;
  wire \disp_data[3]_i_1_n_0 ;
  wire \disp_data[3]_i_6_n_0 ;
  wire \disp_data[3]_i_7_n_0 ;
  wire \disp_data[3]_i_8_n_0 ;
  wire \disp_data[3]_i_9_n_0 ;
  wire \disp_data[4]_i_10_n_0 ;
  wire \disp_data[4]_i_11_n_0 ;
  wire \disp_data[4]_i_12_n_0 ;
  wire \disp_data[4]_i_13_n_0 ;
  wire \disp_data[4]_i_1_n_0 ;
  wire \disp_data[4]_i_6_n_0 ;
  wire \disp_data[4]_i_7_n_0 ;
  wire \disp_data[4]_i_8_n_0 ;
  wire \disp_data[4]_i_9_n_0 ;
  wire \disp_data_reg[0]_i_2_n_0 ;
  wire \disp_data_reg[0]_i_3_n_0 ;
  wire \disp_data_reg[0]_i_4_n_0 ;
  wire \disp_data_reg[0]_i_5_n_0 ;
  wire \disp_data_reg[1]_i_2_n_0 ;
  wire \disp_data_reg[1]_i_3_n_0 ;
  wire \disp_data_reg[1]_i_4_n_0 ;
  wire \disp_data_reg[1]_i_5_n_0 ;
  wire \disp_data_reg[2]_i_2_n_0 ;
  wire \disp_data_reg[2]_i_3_n_0 ;
  wire \disp_data_reg[2]_i_4_n_0 ;
  wire \disp_data_reg[2]_i_5_n_0 ;
  wire [3:0]\disp_data_reg[3]_0 ;
  wire \disp_data_reg[3]_i_2_n_0 ;
  wire \disp_data_reg[3]_i_3_n_0 ;
  wire \disp_data_reg[3]_i_4_n_0 ;
  wire \disp_data_reg[3]_i_5_n_0 ;
  wire \disp_data_reg[4]_0 ;
  wire \disp_data_reg[4]_i_2_n_0 ;
  wire \disp_data_reg[4]_i_3_n_0 ;
  wire \disp_data_reg[4]_i_4_n_0 ;
  wire \disp_data_reg[4]_i_5_n_0 ;
  wire [4:0]register_file;
  wire \register_file[30][0]_i_10_n_0 ;
  wire \register_file[30][0]_i_11_n_0 ;
  wire \register_file[30][0]_i_12_n_0 ;
  wire \register_file[30][0]_i_13_n_0 ;
  wire \register_file[30][0]_i_6_n_0 ;
  wire \register_file[30][0]_i_7_n_0 ;
  wire \register_file[30][0]_i_8_n_0 ;
  wire \register_file[30][0]_i_9_n_0 ;
  wire \register_file[30][1]_i_10_n_0 ;
  wire \register_file[30][1]_i_11_n_0 ;
  wire \register_file[30][1]_i_12_n_0 ;
  wire \register_file[30][1]_i_13_n_0 ;
  wire \register_file[30][1]_i_6_n_0 ;
  wire \register_file[30][1]_i_7_n_0 ;
  wire \register_file[30][1]_i_8_n_0 ;
  wire \register_file[30][1]_i_9_n_0 ;
  wire \register_file[30][2]_i_10_n_0 ;
  wire \register_file[30][2]_i_11_n_0 ;
  wire \register_file[30][2]_i_12_n_0 ;
  wire \register_file[30][2]_i_13_n_0 ;
  wire \register_file[30][2]_i_6_n_0 ;
  wire \register_file[30][2]_i_7_n_0 ;
  wire \register_file[30][2]_i_8_n_0 ;
  wire \register_file[30][2]_i_9_n_0 ;
  wire \register_file[30][3]_i_10_n_0 ;
  wire \register_file[30][3]_i_11_n_0 ;
  wire \register_file[30][3]_i_12_n_0 ;
  wire \register_file[30][3]_i_13_n_0 ;
  wire \register_file[30][3]_i_6_n_0 ;
  wire \register_file[30][3]_i_7_n_0 ;
  wire \register_file[30][3]_i_8_n_0 ;
  wire \register_file[30][3]_i_9_n_0 ;
  wire \register_file[30][4]_i_10_n_0 ;
  wire \register_file[30][4]_i_11_n_0 ;
  wire \register_file[30][4]_i_12_n_0 ;
  wire \register_file[30][4]_i_13_n_0 ;
  wire \register_file[30][4]_i_14_n_0 ;
  wire \register_file[30][4]_i_15_n_0 ;
  wire \register_file[30][4]_i_8_n_0 ;
  wire \register_file[30][4]_i_9_n_0 ;
  wire [0:0]\register_file_reg[0][4]_0 ;
  wire [4:0]\register_file_reg[0]__0 ;
  wire [0:0]\register_file_reg[10][4]_0 ;
  wire [4:0]\register_file_reg[10]__0 ;
  wire [0:0]\register_file_reg[11][4]_0 ;
  wire [4:0]\register_file_reg[11]__0 ;
  wire [0:0]\register_file_reg[12][4]_0 ;
  wire [4:0]\register_file_reg[12]__0 ;
  wire [0:0]\register_file_reg[13][4]_0 ;
  wire [4:0]\register_file_reg[13]__0 ;
  wire [0:0]\register_file_reg[14][4]_0 ;
  wire [4:0]\register_file_reg[14]__0 ;
  wire [0:0]\register_file_reg[15][4]_0 ;
  wire [4:0]\register_file_reg[15]__0 ;
  wire [0:0]\register_file_reg[16][4]_0 ;
  wire [4:0]\register_file_reg[16]__0 ;
  wire [0:0]\register_file_reg[17][4]_0 ;
  wire [4:0]\register_file_reg[17]__0 ;
  wire [0:0]\register_file_reg[18][4]_0 ;
  wire [4:0]\register_file_reg[18]__0 ;
  wire [0:0]\register_file_reg[19][4]_0 ;
  wire [4:0]\register_file_reg[19]__0 ;
  wire [0:0]\register_file_reg[1][4]_0 ;
  wire [4:0]\register_file_reg[1]__0 ;
  wire [0:0]\register_file_reg[20][4]_0 ;
  wire [4:0]\register_file_reg[20]__0 ;
  wire [0:0]\register_file_reg[21][4]_0 ;
  wire [4:0]\register_file_reg[21]__0 ;
  wire [0:0]\register_file_reg[22][4]_0 ;
  wire [4:0]\register_file_reg[22]__0 ;
  wire [0:0]\register_file_reg[23][4]_0 ;
  wire [4:0]\register_file_reg[23]__0 ;
  wire [0:0]\register_file_reg[24][4]_0 ;
  wire [4:0]\register_file_reg[24]__0 ;
  wire [0:0]\register_file_reg[25][4]_0 ;
  wire [4:0]\register_file_reg[25]__0 ;
  wire [0:0]\register_file_reg[26][4]_0 ;
  wire [4:0]\register_file_reg[26]__0 ;
  wire [0:0]\register_file_reg[27][4]_0 ;
  wire [4:0]\register_file_reg[27]__0 ;
  wire [0:0]\register_file_reg[28][4]_0 ;
  wire [4:0]\register_file_reg[28]__0 ;
  wire [0:0]\register_file_reg[29][4]_0 ;
  wire [4:0]\register_file_reg[29]__0 ;
  wire [0:0]\register_file_reg[2][4]_0 ;
  wire [4:0]\register_file_reg[2]__0 ;
  wire \register_file_reg[30][0]_i_2_n_0 ;
  wire \register_file_reg[30][0]_i_3_n_0 ;
  wire \register_file_reg[30][0]_i_4_n_0 ;
  wire \register_file_reg[30][0]_i_5_n_0 ;
  wire \register_file_reg[30][1]_i_2_n_0 ;
  wire \register_file_reg[30][1]_i_3_n_0 ;
  wire \register_file_reg[30][1]_i_4_n_0 ;
  wire \register_file_reg[30][1]_i_5_n_0 ;
  wire \register_file_reg[30][2]_i_2_n_0 ;
  wire \register_file_reg[30][2]_i_3_n_0 ;
  wire \register_file_reg[30][2]_i_4_n_0 ;
  wire \register_file_reg[30][2]_i_5_n_0 ;
  wire \register_file_reg[30][3]_i_2_n_0 ;
  wire \register_file_reg[30][3]_i_3_n_0 ;
  wire \register_file_reg[30][3]_i_4_n_0 ;
  wire \register_file_reg[30][3]_i_5_n_0 ;
  wire \register_file_reg[30][4]_i_4_n_0 ;
  wire \register_file_reg[30][4]_i_5_n_0 ;
  wire \register_file_reg[30][4]_i_6_n_0 ;
  wire \register_file_reg[30][4]_i_7_n_0 ;
  wire [4:0]\register_file_reg[30]__0 ;
  wire [0:0]\register_file_reg[31][0]_0 ;
  wire [4:0]\register_file_reg[31]__0 ;
  wire [0:0]\register_file_reg[3][4]_0 ;
  wire [4:0]\register_file_reg[3]__0 ;
  wire [0:0]\register_file_reg[4][4]_0 ;
  wire [4:0]\register_file_reg[4]__0 ;
  wire [0:0]\register_file_reg[5][4]_0 ;
  wire [4:0]\register_file_reg[5]__0 ;
  wire [0:0]\register_file_reg[6][4]_0 ;
  wire [4:0]\register_file_reg[6]__0 ;
  wire [0:0]\register_file_reg[7][4]_0 ;
  wire [4:0]\register_file_reg[7]__0 ;
  wire [0:0]\register_file_reg[8][4]_0 ;
  wire [4:0]\register_file_reg[8]__0 ;
  wire [0:0]\register_file_reg[9][4]_0 ;
  wire [4:0]\register_file_reg[9]__0 ;
  wire [4:4]rf_disp_data;
  wire \rs1_data[0]_i_10_n_0 ;
  wire \rs1_data[0]_i_11_n_0 ;
  wire \rs1_data[0]_i_12_n_0 ;
  wire \rs1_data[0]_i_13_n_0 ;
  wire \rs1_data[0]_i_1_n_0 ;
  wire \rs1_data[0]_i_6_n_0 ;
  wire \rs1_data[0]_i_7_n_0 ;
  wire \rs1_data[0]_i_8_n_0 ;
  wire \rs1_data[0]_i_9_n_0 ;
  wire \rs1_data[1]_i_10_n_0 ;
  wire \rs1_data[1]_i_11_n_0 ;
  wire \rs1_data[1]_i_12_n_0 ;
  wire \rs1_data[1]_i_13_n_0 ;
  wire \rs1_data[1]_i_1_n_0 ;
  wire \rs1_data[1]_i_6_n_0 ;
  wire \rs1_data[1]_i_7_n_0 ;
  wire \rs1_data[1]_i_8_n_0 ;
  wire \rs1_data[1]_i_9_n_0 ;
  wire \rs1_data[2]_i_10_n_0 ;
  wire \rs1_data[2]_i_11_n_0 ;
  wire \rs1_data[2]_i_12_n_0 ;
  wire \rs1_data[2]_i_13_n_0 ;
  wire \rs1_data[2]_i_1_n_0 ;
  wire \rs1_data[2]_i_6_n_0 ;
  wire \rs1_data[2]_i_7_n_0 ;
  wire \rs1_data[2]_i_8_n_0 ;
  wire \rs1_data[2]_i_9_n_0 ;
  wire \rs1_data[3]_i_10_n_0 ;
  wire \rs1_data[3]_i_11_n_0 ;
  wire \rs1_data[3]_i_12_n_0 ;
  wire \rs1_data[3]_i_13_n_0 ;
  wire \rs1_data[3]_i_1_n_0 ;
  wire \rs1_data[3]_i_6_n_0 ;
  wire \rs1_data[3]_i_7_n_0 ;
  wire \rs1_data[3]_i_8_n_0 ;
  wire \rs1_data[3]_i_9_n_0 ;
  wire \rs1_data[4]_i_10_n_0 ;
  wire \rs1_data[4]_i_11_n_0 ;
  wire \rs1_data[4]_i_12_n_0 ;
  wire \rs1_data[4]_i_13_n_0 ;
  wire \rs1_data[4]_i_1_n_0 ;
  wire \rs1_data[4]_i_6_n_0 ;
  wire \rs1_data[4]_i_7_n_0 ;
  wire \rs1_data[4]_i_8_n_0 ;
  wire \rs1_data[4]_i_9_n_0 ;
  wire \rs1_data_reg[0]_i_2_n_0 ;
  wire \rs1_data_reg[0]_i_3_n_0 ;
  wire \rs1_data_reg[0]_i_4_n_0 ;
  wire \rs1_data_reg[0]_i_5_n_0 ;
  wire \rs1_data_reg[1]_i_2_n_0 ;
  wire \rs1_data_reg[1]_i_3_n_0 ;
  wire \rs1_data_reg[1]_i_4_n_0 ;
  wire \rs1_data_reg[1]_i_5_n_0 ;
  wire \rs1_data_reg[2]_i_2_n_0 ;
  wire \rs1_data_reg[2]_i_3_n_0 ;
  wire \rs1_data_reg[2]_i_4_n_0 ;
  wire \rs1_data_reg[2]_i_5_n_0 ;
  wire \rs1_data_reg[3]_i_2_n_0 ;
  wire \rs1_data_reg[3]_i_3_n_0 ;
  wire \rs1_data_reg[3]_i_4_n_0 ;
  wire \rs1_data_reg[3]_i_5_n_0 ;
  wire [4:0]\rs1_data_reg[4]_0 ;
  wire \rs1_data_reg[4]_i_2_n_0 ;
  wire \rs1_data_reg[4]_i_3_n_0 ;
  wire \rs1_data_reg[4]_i_4_n_0 ;
  wire \rs1_data_reg[4]_i_5_n_0 ;
  wire \rs2_data[0]_i_10_n_0 ;
  wire \rs2_data[0]_i_11_n_0 ;
  wire \rs2_data[0]_i_12_n_0 ;
  wire \rs2_data[0]_i_13_n_0 ;
  wire \rs2_data[0]_i_1_n_0 ;
  wire \rs2_data[0]_i_6_n_0 ;
  wire \rs2_data[0]_i_7_n_0 ;
  wire \rs2_data[0]_i_8_n_0 ;
  wire \rs2_data[0]_i_9_n_0 ;
  wire \rs2_data[1]_i_10_n_0 ;
  wire \rs2_data[1]_i_11_n_0 ;
  wire \rs2_data[1]_i_12_n_0 ;
  wire \rs2_data[1]_i_13_n_0 ;
  wire \rs2_data[1]_i_1_n_0 ;
  wire \rs2_data[1]_i_6_n_0 ;
  wire \rs2_data[1]_i_7_n_0 ;
  wire \rs2_data[1]_i_8_n_0 ;
  wire \rs2_data[1]_i_9_n_0 ;
  wire \rs2_data[2]_i_10_n_0 ;
  wire \rs2_data[2]_i_11_n_0 ;
  wire \rs2_data[2]_i_12_n_0 ;
  wire \rs2_data[2]_i_13_n_0 ;
  wire \rs2_data[2]_i_1_n_0 ;
  wire \rs2_data[2]_i_6_n_0 ;
  wire \rs2_data[2]_i_7_n_0 ;
  wire \rs2_data[2]_i_8_n_0 ;
  wire \rs2_data[2]_i_9_n_0 ;
  wire \rs2_data[3]_i_10_n_0 ;
  wire \rs2_data[3]_i_11_n_0 ;
  wire \rs2_data[3]_i_12_n_0 ;
  wire \rs2_data[3]_i_13_n_0 ;
  wire \rs2_data[3]_i_1_n_0 ;
  wire \rs2_data[3]_i_6_n_0 ;
  wire \rs2_data[3]_i_7_n_0 ;
  wire \rs2_data[3]_i_8_n_0 ;
  wire \rs2_data[3]_i_9_n_0 ;
  wire \rs2_data[4]_i_10_n_0 ;
  wire \rs2_data[4]_i_11_n_0 ;
  wire \rs2_data[4]_i_12_n_0 ;
  wire \rs2_data[4]_i_13_n_0 ;
  wire \rs2_data[4]_i_1_n_0 ;
  wire \rs2_data[4]_i_6_n_0 ;
  wire \rs2_data[4]_i_7_n_0 ;
  wire \rs2_data[4]_i_8_n_0 ;
  wire \rs2_data[4]_i_9_n_0 ;
  wire \rs2_data_reg[0]_i_2_n_0 ;
  wire \rs2_data_reg[0]_i_3_n_0 ;
  wire \rs2_data_reg[0]_i_4_n_0 ;
  wire \rs2_data_reg[0]_i_5_n_0 ;
  wire \rs2_data_reg[1]_i_2_n_0 ;
  wire \rs2_data_reg[1]_i_3_n_0 ;
  wire \rs2_data_reg[1]_i_4_n_0 ;
  wire \rs2_data_reg[1]_i_5_n_0 ;
  wire \rs2_data_reg[2]_i_2_n_0 ;
  wire \rs2_data_reg[2]_i_3_n_0 ;
  wire \rs2_data_reg[2]_i_4_n_0 ;
  wire \rs2_data_reg[2]_i_5_n_0 ;
  wire \rs2_data_reg[3]_i_2_n_0 ;
  wire \rs2_data_reg[3]_i_3_n_0 ;
  wire \rs2_data_reg[3]_i_4_n_0 ;
  wire \rs2_data_reg[3]_i_5_n_0 ;
  wire [4:0]\rs2_data_reg[4]_0 ;
  wire \rs2_data_reg[4]_i_2_n_0 ;
  wire \rs2_data_reg[4]_i_3_n_0 ;
  wire \rs2_data_reg[4]_i_4_n_0 ;
  wire \rs2_data_reg[4]_i_5_n_0 ;
  wire rstn;
  wire rstn_IBUF;
  wire [15:0]spo;
  wire [1:0]sw_i_IBUF;

  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_1 
       (.I0(\disp_data_reg[0]_i_2_n_0 ),
        .I1(\disp_data_reg[0]_i_3_n_0 ),
        .I2(Q[4]),
        .I3(\disp_data_reg[0]_i_4_n_0 ),
        .I4(Q[3]),
        .I5(\disp_data_reg[0]_i_5_n_0 ),
        .O(\disp_data[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_10 
       (.I0(\register_file_reg[11]__0 [0]),
        .I1(\register_file_reg[10]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[9]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[8]__0 [0]),
        .O(\disp_data[0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_11 
       (.I0(\register_file_reg[15]__0 [0]),
        .I1(\register_file_reg[14]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[13]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[12]__0 [0]),
        .O(\disp_data[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_12 
       (.I0(\register_file_reg[3]__0 [0]),
        .I1(\register_file_reg[2]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[1]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[0]__0 [0]),
        .O(\disp_data[0]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_13 
       (.I0(\register_file_reg[7]__0 [0]),
        .I1(\register_file_reg[6]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[5]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[4]__0 [0]),
        .O(\disp_data[0]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_6 
       (.I0(\register_file_reg[27]__0 [0]),
        .I1(\register_file_reg[26]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[25]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[24]__0 [0]),
        .O(\disp_data[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_7 
       (.I0(\register_file_reg[31]__0 [0]),
        .I1(\register_file_reg[30]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[29]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[28]__0 [0]),
        .O(\disp_data[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_8 
       (.I0(\register_file_reg[19]__0 [0]),
        .I1(\register_file_reg[18]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[17]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[16]__0 [0]),
        .O(\disp_data[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[0]_i_9 
       (.I0(\register_file_reg[23]__0 [0]),
        .I1(\register_file_reg[22]__0 [0]),
        .I2(Q[1]),
        .I3(\register_file_reg[21]__0 [0]),
        .I4(Q[0]),
        .I5(\register_file_reg[20]__0 [0]),
        .O(\disp_data[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_1 
       (.I0(\disp_data_reg[1]_i_2_n_0 ),
        .I1(\disp_data_reg[1]_i_3_n_0 ),
        .I2(Q[4]),
        .I3(\disp_data_reg[1]_i_4_n_0 ),
        .I4(Q[3]),
        .I5(\disp_data_reg[1]_i_5_n_0 ),
        .O(\disp_data[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_10 
       (.I0(\register_file_reg[11]__0 [1]),
        .I1(\register_file_reg[10]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[9]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[8]__0 [1]),
        .O(\disp_data[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_11 
       (.I0(\register_file_reg[15]__0 [1]),
        .I1(\register_file_reg[14]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[13]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[12]__0 [1]),
        .O(\disp_data[1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_12 
       (.I0(\register_file_reg[3]__0 [1]),
        .I1(\register_file_reg[2]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[1]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[0]__0 [1]),
        .O(\disp_data[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_13 
       (.I0(\register_file_reg[7]__0 [1]),
        .I1(\register_file_reg[6]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[5]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[4]__0 [1]),
        .O(\disp_data[1]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_6 
       (.I0(\register_file_reg[27]__0 [1]),
        .I1(\register_file_reg[26]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[25]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[24]__0 [1]),
        .O(\disp_data[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_7 
       (.I0(\register_file_reg[31]__0 [1]),
        .I1(\register_file_reg[30]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[29]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[28]__0 [1]),
        .O(\disp_data[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_8 
       (.I0(\register_file_reg[19]__0 [1]),
        .I1(\register_file_reg[18]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[17]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[16]__0 [1]),
        .O(\disp_data[1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[1]_i_9 
       (.I0(\register_file_reg[23]__0 [1]),
        .I1(\register_file_reg[22]__0 [1]),
        .I2(Q[1]),
        .I3(\register_file_reg[21]__0 [1]),
        .I4(Q[0]),
        .I5(\register_file_reg[20]__0 [1]),
        .O(\disp_data[1]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_1 
       (.I0(\disp_data_reg[2]_i_2_n_0 ),
        .I1(\disp_data_reg[2]_i_3_n_0 ),
        .I2(Q[4]),
        .I3(\disp_data_reg[2]_i_4_n_0 ),
        .I4(Q[3]),
        .I5(\disp_data_reg[2]_i_5_n_0 ),
        .O(\disp_data[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_10 
       (.I0(\register_file_reg[11]__0 [2]),
        .I1(\register_file_reg[10]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[9]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[8]__0 [2]),
        .O(\disp_data[2]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_11 
       (.I0(\register_file_reg[15]__0 [2]),
        .I1(\register_file_reg[14]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[13]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[12]__0 [2]),
        .O(\disp_data[2]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_12 
       (.I0(\register_file_reg[3]__0 [2]),
        .I1(\register_file_reg[2]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[1]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[0]__0 [2]),
        .O(\disp_data[2]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_13 
       (.I0(\register_file_reg[7]__0 [2]),
        .I1(\register_file_reg[6]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[5]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[4]__0 [2]),
        .O(\disp_data[2]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_6 
       (.I0(\register_file_reg[27]__0 [2]),
        .I1(\register_file_reg[26]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[25]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[24]__0 [2]),
        .O(\disp_data[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_7 
       (.I0(\register_file_reg[31]__0 [2]),
        .I1(\register_file_reg[30]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[29]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[28]__0 [2]),
        .O(\disp_data[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_8 
       (.I0(\register_file_reg[19]__0 [2]),
        .I1(\register_file_reg[18]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[17]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[16]__0 [2]),
        .O(\disp_data[2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[2]_i_9 
       (.I0(\register_file_reg[23]__0 [2]),
        .I1(\register_file_reg[22]__0 [2]),
        .I2(Q[1]),
        .I3(\register_file_reg[21]__0 [2]),
        .I4(Q[0]),
        .I5(\register_file_reg[20]__0 [2]),
        .O(\disp_data[2]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_1 
       (.I0(\disp_data_reg[3]_i_2_n_0 ),
        .I1(\disp_data_reg[3]_i_3_n_0 ),
        .I2(Q[4]),
        .I3(\disp_data_reg[3]_i_4_n_0 ),
        .I4(Q[3]),
        .I5(\disp_data_reg[3]_i_5_n_0 ),
        .O(\disp_data[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_10 
       (.I0(\register_file_reg[11]__0 [3]),
        .I1(\register_file_reg[10]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[9]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[8]__0 [3]),
        .O(\disp_data[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_11 
       (.I0(\register_file_reg[15]__0 [3]),
        .I1(\register_file_reg[14]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[13]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[12]__0 [3]),
        .O(\disp_data[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_12 
       (.I0(\register_file_reg[3]__0 [3]),
        .I1(\register_file_reg[2]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[1]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[0]__0 [3]),
        .O(\disp_data[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_13 
       (.I0(\register_file_reg[7]__0 [3]),
        .I1(\register_file_reg[6]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[5]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[4]__0 [3]),
        .O(\disp_data[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_6 
       (.I0(\register_file_reg[27]__0 [3]),
        .I1(\register_file_reg[26]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[25]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[24]__0 [3]),
        .O(\disp_data[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_7 
       (.I0(\register_file_reg[31]__0 [3]),
        .I1(\register_file_reg[30]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[29]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[28]__0 [3]),
        .O(\disp_data[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_8 
       (.I0(\register_file_reg[19]__0 [3]),
        .I1(\register_file_reg[18]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[17]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[16]__0 [3]),
        .O(\disp_data[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[3]_i_9 
       (.I0(\register_file_reg[23]__0 [3]),
        .I1(\register_file_reg[22]__0 [3]),
        .I2(Q[1]),
        .I3(\register_file_reg[21]__0 [3]),
        .I4(Q[0]),
        .I5(\register_file_reg[20]__0 [3]),
        .O(\disp_data[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_1 
       (.I0(\disp_data_reg[4]_i_2_n_0 ),
        .I1(\disp_data_reg[4]_i_3_n_0 ),
        .I2(Q[4]),
        .I3(\disp_data_reg[4]_i_4_n_0 ),
        .I4(Q[3]),
        .I5(\disp_data_reg[4]_i_5_n_0 ),
        .O(\disp_data[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_10 
       (.I0(\register_file_reg[11]__0 [4]),
        .I1(\register_file_reg[10]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[9]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[8]__0 [4]),
        .O(\disp_data[4]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_11 
       (.I0(\register_file_reg[15]__0 [4]),
        .I1(\register_file_reg[14]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[13]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[12]__0 [4]),
        .O(\disp_data[4]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_12 
       (.I0(\register_file_reg[3]__0 [4]),
        .I1(\register_file_reg[2]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[1]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[0]__0 [4]),
        .O(\disp_data[4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_13 
       (.I0(\register_file_reg[7]__0 [4]),
        .I1(\register_file_reg[6]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[5]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[4]__0 [4]),
        .O(\disp_data[4]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_6 
       (.I0(\register_file_reg[27]__0 [4]),
        .I1(\register_file_reg[26]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[25]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[24]__0 [4]),
        .O(\disp_data[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_7 
       (.I0(\register_file_reg[31]__0 [4]),
        .I1(\register_file_reg[30]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[29]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[28]__0 [4]),
        .O(\disp_data[4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_8 
       (.I0(\register_file_reg[19]__0 [4]),
        .I1(\register_file_reg[18]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[17]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[16]__0 [4]),
        .O(\disp_data[4]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \disp_data[4]_i_9 
       (.I0(\register_file_reg[23]__0 [4]),
        .I1(\register_file_reg[22]__0 [4]),
        .I2(Q[1]),
        .I3(\register_file_reg[21]__0 [4]),
        .I4(Q[0]),
        .I5(\register_file_reg[20]__0 [4]),
        .O(\disp_data[4]_i_9_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[0] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\disp_data[0]_i_1_n_0 ),
        .Q(\disp_data_reg[3]_0 [0]),
        .R(1'b0));
  MUXF7 \disp_data_reg[0]_i_2 
       (.I0(\disp_data[0]_i_6_n_0 ),
        .I1(\disp_data[0]_i_7_n_0 ),
        .O(\disp_data_reg[0]_i_2_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[0]_i_3 
       (.I0(\disp_data[0]_i_8_n_0 ),
        .I1(\disp_data[0]_i_9_n_0 ),
        .O(\disp_data_reg[0]_i_3_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[0]_i_4 
       (.I0(\disp_data[0]_i_10_n_0 ),
        .I1(\disp_data[0]_i_11_n_0 ),
        .O(\disp_data_reg[0]_i_4_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[0]_i_5 
       (.I0(\disp_data[0]_i_12_n_0 ),
        .I1(\disp_data[0]_i_13_n_0 ),
        .O(\disp_data_reg[0]_i_5_n_0 ),
        .S(Q[2]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[1] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\disp_data[1]_i_1_n_0 ),
        .Q(\disp_data_reg[3]_0 [1]),
        .R(1'b0));
  MUXF7 \disp_data_reg[1]_i_2 
       (.I0(\disp_data[1]_i_6_n_0 ),
        .I1(\disp_data[1]_i_7_n_0 ),
        .O(\disp_data_reg[1]_i_2_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[1]_i_3 
       (.I0(\disp_data[1]_i_8_n_0 ),
        .I1(\disp_data[1]_i_9_n_0 ),
        .O(\disp_data_reg[1]_i_3_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[1]_i_4 
       (.I0(\disp_data[1]_i_10_n_0 ),
        .I1(\disp_data[1]_i_11_n_0 ),
        .O(\disp_data_reg[1]_i_4_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[1]_i_5 
       (.I0(\disp_data[1]_i_12_n_0 ),
        .I1(\disp_data[1]_i_13_n_0 ),
        .O(\disp_data_reg[1]_i_5_n_0 ),
        .S(Q[2]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[2] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\disp_data[2]_i_1_n_0 ),
        .Q(\disp_data_reg[3]_0 [2]),
        .R(1'b0));
  MUXF7 \disp_data_reg[2]_i_2 
       (.I0(\disp_data[2]_i_6_n_0 ),
        .I1(\disp_data[2]_i_7_n_0 ),
        .O(\disp_data_reg[2]_i_2_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[2]_i_3 
       (.I0(\disp_data[2]_i_8_n_0 ),
        .I1(\disp_data[2]_i_9_n_0 ),
        .O(\disp_data_reg[2]_i_3_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[2]_i_4 
       (.I0(\disp_data[2]_i_10_n_0 ),
        .I1(\disp_data[2]_i_11_n_0 ),
        .O(\disp_data_reg[2]_i_4_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[2]_i_5 
       (.I0(\disp_data[2]_i_12_n_0 ),
        .I1(\disp_data[2]_i_13_n_0 ),
        .O(\disp_data_reg[2]_i_5_n_0 ),
        .S(Q[2]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[3] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\disp_data[3]_i_1_n_0 ),
        .Q(\disp_data_reg[3]_0 [3]),
        .R(1'b0));
  MUXF7 \disp_data_reg[3]_i_2 
       (.I0(\disp_data[3]_i_6_n_0 ),
        .I1(\disp_data[3]_i_7_n_0 ),
        .O(\disp_data_reg[3]_i_2_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[3]_i_3 
       (.I0(\disp_data[3]_i_8_n_0 ),
        .I1(\disp_data[3]_i_9_n_0 ),
        .O(\disp_data_reg[3]_i_3_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[3]_i_4 
       (.I0(\disp_data[3]_i_10_n_0 ),
        .I1(\disp_data[3]_i_11_n_0 ),
        .O(\disp_data_reg[3]_i_4_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[3]_i_5 
       (.I0(\disp_data[3]_i_12_n_0 ),
        .I1(\disp_data[3]_i_13_n_0 ),
        .O(\disp_data_reg[3]_i_5_n_0 ),
        .S(Q[2]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \disp_data_reg[4] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\disp_data[4]_i_1_n_0 ),
        .Q(rf_disp_data),
        .R(1'b0));
  MUXF7 \disp_data_reg[4]_i_2 
       (.I0(\disp_data[4]_i_6_n_0 ),
        .I1(\disp_data[4]_i_7_n_0 ),
        .O(\disp_data_reg[4]_i_2_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[4]_i_3 
       (.I0(\disp_data[4]_i_8_n_0 ),
        .I1(\disp_data[4]_i_9_n_0 ),
        .O(\disp_data_reg[4]_i_3_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[4]_i_4 
       (.I0(\disp_data[4]_i_10_n_0 ),
        .I1(\disp_data[4]_i_11_n_0 ),
        .O(\disp_data_reg[4]_i_4_n_0 ),
        .S(Q[2]));
  MUXF7 \disp_data_reg[4]_i_5 
       (.I0(\disp_data[4]_i_12_n_0 ),
        .I1(\disp_data[4]_i_13_n_0 ),
        .O(\disp_data_reg[4]_i_5_n_0 ),
        .S(Q[2]));
  LUT4 #(
    .INIT(16'hF888)) 
    \disp_seg_o_OBUF[6]_inst_i_21 
       (.I0(rf_disp_data),
        .I1(sw_i_IBUF[0]),
        .I2(spo[0]),
        .I3(sw_i_IBUF[1]),
        .O(\disp_data_reg[4]_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_1 
       (.I0(\register_file_reg[30][0]_i_2_n_0 ),
        .I1(\register_file_reg[30][0]_i_3_n_0 ),
        .I2(spo[5]),
        .I3(\register_file_reg[30][0]_i_4_n_0 ),
        .I4(spo[4]),
        .I5(\register_file_reg[30][0]_i_5_n_0 ),
        .O(register_file[0]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_10 
       (.I0(\register_file_reg[11]__0 [0]),
        .I1(\register_file_reg[10]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[9]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[8]__0 [0]),
        .O(\register_file[30][0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_11 
       (.I0(\register_file_reg[15]__0 [0]),
        .I1(\register_file_reg[14]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[13]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[12]__0 [0]),
        .O(\register_file[30][0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_12 
       (.I0(\register_file_reg[3]__0 [0]),
        .I1(\register_file_reg[2]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[1]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[0]__0 [0]),
        .O(\register_file[30][0]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_13 
       (.I0(\register_file_reg[7]__0 [0]),
        .I1(\register_file_reg[6]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[5]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[4]__0 [0]),
        .O(\register_file[30][0]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_6 
       (.I0(\register_file_reg[27]__0 [0]),
        .I1(\register_file_reg[26]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[25]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[24]__0 [0]),
        .O(\register_file[30][0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_7 
       (.I0(\register_file_reg[31]__0 [0]),
        .I1(\register_file_reg[30]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[29]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[28]__0 [0]),
        .O(\register_file[30][0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_8 
       (.I0(\register_file_reg[19]__0 [0]),
        .I1(\register_file_reg[18]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[17]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[16]__0 [0]),
        .O(\register_file[30][0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][0]_i_9 
       (.I0(\register_file_reg[23]__0 [0]),
        .I1(\register_file_reg[22]__0 [0]),
        .I2(spo[2]),
        .I3(\register_file_reg[21]__0 [0]),
        .I4(spo[1]),
        .I5(\register_file_reg[20]__0 [0]),
        .O(\register_file[30][0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_1 
       (.I0(\register_file_reg[30][1]_i_2_n_0 ),
        .I1(\register_file_reg[30][1]_i_3_n_0 ),
        .I2(spo[5]),
        .I3(\register_file_reg[30][1]_i_4_n_0 ),
        .I4(spo[4]),
        .I5(\register_file_reg[30][1]_i_5_n_0 ),
        .O(register_file[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_10 
       (.I0(\register_file_reg[11]__0 [1]),
        .I1(\register_file_reg[10]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[9]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[8]__0 [1]),
        .O(\register_file[30][1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_11 
       (.I0(\register_file_reg[15]__0 [1]),
        .I1(\register_file_reg[14]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[13]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[12]__0 [1]),
        .O(\register_file[30][1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_12 
       (.I0(\register_file_reg[3]__0 [1]),
        .I1(\register_file_reg[2]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[1]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[0]__0 [1]),
        .O(\register_file[30][1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_13 
       (.I0(\register_file_reg[7]__0 [1]),
        .I1(\register_file_reg[6]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[5]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[4]__0 [1]),
        .O(\register_file[30][1]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_6 
       (.I0(\register_file_reg[27]__0 [1]),
        .I1(\register_file_reg[26]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[25]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[24]__0 [1]),
        .O(\register_file[30][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_7 
       (.I0(\register_file_reg[31]__0 [1]),
        .I1(\register_file_reg[30]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[29]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[28]__0 [1]),
        .O(\register_file[30][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_8 
       (.I0(\register_file_reg[19]__0 [1]),
        .I1(\register_file_reg[18]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[17]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[16]__0 [1]),
        .O(\register_file[30][1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][1]_i_9 
       (.I0(\register_file_reg[23]__0 [1]),
        .I1(\register_file_reg[22]__0 [1]),
        .I2(spo[2]),
        .I3(\register_file_reg[21]__0 [1]),
        .I4(spo[1]),
        .I5(\register_file_reg[20]__0 [1]),
        .O(\register_file[30][1]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_1 
       (.I0(\register_file_reg[30][2]_i_2_n_0 ),
        .I1(\register_file_reg[30][2]_i_3_n_0 ),
        .I2(spo[5]),
        .I3(\register_file_reg[30][2]_i_4_n_0 ),
        .I4(spo[4]),
        .I5(\register_file_reg[30][2]_i_5_n_0 ),
        .O(register_file[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_10 
       (.I0(\register_file_reg[11]__0 [2]),
        .I1(\register_file_reg[10]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[9]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[8]__0 [2]),
        .O(\register_file[30][2]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_11 
       (.I0(\register_file_reg[15]__0 [2]),
        .I1(\register_file_reg[14]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[13]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[12]__0 [2]),
        .O(\register_file[30][2]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_12 
       (.I0(\register_file_reg[3]__0 [2]),
        .I1(\register_file_reg[2]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[1]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[0]__0 [2]),
        .O(\register_file[30][2]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_13 
       (.I0(\register_file_reg[7]__0 [2]),
        .I1(\register_file_reg[6]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[5]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[4]__0 [2]),
        .O(\register_file[30][2]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_6 
       (.I0(\register_file_reg[27]__0 [2]),
        .I1(\register_file_reg[26]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[25]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[24]__0 [2]),
        .O(\register_file[30][2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_7 
       (.I0(\register_file_reg[31]__0 [2]),
        .I1(\register_file_reg[30]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[29]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[28]__0 [2]),
        .O(\register_file[30][2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_8 
       (.I0(\register_file_reg[19]__0 [2]),
        .I1(\register_file_reg[18]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[17]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[16]__0 [2]),
        .O(\register_file[30][2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][2]_i_9 
       (.I0(\register_file_reg[23]__0 [2]),
        .I1(\register_file_reg[22]__0 [2]),
        .I2(spo[2]),
        .I3(\register_file_reg[21]__0 [2]),
        .I4(spo[1]),
        .I5(\register_file_reg[20]__0 [2]),
        .O(\register_file[30][2]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_1 
       (.I0(\register_file_reg[30][3]_i_2_n_0 ),
        .I1(\register_file_reg[30][3]_i_3_n_0 ),
        .I2(spo[5]),
        .I3(\register_file_reg[30][3]_i_4_n_0 ),
        .I4(spo[4]),
        .I5(\register_file_reg[30][3]_i_5_n_0 ),
        .O(register_file[3]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_10 
       (.I0(\register_file_reg[11]__0 [3]),
        .I1(\register_file_reg[10]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[9]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[8]__0 [3]),
        .O(\register_file[30][3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_11 
       (.I0(\register_file_reg[15]__0 [3]),
        .I1(\register_file_reg[14]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[13]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[12]__0 [3]),
        .O(\register_file[30][3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_12 
       (.I0(\register_file_reg[3]__0 [3]),
        .I1(\register_file_reg[2]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[1]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[0]__0 [3]),
        .O(\register_file[30][3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_13 
       (.I0(\register_file_reg[7]__0 [3]),
        .I1(\register_file_reg[6]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[5]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[4]__0 [3]),
        .O(\register_file[30][3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_6 
       (.I0(\register_file_reg[27]__0 [3]),
        .I1(\register_file_reg[26]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[25]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[24]__0 [3]),
        .O(\register_file[30][3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_7 
       (.I0(\register_file_reg[31]__0 [3]),
        .I1(\register_file_reg[30]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[29]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[28]__0 [3]),
        .O(\register_file[30][3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_8 
       (.I0(\register_file_reg[19]__0 [3]),
        .I1(\register_file_reg[18]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[17]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[16]__0 [3]),
        .O(\register_file[30][3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][3]_i_9 
       (.I0(\register_file_reg[23]__0 [3]),
        .I1(\register_file_reg[22]__0 [3]),
        .I2(spo[2]),
        .I3(\register_file_reg[21]__0 [3]),
        .I4(spo[1]),
        .I5(\register_file_reg[20]__0 [3]),
        .O(\register_file[30][3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_10 
       (.I0(\register_file_reg[19]__0 [4]),
        .I1(\register_file_reg[18]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[17]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[16]__0 [4]),
        .O(\register_file[30][4]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_11 
       (.I0(\register_file_reg[23]__0 [4]),
        .I1(\register_file_reg[22]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[21]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[20]__0 [4]),
        .O(\register_file[30][4]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_12 
       (.I0(\register_file_reg[11]__0 [4]),
        .I1(\register_file_reg[10]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[9]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[8]__0 [4]),
        .O(\register_file[30][4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_13 
       (.I0(\register_file_reg[15]__0 [4]),
        .I1(\register_file_reg[14]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[13]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[12]__0 [4]),
        .O(\register_file[30][4]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_14 
       (.I0(\register_file_reg[3]__0 [4]),
        .I1(\register_file_reg[2]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[1]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[0]__0 [4]),
        .O(\register_file[30][4]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_15 
       (.I0(\register_file_reg[7]__0 [4]),
        .I1(\register_file_reg[6]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[5]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[4]__0 [4]),
        .O(\register_file[30][4]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_2 
       (.I0(\register_file_reg[30][4]_i_4_n_0 ),
        .I1(\register_file_reg[30][4]_i_5_n_0 ),
        .I2(spo[5]),
        .I3(\register_file_reg[30][4]_i_6_n_0 ),
        .I4(spo[4]),
        .I5(\register_file_reg[30][4]_i_7_n_0 ),
        .O(register_file[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \register_file[30][4]_i_3 
       (.I0(rstn_IBUF),
        .O(rstn));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_8 
       (.I0(\register_file_reg[27]__0 [4]),
        .I1(\register_file_reg[26]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[25]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[24]__0 [4]),
        .O(\register_file[30][4]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \register_file[30][4]_i_9 
       (.I0(\register_file_reg[31]__0 [4]),
        .I1(\register_file_reg[30]__0 [4]),
        .I2(spo[2]),
        .I3(\register_file_reg[29]__0 [4]),
        .I4(spo[1]),
        .I5(\register_file_reg[28]__0 [4]),
        .O(\register_file[30][4]_i_9_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[0][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[0][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[0]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[0][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[0][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[0]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[0][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[0][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[0]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[0][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[0][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[0]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[0][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[0][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[0]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[10][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[10][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[10]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[10][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[10][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[10]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[10][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[10][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[10]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[10][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[10][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[10]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[10][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[10][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[10]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[11][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[11][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[11]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[11][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[11][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[11]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[11][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[11][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[11]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[11][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[11][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[11]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[11][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[11][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[11]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[12][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[12][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[12]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[12][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[12][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[12]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[12][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[12][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[12]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[12][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[12][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[12]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[12][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[12][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[12]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[13][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[13][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[13]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[13][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[13][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[13]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[13][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[13][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[13]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[13][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[13][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[13]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[13][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[13][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[13]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[14][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[14][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[14]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[14][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[14][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[14]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[14][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[14][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[14]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[14][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[14][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[14]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[14][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[14][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[14]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[15][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[15][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[15]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[15][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[15][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[15]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[15][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[15][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[15]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[15][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[15][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[15]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[15][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[15][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[15]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[16][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[16][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[16]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[16][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[16][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[16]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[16][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[16][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[16]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[16][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[16][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[16]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[16][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[16][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[16]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[17][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[17][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[17]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[17][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[17][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[17]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[17][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[17][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[17]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[17][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[17][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[17]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[17][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[17][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[17]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[18][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[18][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[18]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[18][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[18][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[18]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[18][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[18][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[18]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[18][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[18][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[18]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[18][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[18][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[18]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[19][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[19][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[19]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[19][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[19][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[19]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[19][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[19][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[19]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[19][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[19][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[19]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[19][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[19][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[19]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[1][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[1][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[1]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[1][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[1][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[1]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[1][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[1][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[1]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[1][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[1][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[1]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[1][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[1][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[1]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[20][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[20][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[20]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[20][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[20][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[20]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[20][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[20][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[20]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[20][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[20][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[20]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[20][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[20][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[20]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[21][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[21][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[21]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[21][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[21][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[21]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[21][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[21][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[21]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[21][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[21][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[21]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[21][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[21][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[21]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[22][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[22][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[22]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[22][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[22][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[22]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[22][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[22][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[22]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[22][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[22][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[22]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[22][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[22][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[22]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[23][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[23][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[23]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[23][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[23][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[23]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[23][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[23][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[23]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[23][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[23][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[23]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[23][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[23][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[23]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[24][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[24][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[24]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[24][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[24][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[24]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[24][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[24][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[24]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[24][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[24][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[24]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[24][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[24][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[24]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[25][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[25][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[25]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[25][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[25][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[25]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[25][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[25][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[25]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[25][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[25][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[25]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[25][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[25][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[25]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[26][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[26][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[26]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[26][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[26][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[26]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[26][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[26][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[26]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[26][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[26][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[26]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[26][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[26][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[26]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[27][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[27][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[27]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[27][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[27][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[27]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[27][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[27][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[27]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[27][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[27][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[27]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[27][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[27][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[27]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[28][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[28][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[28]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[28][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[28][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[28]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[28][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[28][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[28]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[28][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[28][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[28]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[28][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[28][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[28]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[29][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[29][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[29]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[29][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[29][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[29]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[29][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[29][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[29]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[29][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[29][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[29]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[29][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[29][4]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[29]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[2][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[2][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[2]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[2][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[2][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[2]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[2][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[2][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[2]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[2][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[2][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[2]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[2][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[2][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[2]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[30][0] 
       (.C(clk_used_BUFG),
        .CE(E),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[30]__0 [0]));
  MUXF7 \register_file_reg[30][0]_i_2 
       (.I0(\register_file[30][0]_i_6_n_0 ),
        .I1(\register_file[30][0]_i_7_n_0 ),
        .O(\register_file_reg[30][0]_i_2_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][0]_i_3 
       (.I0(\register_file[30][0]_i_8_n_0 ),
        .I1(\register_file[30][0]_i_9_n_0 ),
        .O(\register_file_reg[30][0]_i_3_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][0]_i_4 
       (.I0(\register_file[30][0]_i_10_n_0 ),
        .I1(\register_file[30][0]_i_11_n_0 ),
        .O(\register_file_reg[30][0]_i_4_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][0]_i_5 
       (.I0(\register_file[30][0]_i_12_n_0 ),
        .I1(\register_file[30][0]_i_13_n_0 ),
        .O(\register_file_reg[30][0]_i_5_n_0 ),
        .S(spo[3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[30][1] 
       (.C(clk_used_BUFG),
        .CE(E),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[30]__0 [1]));
  MUXF7 \register_file_reg[30][1]_i_2 
       (.I0(\register_file[30][1]_i_6_n_0 ),
        .I1(\register_file[30][1]_i_7_n_0 ),
        .O(\register_file_reg[30][1]_i_2_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][1]_i_3 
       (.I0(\register_file[30][1]_i_8_n_0 ),
        .I1(\register_file[30][1]_i_9_n_0 ),
        .O(\register_file_reg[30][1]_i_3_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][1]_i_4 
       (.I0(\register_file[30][1]_i_10_n_0 ),
        .I1(\register_file[30][1]_i_11_n_0 ),
        .O(\register_file_reg[30][1]_i_4_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][1]_i_5 
       (.I0(\register_file[30][1]_i_12_n_0 ),
        .I1(\register_file[30][1]_i_13_n_0 ),
        .O(\register_file_reg[30][1]_i_5_n_0 ),
        .S(spo[3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[30][2] 
       (.C(clk_used_BUFG),
        .CE(E),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[30]__0 [2]));
  MUXF7 \register_file_reg[30][2]_i_2 
       (.I0(\register_file[30][2]_i_6_n_0 ),
        .I1(\register_file[30][2]_i_7_n_0 ),
        .O(\register_file_reg[30][2]_i_2_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][2]_i_3 
       (.I0(\register_file[30][2]_i_8_n_0 ),
        .I1(\register_file[30][2]_i_9_n_0 ),
        .O(\register_file_reg[30][2]_i_3_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][2]_i_4 
       (.I0(\register_file[30][2]_i_10_n_0 ),
        .I1(\register_file[30][2]_i_11_n_0 ),
        .O(\register_file_reg[30][2]_i_4_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][2]_i_5 
       (.I0(\register_file[30][2]_i_12_n_0 ),
        .I1(\register_file[30][2]_i_13_n_0 ),
        .O(\register_file_reg[30][2]_i_5_n_0 ),
        .S(spo[3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[30][3] 
       (.C(clk_used_BUFG),
        .CE(E),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[30]__0 [3]));
  MUXF7 \register_file_reg[30][3]_i_2 
       (.I0(\register_file[30][3]_i_6_n_0 ),
        .I1(\register_file[30][3]_i_7_n_0 ),
        .O(\register_file_reg[30][3]_i_2_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][3]_i_3 
       (.I0(\register_file[30][3]_i_8_n_0 ),
        .I1(\register_file[30][3]_i_9_n_0 ),
        .O(\register_file_reg[30][3]_i_3_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][3]_i_4 
       (.I0(\register_file[30][3]_i_10_n_0 ),
        .I1(\register_file[30][3]_i_11_n_0 ),
        .O(\register_file_reg[30][3]_i_4_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][3]_i_5 
       (.I0(\register_file[30][3]_i_12_n_0 ),
        .I1(\register_file[30][3]_i_13_n_0 ),
        .O(\register_file_reg[30][3]_i_5_n_0 ),
        .S(spo[3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[30][4] 
       (.C(clk_used_BUFG),
        .CE(E),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[30]__0 [4]));
  MUXF7 \register_file_reg[30][4]_i_4 
       (.I0(\register_file[30][4]_i_8_n_0 ),
        .I1(\register_file[30][4]_i_9_n_0 ),
        .O(\register_file_reg[30][4]_i_4_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][4]_i_5 
       (.I0(\register_file[30][4]_i_10_n_0 ),
        .I1(\register_file[30][4]_i_11_n_0 ),
        .O(\register_file_reg[30][4]_i_5_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][4]_i_6 
       (.I0(\register_file[30][4]_i_12_n_0 ),
        .I1(\register_file[30][4]_i_13_n_0 ),
        .O(\register_file_reg[30][4]_i_6_n_0 ),
        .S(spo[3]));
  MUXF7 \register_file_reg[30][4]_i_7 
       (.I0(\register_file[30][4]_i_14_n_0 ),
        .I1(\register_file[30][4]_i_15_n_0 ),
        .O(\register_file_reg[30][4]_i_7_n_0 ),
        .S(spo[3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[31][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[31][0]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[31]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[31][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[31][0]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[31]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[31][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[31][0]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[31]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[31][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[31][0]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[31]__0 [3]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[31][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[31][0]_0 ),
        .D(register_file[4]),
        .PRE(rstn),
        .Q(\register_file_reg[31]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[3][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[3][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[3]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[3][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[3][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[3]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[3][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[3][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[3]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[3][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[3][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[3]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[3][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[3][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[3]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[4][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[4][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[4]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[4][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[4][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[4]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[4][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[4][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[4]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[4][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[4][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[4]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[4][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[4][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[4]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[5][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[5][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[5]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[5][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[5][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[5]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[5][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[5][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[5]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[5][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[5][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[5]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[5][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[5][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[5]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[6][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[6][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[6]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[6][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[6][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[6]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[6][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[6][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[6]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[6][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[6][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[6]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[6][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[6][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[6]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[7][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[7][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[7]__0 [0]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[7][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[7][4]_0 ),
        .D(register_file[1]),
        .PRE(rstn),
        .Q(\register_file_reg[7]__0 [1]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[7][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[7][4]_0 ),
        .D(register_file[2]),
        .PRE(rstn),
        .Q(\register_file_reg[7]__0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[7][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[7][4]_0 ),
        .CLR(rstn),
        .D(register_file[3]),
        .Q(\register_file_reg[7]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[7][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[7][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[7]__0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[8][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[8][4]_0 ),
        .CLR(rstn),
        .D(register_file[0]),
        .Q(\register_file_reg[8]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[8][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[8][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[8]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[8][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[8][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[8]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[8][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[8][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[8]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[8][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[8][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[8]__0 [4]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[9][0] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[9][4]_0 ),
        .D(register_file[0]),
        .PRE(rstn),
        .Q(\register_file_reg[9]__0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[9][1] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[9][4]_0 ),
        .CLR(rstn),
        .D(register_file[1]),
        .Q(\register_file_reg[9]__0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[9][2] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[9][4]_0 ),
        .CLR(rstn),
        .D(register_file[2]),
        .Q(\register_file_reg[9]__0 [2]));
  FDPE #(
    .INIT(1'b1)) 
    \register_file_reg[9][3] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[9][4]_0 ),
        .D(register_file[3]),
        .PRE(rstn),
        .Q(\register_file_reg[9]__0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \register_file_reg[9][4] 
       (.C(clk_used_BUFG),
        .CE(\register_file_reg[9][4]_0 ),
        .CLR(rstn),
        .D(register_file[4]),
        .Q(\register_file_reg[9]__0 [4]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_1 
       (.I0(\rs1_data_reg[0]_i_2_n_0 ),
        .I1(\rs1_data_reg[0]_i_3_n_0 ),
        .I2(spo[10]),
        .I3(\rs1_data_reg[0]_i_4_n_0 ),
        .I4(spo[9]),
        .I5(\rs1_data_reg[0]_i_5_n_0 ),
        .O(\rs1_data[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_10 
       (.I0(\register_file_reg[11]__0 [0]),
        .I1(\register_file_reg[10]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[9]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[8]__0 [0]),
        .O(\rs1_data[0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_11 
       (.I0(\register_file_reg[15]__0 [0]),
        .I1(\register_file_reg[14]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[13]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[12]__0 [0]),
        .O(\rs1_data[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_12 
       (.I0(\register_file_reg[3]__0 [0]),
        .I1(\register_file_reg[2]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[1]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[0]__0 [0]),
        .O(\rs1_data[0]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_13 
       (.I0(\register_file_reg[7]__0 [0]),
        .I1(\register_file_reg[6]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[5]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[4]__0 [0]),
        .O(\rs1_data[0]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_6 
       (.I0(\register_file_reg[27]__0 [0]),
        .I1(\register_file_reg[26]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[25]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[24]__0 [0]),
        .O(\rs1_data[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_7 
       (.I0(\register_file_reg[31]__0 [0]),
        .I1(\register_file_reg[30]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[29]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[28]__0 [0]),
        .O(\rs1_data[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_8 
       (.I0(\register_file_reg[19]__0 [0]),
        .I1(\register_file_reg[18]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[17]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[16]__0 [0]),
        .O(\rs1_data[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[0]_i_9 
       (.I0(\register_file_reg[23]__0 [0]),
        .I1(\register_file_reg[22]__0 [0]),
        .I2(spo[7]),
        .I3(\register_file_reg[21]__0 [0]),
        .I4(spo[6]),
        .I5(\register_file_reg[20]__0 [0]),
        .O(\rs1_data[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_1 
       (.I0(\rs1_data_reg[1]_i_2_n_0 ),
        .I1(\rs1_data_reg[1]_i_3_n_0 ),
        .I2(spo[10]),
        .I3(\rs1_data_reg[1]_i_4_n_0 ),
        .I4(spo[9]),
        .I5(\rs1_data_reg[1]_i_5_n_0 ),
        .O(\rs1_data[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_10 
       (.I0(\register_file_reg[11]__0 [1]),
        .I1(\register_file_reg[10]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[9]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[8]__0 [1]),
        .O(\rs1_data[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_11 
       (.I0(\register_file_reg[15]__0 [1]),
        .I1(\register_file_reg[14]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[13]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[12]__0 [1]),
        .O(\rs1_data[1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_12 
       (.I0(\register_file_reg[3]__0 [1]),
        .I1(\register_file_reg[2]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[1]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[0]__0 [1]),
        .O(\rs1_data[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_13 
       (.I0(\register_file_reg[7]__0 [1]),
        .I1(\register_file_reg[6]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[5]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[4]__0 [1]),
        .O(\rs1_data[1]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_6 
       (.I0(\register_file_reg[27]__0 [1]),
        .I1(\register_file_reg[26]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[25]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[24]__0 [1]),
        .O(\rs1_data[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_7 
       (.I0(\register_file_reg[31]__0 [1]),
        .I1(\register_file_reg[30]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[29]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[28]__0 [1]),
        .O(\rs1_data[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_8 
       (.I0(\register_file_reg[19]__0 [1]),
        .I1(\register_file_reg[18]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[17]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[16]__0 [1]),
        .O(\rs1_data[1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[1]_i_9 
       (.I0(\register_file_reg[23]__0 [1]),
        .I1(\register_file_reg[22]__0 [1]),
        .I2(spo[7]),
        .I3(\register_file_reg[21]__0 [1]),
        .I4(spo[6]),
        .I5(\register_file_reg[20]__0 [1]),
        .O(\rs1_data[1]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_1 
       (.I0(\rs1_data_reg[2]_i_2_n_0 ),
        .I1(\rs1_data_reg[2]_i_3_n_0 ),
        .I2(spo[10]),
        .I3(\rs1_data_reg[2]_i_4_n_0 ),
        .I4(spo[9]),
        .I5(\rs1_data_reg[2]_i_5_n_0 ),
        .O(\rs1_data[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_10 
       (.I0(\register_file_reg[11]__0 [2]),
        .I1(\register_file_reg[10]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[9]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[8]__0 [2]),
        .O(\rs1_data[2]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_11 
       (.I0(\register_file_reg[15]__0 [2]),
        .I1(\register_file_reg[14]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[13]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[12]__0 [2]),
        .O(\rs1_data[2]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_12 
       (.I0(\register_file_reg[3]__0 [2]),
        .I1(\register_file_reg[2]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[1]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[0]__0 [2]),
        .O(\rs1_data[2]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_13 
       (.I0(\register_file_reg[7]__0 [2]),
        .I1(\register_file_reg[6]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[5]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[4]__0 [2]),
        .O(\rs1_data[2]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_6 
       (.I0(\register_file_reg[27]__0 [2]),
        .I1(\register_file_reg[26]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[25]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[24]__0 [2]),
        .O(\rs1_data[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_7 
       (.I0(\register_file_reg[31]__0 [2]),
        .I1(\register_file_reg[30]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[29]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[28]__0 [2]),
        .O(\rs1_data[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_8 
       (.I0(\register_file_reg[19]__0 [2]),
        .I1(\register_file_reg[18]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[17]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[16]__0 [2]),
        .O(\rs1_data[2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[2]_i_9 
       (.I0(\register_file_reg[23]__0 [2]),
        .I1(\register_file_reg[22]__0 [2]),
        .I2(spo[7]),
        .I3(\register_file_reg[21]__0 [2]),
        .I4(spo[6]),
        .I5(\register_file_reg[20]__0 [2]),
        .O(\rs1_data[2]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_1 
       (.I0(\rs1_data_reg[3]_i_2_n_0 ),
        .I1(\rs1_data_reg[3]_i_3_n_0 ),
        .I2(spo[10]),
        .I3(\rs1_data_reg[3]_i_4_n_0 ),
        .I4(spo[9]),
        .I5(\rs1_data_reg[3]_i_5_n_0 ),
        .O(\rs1_data[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_10 
       (.I0(\register_file_reg[11]__0 [3]),
        .I1(\register_file_reg[10]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[9]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[8]__0 [3]),
        .O(\rs1_data[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_11 
       (.I0(\register_file_reg[15]__0 [3]),
        .I1(\register_file_reg[14]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[13]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[12]__0 [3]),
        .O(\rs1_data[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_12 
       (.I0(\register_file_reg[3]__0 [3]),
        .I1(\register_file_reg[2]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[1]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[0]__0 [3]),
        .O(\rs1_data[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_13 
       (.I0(\register_file_reg[7]__0 [3]),
        .I1(\register_file_reg[6]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[5]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[4]__0 [3]),
        .O(\rs1_data[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_6 
       (.I0(\register_file_reg[27]__0 [3]),
        .I1(\register_file_reg[26]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[25]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[24]__0 [3]),
        .O(\rs1_data[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_7 
       (.I0(\register_file_reg[31]__0 [3]),
        .I1(\register_file_reg[30]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[29]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[28]__0 [3]),
        .O(\rs1_data[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_8 
       (.I0(\register_file_reg[19]__0 [3]),
        .I1(\register_file_reg[18]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[17]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[16]__0 [3]),
        .O(\rs1_data[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[3]_i_9 
       (.I0(\register_file_reg[23]__0 [3]),
        .I1(\register_file_reg[22]__0 [3]),
        .I2(spo[7]),
        .I3(\register_file_reg[21]__0 [3]),
        .I4(spo[6]),
        .I5(\register_file_reg[20]__0 [3]),
        .O(\rs1_data[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_1 
       (.I0(\rs1_data_reg[4]_i_2_n_0 ),
        .I1(\rs1_data_reg[4]_i_3_n_0 ),
        .I2(spo[10]),
        .I3(\rs1_data_reg[4]_i_4_n_0 ),
        .I4(spo[9]),
        .I5(\rs1_data_reg[4]_i_5_n_0 ),
        .O(\rs1_data[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_10 
       (.I0(\register_file_reg[11]__0 [4]),
        .I1(\register_file_reg[10]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[9]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[8]__0 [4]),
        .O(\rs1_data[4]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_11 
       (.I0(\register_file_reg[15]__0 [4]),
        .I1(\register_file_reg[14]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[13]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[12]__0 [4]),
        .O(\rs1_data[4]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_12 
       (.I0(\register_file_reg[3]__0 [4]),
        .I1(\register_file_reg[2]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[1]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[0]__0 [4]),
        .O(\rs1_data[4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_13 
       (.I0(\register_file_reg[7]__0 [4]),
        .I1(\register_file_reg[6]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[5]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[4]__0 [4]),
        .O(\rs1_data[4]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_6 
       (.I0(\register_file_reg[27]__0 [4]),
        .I1(\register_file_reg[26]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[25]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[24]__0 [4]),
        .O(\rs1_data[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_7 
       (.I0(\register_file_reg[31]__0 [4]),
        .I1(\register_file_reg[30]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[29]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[28]__0 [4]),
        .O(\rs1_data[4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_8 
       (.I0(\register_file_reg[19]__0 [4]),
        .I1(\register_file_reg[18]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[17]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[16]__0 [4]),
        .O(\rs1_data[4]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs1_data[4]_i_9 
       (.I0(\register_file_reg[23]__0 [4]),
        .I1(\register_file_reg[22]__0 [4]),
        .I2(spo[7]),
        .I3(\register_file_reg[21]__0 [4]),
        .I4(spo[6]),
        .I5(\register_file_reg[20]__0 [4]),
        .O(\rs1_data[4]_i_9_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs1_data_reg[0] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs1_data[0]_i_1_n_0 ),
        .Q(\rs1_data_reg[4]_0 [0]),
        .R(1'b0));
  MUXF7 \rs1_data_reg[0]_i_2 
       (.I0(\rs1_data[0]_i_6_n_0 ),
        .I1(\rs1_data[0]_i_7_n_0 ),
        .O(\rs1_data_reg[0]_i_2_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[0]_i_3 
       (.I0(\rs1_data[0]_i_8_n_0 ),
        .I1(\rs1_data[0]_i_9_n_0 ),
        .O(\rs1_data_reg[0]_i_3_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[0]_i_4 
       (.I0(\rs1_data[0]_i_10_n_0 ),
        .I1(\rs1_data[0]_i_11_n_0 ),
        .O(\rs1_data_reg[0]_i_4_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[0]_i_5 
       (.I0(\rs1_data[0]_i_12_n_0 ),
        .I1(\rs1_data[0]_i_13_n_0 ),
        .O(\rs1_data_reg[0]_i_5_n_0 ),
        .S(spo[8]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs1_data_reg[1] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs1_data[1]_i_1_n_0 ),
        .Q(\rs1_data_reg[4]_0 [1]),
        .R(1'b0));
  MUXF7 \rs1_data_reg[1]_i_2 
       (.I0(\rs1_data[1]_i_6_n_0 ),
        .I1(\rs1_data[1]_i_7_n_0 ),
        .O(\rs1_data_reg[1]_i_2_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[1]_i_3 
       (.I0(\rs1_data[1]_i_8_n_0 ),
        .I1(\rs1_data[1]_i_9_n_0 ),
        .O(\rs1_data_reg[1]_i_3_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[1]_i_4 
       (.I0(\rs1_data[1]_i_10_n_0 ),
        .I1(\rs1_data[1]_i_11_n_0 ),
        .O(\rs1_data_reg[1]_i_4_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[1]_i_5 
       (.I0(\rs1_data[1]_i_12_n_0 ),
        .I1(\rs1_data[1]_i_13_n_0 ),
        .O(\rs1_data_reg[1]_i_5_n_0 ),
        .S(spo[8]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs1_data_reg[2] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs1_data[2]_i_1_n_0 ),
        .Q(\rs1_data_reg[4]_0 [2]),
        .R(1'b0));
  MUXF7 \rs1_data_reg[2]_i_2 
       (.I0(\rs1_data[2]_i_6_n_0 ),
        .I1(\rs1_data[2]_i_7_n_0 ),
        .O(\rs1_data_reg[2]_i_2_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[2]_i_3 
       (.I0(\rs1_data[2]_i_8_n_0 ),
        .I1(\rs1_data[2]_i_9_n_0 ),
        .O(\rs1_data_reg[2]_i_3_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[2]_i_4 
       (.I0(\rs1_data[2]_i_10_n_0 ),
        .I1(\rs1_data[2]_i_11_n_0 ),
        .O(\rs1_data_reg[2]_i_4_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[2]_i_5 
       (.I0(\rs1_data[2]_i_12_n_0 ),
        .I1(\rs1_data[2]_i_13_n_0 ),
        .O(\rs1_data_reg[2]_i_5_n_0 ),
        .S(spo[8]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs1_data_reg[3] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs1_data[3]_i_1_n_0 ),
        .Q(\rs1_data_reg[4]_0 [3]),
        .R(1'b0));
  MUXF7 \rs1_data_reg[3]_i_2 
       (.I0(\rs1_data[3]_i_6_n_0 ),
        .I1(\rs1_data[3]_i_7_n_0 ),
        .O(\rs1_data_reg[3]_i_2_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[3]_i_3 
       (.I0(\rs1_data[3]_i_8_n_0 ),
        .I1(\rs1_data[3]_i_9_n_0 ),
        .O(\rs1_data_reg[3]_i_3_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[3]_i_4 
       (.I0(\rs1_data[3]_i_10_n_0 ),
        .I1(\rs1_data[3]_i_11_n_0 ),
        .O(\rs1_data_reg[3]_i_4_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[3]_i_5 
       (.I0(\rs1_data[3]_i_12_n_0 ),
        .I1(\rs1_data[3]_i_13_n_0 ),
        .O(\rs1_data_reg[3]_i_5_n_0 ),
        .S(spo[8]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs1_data_reg[4] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs1_data[4]_i_1_n_0 ),
        .Q(\rs1_data_reg[4]_0 [4]),
        .R(1'b0));
  MUXF7 \rs1_data_reg[4]_i_2 
       (.I0(\rs1_data[4]_i_6_n_0 ),
        .I1(\rs1_data[4]_i_7_n_0 ),
        .O(\rs1_data_reg[4]_i_2_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[4]_i_3 
       (.I0(\rs1_data[4]_i_8_n_0 ),
        .I1(\rs1_data[4]_i_9_n_0 ),
        .O(\rs1_data_reg[4]_i_3_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[4]_i_4 
       (.I0(\rs1_data[4]_i_10_n_0 ),
        .I1(\rs1_data[4]_i_11_n_0 ),
        .O(\rs1_data_reg[4]_i_4_n_0 ),
        .S(spo[8]));
  MUXF7 \rs1_data_reg[4]_i_5 
       (.I0(\rs1_data[4]_i_12_n_0 ),
        .I1(\rs1_data[4]_i_13_n_0 ),
        .O(\rs1_data_reg[4]_i_5_n_0 ),
        .S(spo[8]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_1 
       (.I0(\rs2_data_reg[0]_i_2_n_0 ),
        .I1(\rs2_data_reg[0]_i_3_n_0 ),
        .I2(spo[15]),
        .I3(\rs2_data_reg[0]_i_4_n_0 ),
        .I4(spo[14]),
        .I5(\rs2_data_reg[0]_i_5_n_0 ),
        .O(\rs2_data[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_10 
       (.I0(\register_file_reg[11]__0 [0]),
        .I1(\register_file_reg[10]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[9]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[8]__0 [0]),
        .O(\rs2_data[0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_11 
       (.I0(\register_file_reg[15]__0 [0]),
        .I1(\register_file_reg[14]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[13]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[12]__0 [0]),
        .O(\rs2_data[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_12 
       (.I0(\register_file_reg[3]__0 [0]),
        .I1(\register_file_reg[2]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[1]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[0]__0 [0]),
        .O(\rs2_data[0]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_13 
       (.I0(\register_file_reg[7]__0 [0]),
        .I1(\register_file_reg[6]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[5]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[4]__0 [0]),
        .O(\rs2_data[0]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_6 
       (.I0(\register_file_reg[27]__0 [0]),
        .I1(\register_file_reg[26]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[25]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[24]__0 [0]),
        .O(\rs2_data[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_7 
       (.I0(\register_file_reg[31]__0 [0]),
        .I1(\register_file_reg[30]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[29]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[28]__0 [0]),
        .O(\rs2_data[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_8 
       (.I0(\register_file_reg[19]__0 [0]),
        .I1(\register_file_reg[18]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[17]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[16]__0 [0]),
        .O(\rs2_data[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[0]_i_9 
       (.I0(\register_file_reg[23]__0 [0]),
        .I1(\register_file_reg[22]__0 [0]),
        .I2(spo[12]),
        .I3(\register_file_reg[21]__0 [0]),
        .I4(spo[11]),
        .I5(\register_file_reg[20]__0 [0]),
        .O(\rs2_data[0]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_1 
       (.I0(\rs2_data_reg[1]_i_2_n_0 ),
        .I1(\rs2_data_reg[1]_i_3_n_0 ),
        .I2(spo[15]),
        .I3(\rs2_data_reg[1]_i_4_n_0 ),
        .I4(spo[14]),
        .I5(\rs2_data_reg[1]_i_5_n_0 ),
        .O(\rs2_data[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_10 
       (.I0(\register_file_reg[11]__0 [1]),
        .I1(\register_file_reg[10]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[9]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[8]__0 [1]),
        .O(\rs2_data[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_11 
       (.I0(\register_file_reg[15]__0 [1]),
        .I1(\register_file_reg[14]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[13]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[12]__0 [1]),
        .O(\rs2_data[1]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_12 
       (.I0(\register_file_reg[3]__0 [1]),
        .I1(\register_file_reg[2]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[1]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[0]__0 [1]),
        .O(\rs2_data[1]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_13 
       (.I0(\register_file_reg[7]__0 [1]),
        .I1(\register_file_reg[6]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[5]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[4]__0 [1]),
        .O(\rs2_data[1]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_6 
       (.I0(\register_file_reg[27]__0 [1]),
        .I1(\register_file_reg[26]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[25]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[24]__0 [1]),
        .O(\rs2_data[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_7 
       (.I0(\register_file_reg[31]__0 [1]),
        .I1(\register_file_reg[30]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[29]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[28]__0 [1]),
        .O(\rs2_data[1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_8 
       (.I0(\register_file_reg[19]__0 [1]),
        .I1(\register_file_reg[18]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[17]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[16]__0 [1]),
        .O(\rs2_data[1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[1]_i_9 
       (.I0(\register_file_reg[23]__0 [1]),
        .I1(\register_file_reg[22]__0 [1]),
        .I2(spo[12]),
        .I3(\register_file_reg[21]__0 [1]),
        .I4(spo[11]),
        .I5(\register_file_reg[20]__0 [1]),
        .O(\rs2_data[1]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_1 
       (.I0(\rs2_data_reg[2]_i_2_n_0 ),
        .I1(\rs2_data_reg[2]_i_3_n_0 ),
        .I2(spo[15]),
        .I3(\rs2_data_reg[2]_i_4_n_0 ),
        .I4(spo[14]),
        .I5(\rs2_data_reg[2]_i_5_n_0 ),
        .O(\rs2_data[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_10 
       (.I0(\register_file_reg[11]__0 [2]),
        .I1(\register_file_reg[10]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[9]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[8]__0 [2]),
        .O(\rs2_data[2]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_11 
       (.I0(\register_file_reg[15]__0 [2]),
        .I1(\register_file_reg[14]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[13]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[12]__0 [2]),
        .O(\rs2_data[2]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_12 
       (.I0(\register_file_reg[3]__0 [2]),
        .I1(\register_file_reg[2]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[1]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[0]__0 [2]),
        .O(\rs2_data[2]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_13 
       (.I0(\register_file_reg[7]__0 [2]),
        .I1(\register_file_reg[6]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[5]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[4]__0 [2]),
        .O(\rs2_data[2]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_6 
       (.I0(\register_file_reg[27]__0 [2]),
        .I1(\register_file_reg[26]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[25]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[24]__0 [2]),
        .O(\rs2_data[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_7 
       (.I0(\register_file_reg[31]__0 [2]),
        .I1(\register_file_reg[30]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[29]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[28]__0 [2]),
        .O(\rs2_data[2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_8 
       (.I0(\register_file_reg[19]__0 [2]),
        .I1(\register_file_reg[18]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[17]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[16]__0 [2]),
        .O(\rs2_data[2]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[2]_i_9 
       (.I0(\register_file_reg[23]__0 [2]),
        .I1(\register_file_reg[22]__0 [2]),
        .I2(spo[12]),
        .I3(\register_file_reg[21]__0 [2]),
        .I4(spo[11]),
        .I5(\register_file_reg[20]__0 [2]),
        .O(\rs2_data[2]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_1 
       (.I0(\rs2_data_reg[3]_i_2_n_0 ),
        .I1(\rs2_data_reg[3]_i_3_n_0 ),
        .I2(spo[15]),
        .I3(\rs2_data_reg[3]_i_4_n_0 ),
        .I4(spo[14]),
        .I5(\rs2_data_reg[3]_i_5_n_0 ),
        .O(\rs2_data[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_10 
       (.I0(\register_file_reg[11]__0 [3]),
        .I1(\register_file_reg[10]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[9]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[8]__0 [3]),
        .O(\rs2_data[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_11 
       (.I0(\register_file_reg[15]__0 [3]),
        .I1(\register_file_reg[14]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[13]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[12]__0 [3]),
        .O(\rs2_data[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_12 
       (.I0(\register_file_reg[3]__0 [3]),
        .I1(\register_file_reg[2]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[1]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[0]__0 [3]),
        .O(\rs2_data[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_13 
       (.I0(\register_file_reg[7]__0 [3]),
        .I1(\register_file_reg[6]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[5]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[4]__0 [3]),
        .O(\rs2_data[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_6 
       (.I0(\register_file_reg[27]__0 [3]),
        .I1(\register_file_reg[26]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[25]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[24]__0 [3]),
        .O(\rs2_data[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_7 
       (.I0(\register_file_reg[31]__0 [3]),
        .I1(\register_file_reg[30]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[29]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[28]__0 [3]),
        .O(\rs2_data[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_8 
       (.I0(\register_file_reg[19]__0 [3]),
        .I1(\register_file_reg[18]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[17]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[16]__0 [3]),
        .O(\rs2_data[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[3]_i_9 
       (.I0(\register_file_reg[23]__0 [3]),
        .I1(\register_file_reg[22]__0 [3]),
        .I2(spo[12]),
        .I3(\register_file_reg[21]__0 [3]),
        .I4(spo[11]),
        .I5(\register_file_reg[20]__0 [3]),
        .O(\rs2_data[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_1 
       (.I0(\rs2_data_reg[4]_i_2_n_0 ),
        .I1(\rs2_data_reg[4]_i_3_n_0 ),
        .I2(spo[15]),
        .I3(\rs2_data_reg[4]_i_4_n_0 ),
        .I4(spo[14]),
        .I5(\rs2_data_reg[4]_i_5_n_0 ),
        .O(\rs2_data[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_10 
       (.I0(\register_file_reg[11]__0 [4]),
        .I1(\register_file_reg[10]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[9]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[8]__0 [4]),
        .O(\rs2_data[4]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_11 
       (.I0(\register_file_reg[15]__0 [4]),
        .I1(\register_file_reg[14]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[13]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[12]__0 [4]),
        .O(\rs2_data[4]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_12 
       (.I0(\register_file_reg[3]__0 [4]),
        .I1(\register_file_reg[2]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[1]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[0]__0 [4]),
        .O(\rs2_data[4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_13 
       (.I0(\register_file_reg[7]__0 [4]),
        .I1(\register_file_reg[6]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[5]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[4]__0 [4]),
        .O(\rs2_data[4]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_6 
       (.I0(\register_file_reg[27]__0 [4]),
        .I1(\register_file_reg[26]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[25]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[24]__0 [4]),
        .O(\rs2_data[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_7 
       (.I0(\register_file_reg[31]__0 [4]),
        .I1(\register_file_reg[30]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[29]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[28]__0 [4]),
        .O(\rs2_data[4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_8 
       (.I0(\register_file_reg[19]__0 [4]),
        .I1(\register_file_reg[18]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[17]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[16]__0 [4]),
        .O(\rs2_data[4]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \rs2_data[4]_i_9 
       (.I0(\register_file_reg[23]__0 [4]),
        .I1(\register_file_reg[22]__0 [4]),
        .I2(spo[12]),
        .I3(\register_file_reg[21]__0 [4]),
        .I4(spo[11]),
        .I5(\register_file_reg[20]__0 [4]),
        .O(\rs2_data[4]_i_9_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs2_data_reg[0] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs2_data[0]_i_1_n_0 ),
        .Q(\rs2_data_reg[4]_0 [0]),
        .R(1'b0));
  MUXF7 \rs2_data_reg[0]_i_2 
       (.I0(\rs2_data[0]_i_6_n_0 ),
        .I1(\rs2_data[0]_i_7_n_0 ),
        .O(\rs2_data_reg[0]_i_2_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[0]_i_3 
       (.I0(\rs2_data[0]_i_8_n_0 ),
        .I1(\rs2_data[0]_i_9_n_0 ),
        .O(\rs2_data_reg[0]_i_3_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[0]_i_4 
       (.I0(\rs2_data[0]_i_10_n_0 ),
        .I1(\rs2_data[0]_i_11_n_0 ),
        .O(\rs2_data_reg[0]_i_4_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[0]_i_5 
       (.I0(\rs2_data[0]_i_12_n_0 ),
        .I1(\rs2_data[0]_i_13_n_0 ),
        .O(\rs2_data_reg[0]_i_5_n_0 ),
        .S(spo[13]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs2_data_reg[1] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs2_data[1]_i_1_n_0 ),
        .Q(\rs2_data_reg[4]_0 [1]),
        .R(1'b0));
  MUXF7 \rs2_data_reg[1]_i_2 
       (.I0(\rs2_data[1]_i_6_n_0 ),
        .I1(\rs2_data[1]_i_7_n_0 ),
        .O(\rs2_data_reg[1]_i_2_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[1]_i_3 
       (.I0(\rs2_data[1]_i_8_n_0 ),
        .I1(\rs2_data[1]_i_9_n_0 ),
        .O(\rs2_data_reg[1]_i_3_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[1]_i_4 
       (.I0(\rs2_data[1]_i_10_n_0 ),
        .I1(\rs2_data[1]_i_11_n_0 ),
        .O(\rs2_data_reg[1]_i_4_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[1]_i_5 
       (.I0(\rs2_data[1]_i_12_n_0 ),
        .I1(\rs2_data[1]_i_13_n_0 ),
        .O(\rs2_data_reg[1]_i_5_n_0 ),
        .S(spo[13]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs2_data_reg[2] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs2_data[2]_i_1_n_0 ),
        .Q(\rs2_data_reg[4]_0 [2]),
        .R(1'b0));
  MUXF7 \rs2_data_reg[2]_i_2 
       (.I0(\rs2_data[2]_i_6_n_0 ),
        .I1(\rs2_data[2]_i_7_n_0 ),
        .O(\rs2_data_reg[2]_i_2_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[2]_i_3 
       (.I0(\rs2_data[2]_i_8_n_0 ),
        .I1(\rs2_data[2]_i_9_n_0 ),
        .O(\rs2_data_reg[2]_i_3_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[2]_i_4 
       (.I0(\rs2_data[2]_i_10_n_0 ),
        .I1(\rs2_data[2]_i_11_n_0 ),
        .O(\rs2_data_reg[2]_i_4_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[2]_i_5 
       (.I0(\rs2_data[2]_i_12_n_0 ),
        .I1(\rs2_data[2]_i_13_n_0 ),
        .O(\rs2_data_reg[2]_i_5_n_0 ),
        .S(spo[13]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs2_data_reg[3] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs2_data[3]_i_1_n_0 ),
        .Q(\rs2_data_reg[4]_0 [3]),
        .R(1'b0));
  MUXF7 \rs2_data_reg[3]_i_2 
       (.I0(\rs2_data[3]_i_6_n_0 ),
        .I1(\rs2_data[3]_i_7_n_0 ),
        .O(\rs2_data_reg[3]_i_2_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[3]_i_3 
       (.I0(\rs2_data[3]_i_8_n_0 ),
        .I1(\rs2_data[3]_i_9_n_0 ),
        .O(\rs2_data_reg[3]_i_3_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[3]_i_4 
       (.I0(\rs2_data[3]_i_10_n_0 ),
        .I1(\rs2_data[3]_i_11_n_0 ),
        .O(\rs2_data_reg[3]_i_4_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[3]_i_5 
       (.I0(\rs2_data[3]_i_12_n_0 ),
        .I1(\rs2_data[3]_i_13_n_0 ),
        .O(\rs2_data_reg[3]_i_5_n_0 ),
        .S(spo[13]));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rs2_data_reg[4] 
       (.C(clk_used_BUFG),
        .CE(1'b1),
        .D(\rs2_data[4]_i_1_n_0 ),
        .Q(\rs2_data_reg[4]_0 [4]),
        .R(1'b0));
  MUXF7 \rs2_data_reg[4]_i_2 
       (.I0(\rs2_data[4]_i_6_n_0 ),
        .I1(\rs2_data[4]_i_7_n_0 ),
        .O(\rs2_data_reg[4]_i_2_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[4]_i_3 
       (.I0(\rs2_data[4]_i_8_n_0 ),
        .I1(\rs2_data[4]_i_9_n_0 ),
        .O(\rs2_data_reg[4]_i_3_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[4]_i_4 
       (.I0(\rs2_data[4]_i_10_n_0 ),
        .I1(\rs2_data[4]_i_11_n_0 ),
        .O(\rs2_data_reg[4]_i_4_n_0 ),
        .S(spo[13]));
  MUXF7 \rs2_data_reg[4]_i_5 
       (.I0(\rs2_data[4]_i_12_n_0 ),
        .I1(\rs2_data[4]_i_13_n_0 ),
        .O(\rs2_data_reg[4]_i_5_n_0 ),
        .S(spo[13]));
endmodule

(* NotValidForBitStream *)
module riscv
   (clk,
    rstn,
    sw_i,
    disp_an_o,
    disp_seg_o);
  input clk;
  input rstn;
  input [15:0]sw_i;
  output [7:0]disp_an_o;
  output [7:0]disp_seg_o;

  wire [4:0]A;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire clk_used;
  wire clk_used_BUFG;
  wire [12:12]counter_reg;
  wire [27:27]counter_reg_0;
  wire [7:0]disp_an_o;
  wire [7:0]disp_an_o_OBUF;
  wire [7:0]disp_seg_o;
  wire [6:0]disp_seg_o_OBUF;
  wire \disp_seg_o_OBUF[6]_inst_i_2_n_0 ;
  wire [6:2]dm_addr;
  wire [30:26]dm_disp_data;
  wire [31:1]instr;
  wire [4:0]pc;
  wire \register_file_reg[0]0 ;
  wire \register_file_reg[10]0 ;
  wire \register_file_reg[11]0 ;
  wire \register_file_reg[12]0 ;
  wire \register_file_reg[13]0 ;
  wire \register_file_reg[14]0 ;
  wire \register_file_reg[15]0 ;
  wire \register_file_reg[16]0 ;
  wire \register_file_reg[17]0 ;
  wire \register_file_reg[18]0 ;
  wire \register_file_reg[19]0 ;
  wire \register_file_reg[1]0 ;
  wire \register_file_reg[20]0 ;
  wire \register_file_reg[21]0 ;
  wire \register_file_reg[22]0 ;
  wire \register_file_reg[23]0 ;
  wire \register_file_reg[24]0 ;
  wire \register_file_reg[25]0 ;
  wire \register_file_reg[26]0 ;
  wire \register_file_reg[27]0 ;
  wire \register_file_reg[28]0 ;
  wire \register_file_reg[29]0 ;
  wire \register_file_reg[2]0 ;
  wire \register_file_reg[30]0 ;
  wire \register_file_reg[3]0 ;
  wire \register_file_reg[4]0 ;
  wire \register_file_reg[5]0 ;
  wire \register_file_reg[6]0 ;
  wire \register_file_reg[7]0 ;
  wire \register_file_reg[8]0 ;
  wire \register_file_reg[9]0 ;
  wire [4:0]rf_addr;
  wire [3:0]rf_disp_data;
  wire rstn;
  wire rstn_IBUF;
  wire [1:0]selector;
  wire [15:0]sw_i;
  wire [15:0]sw_i_IBUF;
  wire u_alu_addr_n_0;
  wire u_alu_addr_n_1;
  wire u_alu_addr_n_2;
  wire u_alu_addr_n_3;
  wire u_alu_addr_n_4;
  wire u_alu_addr_n_5;
  wire u_disp_seg16x_n_9;
  wire u_dm_n_0;
  wire u_dm_n_6;
  wire u_dm_n_7;
  wire u_dm_n_8;
  wire u_dm_n_9;
  wire u_im_n_60;
  wire u_im_n_61;
  wire u_im_n_62;
  wire u_im_n_63;
  wire u_im_n_64;
  wire u_im_n_65;
  wire u_im_n_66;
  wire u_rf_n_0;
  wire u_rf_n_11;
  wire u_rf_n_12;
  wire u_rf_n_13;
  wire u_rf_n_14;
  wire u_rf_n_15;
  wire u_rf_n_5;

  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  BUFG clk_used_BUFG_inst
       (.I(clk_used),
        .O(clk_used_BUFG));
  OBUF \disp_an_o_OBUF[0]_inst 
       (.I(disp_an_o_OBUF[0]),
        .O(disp_an_o[0]));
  OBUF \disp_an_o_OBUF[1]_inst 
       (.I(disp_an_o_OBUF[1]),
        .O(disp_an_o[1]));
  OBUF \disp_an_o_OBUF[2]_inst 
       (.I(disp_an_o_OBUF[2]),
        .O(disp_an_o[2]));
  OBUF \disp_an_o_OBUF[3]_inst 
       (.I(disp_an_o_OBUF[3]),
        .O(disp_an_o[3]));
  OBUF \disp_an_o_OBUF[4]_inst 
       (.I(disp_an_o_OBUF[4]),
        .O(disp_an_o[4]));
  OBUF \disp_an_o_OBUF[5]_inst 
       (.I(disp_an_o_OBUF[5]),
        .O(disp_an_o[5]));
  OBUF \disp_an_o_OBUF[6]_inst 
       (.I(disp_an_o_OBUF[6]),
        .O(disp_an_o[6]));
  OBUF \disp_an_o_OBUF[7]_inst 
       (.I(disp_an_o_OBUF[7]),
        .O(disp_an_o[7]));
  OBUF \disp_seg_o_OBUF[0]_inst 
       (.I(disp_seg_o_OBUF[0]),
        .O(disp_seg_o[0]));
  OBUF \disp_seg_o_OBUF[1]_inst 
       (.I(disp_seg_o_OBUF[1]),
        .O(disp_seg_o[1]));
  OBUF \disp_seg_o_OBUF[2]_inst 
       (.I(disp_seg_o_OBUF[2]),
        .O(disp_seg_o[2]));
  OBUF \disp_seg_o_OBUF[3]_inst 
       (.I(disp_seg_o_OBUF[3]),
        .O(disp_seg_o[3]));
  OBUF \disp_seg_o_OBUF[4]_inst 
       (.I(disp_seg_o_OBUF[4]),
        .O(disp_seg_o[4]));
  OBUF \disp_seg_o_OBUF[5]_inst 
       (.I(disp_seg_o_OBUF[5]),
        .O(disp_seg_o[5]));
  OBUF \disp_seg_o_OBUF[6]_inst 
       (.I(disp_seg_o_OBUF[6]),
        .O(disp_seg_o[6]));
  LUT4 #(
    .INIT(16'h0116)) 
    \disp_seg_o_OBUF[6]_inst_i_2 
       (.I0(sw_i_IBUF[11]),
        .I1(sw_i_IBUF[12]),
        .I2(sw_i_IBUF[13]),
        .I3(sw_i_IBUF[14]),
        .O(\disp_seg_o_OBUF[6]_inst_i_2_n_0 ));
  OBUF \disp_seg_o_OBUF[7]_inst 
       (.I(1'b1),
        .O(disp_seg_o[7]));
  clk_divider__parameterized1 div12
       (.O643(counter_reg),
        .clk(clk_IBUF_BUFG));
  clk_divider div24
       (.S(counter_reg_0),
        .clk(clk_IBUF_BUFG),
        .clk_used(clk_used),
        .sw_i_IBUF(sw_i_IBUF[15]));
  clk_divider__parameterized0 div27
       (.S(counter_reg_0),
        .clk(clk_IBUF_BUFG));
  IBUF rstn_IBUF_inst
       (.I(rstn),
        .O(rstn_IBUF));
  IBUF \sw_i_IBUF[0]_inst 
       (.I(sw_i[0]),
        .O(sw_i_IBUF[0]));
  IBUF \sw_i_IBUF[11]_inst 
       (.I(sw_i[11]),
        .O(sw_i_IBUF[11]));
  IBUF \sw_i_IBUF[12]_inst 
       (.I(sw_i[12]),
        .O(sw_i_IBUF[12]));
  IBUF \sw_i_IBUF[13]_inst 
       (.I(sw_i[13]),
        .O(sw_i_IBUF[13]));
  IBUF \sw_i_IBUF[14]_inst 
       (.I(sw_i[14]),
        .O(sw_i_IBUF[14]));
  IBUF \sw_i_IBUF[15]_inst 
       (.I(sw_i[15]),
        .O(sw_i_IBUF[15]));
  IBUF \sw_i_IBUF[1]_inst 
       (.I(sw_i[1]),
        .O(sw_i_IBUF[1]));
  IBUF \sw_i_IBUF[2]_inst 
       (.I(sw_i[2]),
        .O(sw_i_IBUF[2]));
  IBUF \sw_i_IBUF[3]_inst 
       (.I(sw_i[3]),
        .O(sw_i_IBUF[3]));
  addr_controller__parameterized0 u_alu_addr
       (.Q(selector[0]),
        .clk_used_BUFG(clk_used_BUFG),
        .\data_out_reg[0]_0 (u_rf_n_5),
        .\data_out_reg[1]_0 (u_alu_addr_n_0),
        .\data_out_reg[1]_1 (u_alu_addr_n_2),
        .\data_out_reg[2]_0 (u_alu_addr_n_3),
        .\data_out_reg[2]_1 (u_alu_addr_n_4),
        .\data_out_reg[2]_2 (u_alu_addr_n_5),
        .\disp_seg_o_OBUF[6]_inst_i_3 (u_rf_n_0),
        .\disp_seg_o_OBUF[6]_inst_i_3_0 (u_dm_n_6),
        .\disp_seg_o_OBUF[6]_inst_i_3_1 (u_im_n_63),
        .\disp_seg_o_OBUF[6]_inst_i_7_0 (A),
        .\disp_seg_o_OBUF[6]_inst_i_7_1 ({u_rf_n_11,u_rf_n_12,u_rf_n_13,u_rf_n_14,u_rf_n_15}),
        .\selector_reg[0] (u_alu_addr_n_1),
        .sw_i_IBUF({sw_i_IBUF[12],sw_i_IBUF[2]}));
  disp_seg16x u_disp_seg16x
       (.O643(counter_reg),
        .Q(selector),
        .disp_an_o_OBUF(disp_an_o_OBUF),
        .\disp_seg_o[5] (\disp_seg_o_OBUF[6]_inst_i_2_n_0 ),
        .disp_seg_o_OBUF(disp_seg_o_OBUF),
        .\disp_seg_o_OBUF[4]_inst_i_1_0 (u_alu_addr_n_2),
        .\disp_seg_o_OBUF[4]_inst_i_1_1 (u_im_n_60),
        .\disp_seg_o_OBUF[5]_inst_i_1_0 (u_im_n_66),
        .\disp_seg_o_OBUF[5]_inst_i_1_1 (u_alu_addr_n_1),
        .\disp_seg_o_OBUF[5]_inst_i_1_2 (u_im_n_62),
        .\disp_seg_o_OBUF[5]_inst_i_2_0 (u_im_n_61),
        .\disp_seg_o_OBUF[5]_inst_i_2_1 (u_alu_addr_n_3),
        .\disp_seg_o_OBUF[5]_inst_i_3_0 (u_dm_n_8),
        .\disp_seg_o_OBUF[6]_inst_i_20_0 (rf_disp_data[3:1]),
        .\disp_seg_o_OBUF[6]_inst_i_3_0 (u_dm_n_6),
        .\disp_seg_o_OBUF[6]_inst_i_4_0 (u_alu_addr_n_0),
        .\disp_seg_o_OBUF[6]_inst_i_4_1 (u_alu_addr_n_5),
        .\disp_seg_o_OBUF[6]_inst_i_4_2 (u_dm_n_7),
        .\disp_seg_o_OBUF[6]_inst_i_6_0 (u_im_n_64),
        .\disp_seg_o_OBUF[6]_inst_i_6_1 (u_alu_addr_n_4),
        .dm_disp_data(dm_disp_data),
        .\selector_reg[1]_0 (u_disp_seg16x_n_9),
        .spo({instr[31:26],instr[24:18],instr[16],instr[14:12],instr[10:5],instr[2:1]}),
        .sw_i_IBUF(sw_i_IBUF[14:11]));
  data_memory u_dm
       (.Q(dm_addr),
        .clk_used_BUFG(clk_used_BUFG),
        .\disp_data_reg[26]_0 (u_dm_n_7),
        .\disp_data_reg[27]_0 (u_dm_n_9),
        .\disp_data_reg[28]_0 (u_dm_n_6),
        .\disp_data_reg[29]_0 (u_dm_n_0),
        .\disp_data_reg[30]_0 (u_dm_n_8),
        .dm_disp_data(dm_disp_data),
        .spo(instr[2]),
        .sw_i_IBUF({sw_i_IBUF[14],sw_i_IBUF[11]}));
  dm_addr_controller u_dm_addr
       (.Q(dm_addr),
        .clk_used_BUFG(clk_used_BUFG),
        .\data_out_reg[5]_0 (u_rf_n_5),
        .sw_i_IBUF(sw_i_IBUF[3]));
  instruction_memory u_im
       (.E(\register_file_reg[24]0 ),
        .Q(selector),
        .\bbstub_spo[10] (\register_file_reg[11]0 ),
        .\bbstub_spo[10]_0 (\register_file_reg[13]0 ),
        .\bbstub_spo[10]_1 (\register_file_reg[14]0 ),
        .\bbstub_spo[10]_2 (\register_file_reg[25]0 ),
        .\bbstub_spo[10]_3 (\register_file_reg[26]0 ),
        .\bbstub_spo[10]_4 (\register_file_reg[28]0 ),
        .\bbstub_spo[11] (\register_file_reg[8]0 ),
        .\bbstub_spo[11]_0 (\register_file_reg[1]0 ),
        .\bbstub_spo[11]_1 (\register_file_reg[3]0 ),
        .\bbstub_spo[11]_10 (\register_file_reg[9]0 ),
        .\bbstub_spo[11]_11 (\register_file_reg[21]0 ),
        .\bbstub_spo[11]_12 (\register_file_reg[22]0 ),
        .\bbstub_spo[11]_2 (\register_file_reg[5]0 ),
        .\bbstub_spo[11]_3 (\register_file_reg[6]0 ),
        .\bbstub_spo[11]_4 (\register_file_reg[4]0 ),
        .\bbstub_spo[11]_5 (\register_file_reg[2]0 ),
        .\bbstub_spo[11]_6 (\register_file_reg[19]0 ),
        .\bbstub_spo[11]_7 (\register_file_reg[27]0 ),
        .\bbstub_spo[11]_8 (\register_file_reg[10]0 ),
        .\bbstub_spo[11]_9 (\register_file_reg[12]0 ),
        .\bbstub_spo[7] (\register_file_reg[16]0 ),
        .\bbstub_spo[7]_0 (\register_file_reg[18]0 ),
        .\bbstub_spo[8] (\register_file_reg[20]0 ),
        .\bbstub_spo[8]_0 (\register_file_reg[17]0 ),
        .\bbstub_spo[9] (\register_file_reg[0]0 ),
        .\bbstub_spo[9]_0 (\register_file_reg[15]0 ),
        .\bbstub_spo[9]_1 (\register_file_reg[23]0 ),
        .\bbstub_spo[9]_2 (\register_file_reg[7]0 ),
        .\bbstub_spo[9]_3 (\register_file_reg[29]0 ),
        .\bbstub_spo[9]_4 (\register_file_reg[30]0 ),
        .\bbstub_spo[9]_5 (u_im_n_65),
        .\disp_data_reg[0] (u_im_n_63),
        .\disp_data_reg[27] (u_im_n_64),
        .\disp_data_reg[29] (u_im_n_60),
        .\disp_seg_o_OBUF[5]_inst_i_2 (u_dm_n_0),
        .\disp_seg_o_OBUF[6]_inst_i_5 (u_disp_seg16x_n_9),
        .\disp_seg_o_OBUF[6]_inst_i_6 (u_dm_n_9),
        .\disp_seg_o_OBUF[6]_inst_i_7 (rf_disp_data[0]),
        .dm_disp_data({dm_disp_data[29],dm_disp_data[27]}),
        .out(pc),
        .\selector_reg[0] (u_im_n_62),
        .\selector_reg[0]_0 (u_im_n_66),
        .\selector_reg[1] (u_im_n_61),
        .spo({instr[31:26],instr[24:4],instr[2:1]}),
        .sw_i_IBUF({sw_i_IBUF[14:13],sw_i_IBUF[11]}));
  pc u_pc
       (.clk_used_BUFG(clk_used_BUFG),
        .out(pc),
        .\pc_reg[4]_0 (u_rf_n_5),
        .sw_i_IBUF(sw_i_IBUF[1]));
  register_file u_rf
       (.E(\register_file_reg[30]0 ),
        .Q(rf_addr),
        .clk_used_BUFG(clk_used_BUFG),
        .\disp_data_reg[3]_0 (rf_disp_data),
        .\disp_data_reg[4]_0 (u_rf_n_0),
        .\register_file_reg[0][4]_0 (\register_file_reg[0]0 ),
        .\register_file_reg[10][4]_0 (\register_file_reg[10]0 ),
        .\register_file_reg[11][4]_0 (\register_file_reg[11]0 ),
        .\register_file_reg[12][4]_0 (\register_file_reg[12]0 ),
        .\register_file_reg[13][4]_0 (\register_file_reg[13]0 ),
        .\register_file_reg[14][4]_0 (\register_file_reg[14]0 ),
        .\register_file_reg[15][4]_0 (\register_file_reg[15]0 ),
        .\register_file_reg[16][4]_0 (\register_file_reg[16]0 ),
        .\register_file_reg[17][4]_0 (\register_file_reg[17]0 ),
        .\register_file_reg[18][4]_0 (\register_file_reg[18]0 ),
        .\register_file_reg[19][4]_0 (\register_file_reg[19]0 ),
        .\register_file_reg[1][4]_0 (\register_file_reg[1]0 ),
        .\register_file_reg[20][4]_0 (\register_file_reg[20]0 ),
        .\register_file_reg[21][4]_0 (\register_file_reg[21]0 ),
        .\register_file_reg[22][4]_0 (\register_file_reg[22]0 ),
        .\register_file_reg[23][4]_0 (\register_file_reg[23]0 ),
        .\register_file_reg[24][4]_0 (\register_file_reg[24]0 ),
        .\register_file_reg[25][4]_0 (\register_file_reg[25]0 ),
        .\register_file_reg[26][4]_0 (\register_file_reg[26]0 ),
        .\register_file_reg[27][4]_0 (\register_file_reg[27]0 ),
        .\register_file_reg[28][4]_0 (\register_file_reg[28]0 ),
        .\register_file_reg[29][4]_0 (\register_file_reg[29]0 ),
        .\register_file_reg[2][4]_0 (\register_file_reg[2]0 ),
        .\register_file_reg[31][0]_0 (u_im_n_65),
        .\register_file_reg[3][4]_0 (\register_file_reg[3]0 ),
        .\register_file_reg[4][4]_0 (\register_file_reg[4]0 ),
        .\register_file_reg[5][4]_0 (\register_file_reg[5]0 ),
        .\register_file_reg[6][4]_0 (\register_file_reg[6]0 ),
        .\register_file_reg[7][4]_0 (\register_file_reg[7]0 ),
        .\register_file_reg[8][4]_0 (\register_file_reg[8]0 ),
        .\register_file_reg[9][4]_0 (\register_file_reg[9]0 ),
        .\rs1_data_reg[4]_0 (A),
        .\rs2_data_reg[4]_0 ({u_rf_n_11,u_rf_n_12,u_rf_n_13,u_rf_n_14,u_rf_n_15}),
        .rstn(u_rf_n_5),
        .rstn_IBUF(rstn_IBUF),
        .spo({instr[24:15],instr[11:7],instr[4]}),
        .sw_i_IBUF(sw_i_IBUF[14:13]));
  addr_controller u_rf_addr
       (.Q(rf_addr),
        .clk_used_BUFG(clk_used_BUFG),
        .\data_out_reg[0]_0 (u_rf_n_5),
        .sw_i_IBUF(sw_i_IBUF[0]));
endmodule

(* C_ADDR_WIDTH = "6" *) (* C_DEFAULT_DATA = "0" *) (* C_DEPTH = "64" *) 
(* C_ELABORATION_DIR = "./" *) (* C_FAMILY = "artix7" *) (* C_HAS_CLK = "0" *) 
(* C_HAS_D = "0" *) (* C_HAS_DPO = "0" *) (* C_HAS_DPRA = "0" *) 
(* C_HAS_I_CE = "0" *) (* C_HAS_QDPO = "0" *) (* C_HAS_QDPO_CE = "0" *) 
(* C_HAS_QDPO_CLK = "0" *) (* C_HAS_QDPO_RST = "0" *) (* C_HAS_QDPO_SRST = "0" *) 
(* C_HAS_QSPO = "0" *) (* C_HAS_QSPO_CE = "0" *) (* C_HAS_QSPO_RST = "0" *) 
(* C_HAS_QSPO_SRST = "0" *) (* C_HAS_SPO = "1" *) (* C_HAS_WE = "0" *) 
(* C_MEM_INIT_FILE = "dist_mem_im.mif" *) (* C_MEM_TYPE = "0" *) (* C_PARSER_TYPE = "1" *) 
(* C_PIPELINE_STAGES = "0" *) (* C_QCE_JOINED = "0" *) (* C_QUALIFY_WE = "0" *) 
(* C_READ_MIF = "1" *) (* C_REG_A_D_INPUTS = "0" *) (* C_REG_DPRA_INPUT = "0" *) 
(* C_SYNC_ENABLE = "1" *) (* C_WIDTH = "32" *) (* ORIG_REF_NAME = "dist_mem_gen_v8_0_12" *) 
module dist_mem_im_dist_mem_gen_v8_0_12
   (a,
    d,
    dpra,
    clk,
    we,
    i_ce,
    qspo_ce,
    qdpo_ce,
    qdpo_clk,
    qspo_rst,
    qdpo_rst,
    qspo_srst,
    qdpo_srst,
    spo,
    dpo,
    qspo,
    qdpo);
  input [5:0]a;
  input [31:0]d;
  input [5:0]dpra;
  input clk;
  input we;
  input i_ce;
  input qspo_ce;
  input qdpo_ce;
  input qdpo_clk;
  input qspo_rst;
  input qdpo_rst;
  input qspo_srst;
  input qdpo_srst;
  output [31:0]spo;
  output [31:0]dpo;
  output [31:0]qspo;
  output [31:0]qdpo;

  wire \<const0> ;
  wire [5:0]a;
  wire [21:1]\^spo ;

  assign dpo[31] = \<const0> ;
  assign dpo[30] = \<const0> ;
  assign dpo[29] = \<const0> ;
  assign dpo[28] = \<const0> ;
  assign dpo[27] = \<const0> ;
  assign dpo[26] = \<const0> ;
  assign dpo[25] = \<const0> ;
  assign dpo[24] = \<const0> ;
  assign dpo[23] = \<const0> ;
  assign dpo[22] = \<const0> ;
  assign dpo[21] = \<const0> ;
  assign dpo[20] = \<const0> ;
  assign dpo[19] = \<const0> ;
  assign dpo[18] = \<const0> ;
  assign dpo[17] = \<const0> ;
  assign dpo[16] = \<const0> ;
  assign dpo[15] = \<const0> ;
  assign dpo[14] = \<const0> ;
  assign dpo[13] = \<const0> ;
  assign dpo[12] = \<const0> ;
  assign dpo[11] = \<const0> ;
  assign dpo[10] = \<const0> ;
  assign dpo[9] = \<const0> ;
  assign dpo[8] = \<const0> ;
  assign dpo[7] = \<const0> ;
  assign dpo[6] = \<const0> ;
  assign dpo[5] = \<const0> ;
  assign dpo[4] = \<const0> ;
  assign dpo[3] = \<const0> ;
  assign dpo[2] = \<const0> ;
  assign dpo[1] = \<const0> ;
  assign dpo[0] = \<const0> ;
  assign qdpo[31] = \<const0> ;
  assign qdpo[30] = \<const0> ;
  assign qdpo[29] = \<const0> ;
  assign qdpo[28] = \<const0> ;
  assign qdpo[27] = \<const0> ;
  assign qdpo[26] = \<const0> ;
  assign qdpo[25] = \<const0> ;
  assign qdpo[24] = \<const0> ;
  assign qdpo[23] = \<const0> ;
  assign qdpo[22] = \<const0> ;
  assign qdpo[21] = \<const0> ;
  assign qdpo[20] = \<const0> ;
  assign qdpo[19] = \<const0> ;
  assign qdpo[18] = \<const0> ;
  assign qdpo[17] = \<const0> ;
  assign qdpo[16] = \<const0> ;
  assign qdpo[15] = \<const0> ;
  assign qdpo[14] = \<const0> ;
  assign qdpo[13] = \<const0> ;
  assign qdpo[12] = \<const0> ;
  assign qdpo[11] = \<const0> ;
  assign qdpo[10] = \<const0> ;
  assign qdpo[9] = \<const0> ;
  assign qdpo[8] = \<const0> ;
  assign qdpo[7] = \<const0> ;
  assign qdpo[6] = \<const0> ;
  assign qdpo[5] = \<const0> ;
  assign qdpo[4] = \<const0> ;
  assign qdpo[3] = \<const0> ;
  assign qdpo[2] = \<const0> ;
  assign qdpo[1] = \<const0> ;
  assign qdpo[0] = \<const0> ;
  assign qspo[31] = \<const0> ;
  assign qspo[30] = \<const0> ;
  assign qspo[29] = \<const0> ;
  assign qspo[28] = \<const0> ;
  assign qspo[27] = \<const0> ;
  assign qspo[26] = \<const0> ;
  assign qspo[25] = \<const0> ;
  assign qspo[24] = \<const0> ;
  assign qspo[23] = \<const0> ;
  assign qspo[22] = \<const0> ;
  assign qspo[21] = \<const0> ;
  assign qspo[20] = \<const0> ;
  assign qspo[19] = \<const0> ;
  assign qspo[18] = \<const0> ;
  assign qspo[17] = \<const0> ;
  assign qspo[16] = \<const0> ;
  assign qspo[15] = \<const0> ;
  assign qspo[14] = \<const0> ;
  assign qspo[13] = \<const0> ;
  assign qspo[12] = \<const0> ;
  assign qspo[11] = \<const0> ;
  assign qspo[10] = \<const0> ;
  assign qspo[9] = \<const0> ;
  assign qspo[8] = \<const0> ;
  assign qspo[7] = \<const0> ;
  assign qspo[6] = \<const0> ;
  assign qspo[5] = \<const0> ;
  assign qspo[4] = \<const0> ;
  assign qspo[3] = \<const0> ;
  assign qspo[2] = \<const0> ;
  assign qspo[1] = \<const0> ;
  assign qspo[0] = \<const0> ;
  assign spo[31] = \<const0> ;
  assign spo[30] = \<const0> ;
  assign spo[29] = \<const0> ;
  assign spo[28] = \<const0> ;
  assign spo[27] = \<const0> ;
  assign spo[26] = \<const0> ;
  assign spo[25] = \<const0> ;
  assign spo[24] = \<const0> ;
  assign spo[23] = \<const0> ;
  assign spo[22] = \<const0> ;
  assign spo[21:20] = \^spo [21:20];
  assign spo[19] = \<const0> ;
  assign spo[18] = \<const0> ;
  assign spo[17] = \<const0> ;
  assign spo[16:15] = \^spo [16:15];
  assign spo[14] = \<const0> ;
  assign spo[13] = \^spo [13];
  assign spo[12] = \<const0> ;
  assign spo[11] = \<const0> ;
  assign spo[10] = \<const0> ;
  assign spo[9:7] = \^spo [9:7];
  assign spo[6] = \<const0> ;
  assign spo[5:4] = \^spo [5:4];
  assign spo[3] = \<const0> ;
  assign spo[2] = \<const0> ;
  assign spo[1] = \^spo [1];
  assign spo[0] = \^spo [1];
  GND GND
       (.G(\<const0> ));
  dist_mem_im_dist_mem_gen_v8_0_12_synth \synth_options.dist_mem_inst 
       (.a(a),
        .spo({\^spo [21:20],\^spo [16:15],\^spo [13],\^spo [9:7],\^spo [5:4],\^spo [1]}));
endmodule

(* ORIG_REF_NAME = "dist_mem_gen_v8_0_12_synth" *) 
module dist_mem_im_dist_mem_gen_v8_0_12_synth
   (spo,
    a);
  output [10:0]spo;
  input [5:0]a;

  wire [5:0]a;
  wire [10:0]spo;

  dist_mem_im_rom \gen_rom.rom_inst 
       (.a(a),
        .spo(spo));
endmodule

(* ORIG_REF_NAME = "rom" *) 
module dist_mem_im_rom
   (spo,
    a);
  output [10:0]spo;
  input [5:0]a;

  wire [5:0]a;
  wire [10:0]spo;

  LUT4 #(
    .INIT(16'h0007)) 
    \spo[0]_INST_0 
       (.I0(a[2]),
        .I1(a[3]),
        .I2(a[4]),
        .I3(a[5]),
        .O(spo[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00030008)) 
    \spo[13]_INST_0 
       (.I0(a[1]),
        .I1(a[2]),
        .I2(a[4]),
        .I3(a[5]),
        .I4(a[3]),
        .O(spo[6]));
  LUT5 #(
    .INIT(32'h00010000)) 
    \spo[15]_INST_0 
       (.I0(a[1]),
        .I1(a[5]),
        .I2(a[4]),
        .I3(a[3]),
        .I4(a[0]),
        .O(spo[7]));
  LUT6 #(
    .INIT(64'h0001010000000000)) 
    \spo[16]_INST_0 
       (.I0(a[3]),
        .I1(a[5]),
        .I2(a[4]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[0]),
        .O(spo[8]));
  LUT6 #(
    .INIT(64'h0000000B00000062)) 
    \spo[20]_INST_0 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[4]),
        .I4(a[5]),
        .I5(a[3]),
        .O(spo[9]));
  LUT6 #(
    .INIT(64'h0000000B000000C8)) 
    \spo[21]_INST_0 
       (.I0(a[1]),
        .I1(a[0]),
        .I2(a[2]),
        .I3(a[4]),
        .I4(a[5]),
        .I5(a[3]),
        .O(spo[10]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000007)) 
    \spo[4]_INST_0 
       (.I0(a[2]),
        .I1(a[1]),
        .I2(a[5]),
        .I3(a[4]),
        .I4(a[3]),
        .O(spo[1]));
  LUT6 #(
    .INIT(64'h00000000000001D5)) 
    \spo[5]_INST_0 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[3]),
        .I4(a[4]),
        .I5(a[5]),
        .O(spo[2]));
  LUT6 #(
    .INIT(64'h0000000000000573)) 
    \spo[7]_INST_0 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[3]),
        .I4(a[4]),
        .I5(a[5]),
        .O(spo[3]));
  LUT6 #(
    .INIT(64'h0000000B0000009C)) 
    \spo[8]_INST_0 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[3]),
        .I3(a[5]),
        .I4(a[4]),
        .I5(a[2]),
        .O(spo[4]));
  LUT6 #(
    .INIT(64'h0000000C00000008)) 
    \spo[9]_INST_0 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[5]),
        .I3(a[4]),
        .I4(a[2]),
        .I5(a[1]),
        .O(spo[5]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
