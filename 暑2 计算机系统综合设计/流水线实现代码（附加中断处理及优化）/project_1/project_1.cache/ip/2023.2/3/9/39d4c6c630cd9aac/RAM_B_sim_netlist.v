// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Thu Jul 18 16:52:02 2024
// Host        : Owen running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ RAM_B_sim_netlist.v
// Design      : RAM_B
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "RAM_B,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire [3:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.96495 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "RAM_B.mem" *) 
  (* C_INIT_FILE_NAME = "RAM_B.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27664)
`pragma protect data_block
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
BHfhEf2gNJfe9iXZFvNBiX670w==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
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
    reg GRESTORE_int;

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
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

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

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
