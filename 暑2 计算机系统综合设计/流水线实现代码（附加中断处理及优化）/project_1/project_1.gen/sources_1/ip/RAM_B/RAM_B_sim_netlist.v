// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Thu Jul 18 16:52:02 2024
// Host        : Owen running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top RAM_B -prefix
//               RAM_B_ RAM_B_sim_netlist.v
// Design      : RAM_B
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "RAM_B,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module RAM_B
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
  RAM_B_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27264)
`pragma protect data_block
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
rNx7h+gkMFTu2lFHS1af82Oh
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
