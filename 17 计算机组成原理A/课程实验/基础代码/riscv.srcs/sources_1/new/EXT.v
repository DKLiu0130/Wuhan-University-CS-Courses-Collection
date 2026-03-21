`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 10:19:01
// Design Name: 
// Module Name: EXT
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
`include "macro.v"

module EXT(
    input [4:0]     i_imm_shamt, //
    input [11:0]	iimm,       //instr[31:20], 12 bits
    input [11:0]	simm,       //instr[31:25, 11:7], 12 bits
    input [11:0]	b_imm,       //instrD[31],instrD[7], instrD[30:25], instrD[11:8], 12 bits
    input [19:0]	u_imm,
    input [19:0]	j_imm,
    input [5:0]	    EXTOp,
    output reg signed [31:0] 	immout
  );
  always @(*)
  begin
    case (EXTOp)
      `EXT_CTRL_ITYPE_SHAMT:
        immout = {27'b0,i_imm_shamt[4:0]};
      `EXT_CTRL_ITYPE:
        immout = {{20{ iimm[11]}}, iimm[11:0]};
      `EXT_CTRL_STYPE:
        immout = {{20{ simm[11]}}, simm[11:0]};
      `EXT_CTRL_BTYPE:
        immout = {{19{ b_imm[11]}}, b_imm[11:0], 1'b0};
      `EXT_CTRL_UTYPE:
        immout = {u_imm[19:0], 12'b0};
      `EXT_CTRL_JTYPE:
        immout = {{11{j_imm[19]}}, j_imm[19:0], 1'b0};
      default:
        immout = 32'b0;
    endcase
  end
endmodule