`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 10:19:58
// Design Name: 
// Module Name: macro
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

//EXT CTRL itype, stype, btype, utype, jtype
`define EXT_CTRL_ITYPE_SHAMT 6'b100000
`define EXT_CTRL_ITYPE	     6'b010000
`define EXT_CTRL_STYPE	     6'b001000
`define EXT_CTRL_BTYPE	     6'b000100
`define EXT_CTRL_UTYPE	     6'b000010
`define EXT_CTRL_JTYPE	     6'b000001

//ALU Operation Code
`define ALUOp_nop   5'b00000
`define ALUOp_add   5'b00011
`define ALUOp_sub   5'b00100
`define ALUOp_lui   5'b00001
`define ALUOp_auipc 5'b00010

//Memory Constant Value Definition
`define DM_word              3'b000
`define DM_halfword           3'b001
`define DM_halfword_unsigned  3'b010
`define DM_byte              3'b011
`define DM_byte_unsigned     3'b100

`define ROM_DISP 4'b1000
`define RF_DISP 4'b0100
`define ALU_DISP 4'b0010
`define DM_DISP 4'b0001

`define ALU_SIZE 5
`define ROM_SIZE 12
`define RF_SIZE 32
`define DM_SIZE 128

`define wdata_from_c 2'b00
`define wdata_from_mem 2'b01
`define wdata_from_j 2'b10

// module macro(

//     );
// endmodule
