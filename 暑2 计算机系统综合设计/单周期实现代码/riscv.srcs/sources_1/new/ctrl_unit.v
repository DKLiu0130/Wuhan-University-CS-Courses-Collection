`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 21:00:03
// Design Name: 
// Module Name: ctrl_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ctrl_unit(
    input [6:0] Op,             //opcode
    input [6:0] Funct7,         //funct7
    input [2:0] Funct3,         // funct3
    input Zero,
    output RegWrite,            // control signal for register write
    output MemWrite,            // control signal for memory write
    output	[5:0]EXTOp,         // control signal to signed extension
    output [4:0] ALUOp,         // ALU opertion
    output ALUSrc,              // ALU source for b
    output [2:0] DMType,        //dm r/w type
    output pc_src,
    output b_j_addr_sel,
    output [1:0] wdata_sel
  );

  //R_type
  wire rtype  = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
  wire i_add=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
  wire i_sub=rtype&~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000

  //i_l type
  wire itype_l  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011
  wire i_lb=itype_l&~Funct3[2]& ~Funct3[1]& ~Funct3[0]; //lb 000
  wire i_lh=itype_l&~Funct3[2]& ~Funct3[1]& Funct3[0];  //lh 001
  wire i_lw=itype_l&~Funct3[2]& Funct3[1]& ~Funct3[0];  //lw 010

  // i_i type
  wire itype_r  = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0010011
  wire i_addi  =  itype_r& ~Funct3[2]& ~Funct3[1]& ~Funct3[0]; // addi 000 func3

  // s format
  wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
  wire i_sw   = ~Funct3[2]&Funct3[1]&~Funct3[0];// sw 010
  wire i_sb=stype& ~Funct3[2]& ~Funct3[1]&~Funct3[0];
  wire i_sh=stype&& ~Funct3[2]&~Funct3[1]&Funct3[0];

  // b format
  wire btype  = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; // 1100011
  assign branch = btype & (Funct3 == 3'b000);

  //j type ALUOp_jal   5'b10010
  wire i_jal=Op[6]&Op[5]&~Op[4]&Op[3]&Op[2]&Op[1]&Op[0];//1101111
  wire i_jalr =  Op[6] & Op[5] & ~Op[4] & ~Op[3] & Op[2] & Op[1] & Op[0];// 110 0111

  //操作指令生成控制信号（写、MUX选择）
  assign RegWrite   = rtype | itype_r| itype_l  |i_jal | i_jalr; // register write
  assign MemWrite   = stype;              // memory write
  assign ALUSrc     = itype_r | stype | itype_l ; // ALU B is from instruction immediate
  assign pc_src = (i_jal | i_jalr | (branch & Zero));
  
  assign b_j_addr_sel = pc_src & ~i_jalr; // b_j_addr_sel = 1, jal or branch; else jalr;


  assign wdata_sel[0] = itype_l;
  assign wdata_sel[1] = i_jalr | i_jal; // 2'b10

  //操作指令生成运算类型aluop
  //ALUOp_nop 5'b00000
  //ALUOp_add 5'b00011
  //ALUOp_sub 5'b00100
  assign ALUOp[0]= i_add|i_addi|stype|itype_l|i_jal| i_jalr ;
  assign ALUOp[1]= i_add|i_addi|stype|itype_l|i_jal | i_jalr ;
  assign ALUOp[2]= i_sub | btype; // beq only

  //操作指令生成常数扩展操作
  assign EXTOp[0] =  i_jal;
  assign EXTOp[2] = btype;
  assign EXTOp[3] =  stype;
  assign EXTOp[4] =  itype_l | itype_r | i_jalr;

  //根据具体S和i_L指令生成DataMem数据操作类型编码
  // DM_word 3'b000
  //DM_halfword 3'b001
  //DM_halfword_unsigned 3'b010
  //DM_byte 3'b011
  //DM_byte_unsigned 3'b100
  assign DMType[2] = 0;
  assign DMType[1]=i_lb | i_sb; //| i_lhu;
  assign DMType[0]=i_lh | i_sh | i_lb | i_sb;
endmodule