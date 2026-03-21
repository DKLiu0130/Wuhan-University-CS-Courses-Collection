`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 21:00:27
// Design Name: 
// Module Name: data_memory
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


module data_memory (
    input clk,
    input DMWr,
    input rstn,
    input[6:0] addr,
    input[31:0] din,
    input[2:0] DMType,
    output reg [31:0] dout
  );
  reg [7:0] dmem [127:0];
  integer j = 0;
  initial
  begin
    for(j = 0; j < 128; j = j + 1)
    begin
      dmem[j] = j;
    end
  end
  always @(posedge clk, negedge rstn)
  begin
    if(!rstn)
    begin
      for(j = 0; j < 128; j = j + 1)
      begin
        dmem[j] = j;
      end
    end
    else if (DMWr)
    begin
      case (DMType)
        `DM_byte:
          dmem[addr] <= din[7:0];
        `DM_byte_unsigned:
          dmem[addr] <= din[7:0];
        `DM_halfword:
        begin
          dmem[addr] <= din[7:0];
          dmem[addr+1] <= din[15:8];
        end
        `DM_halfword_unsigned:
        begin
          dmem[addr] <= din[7:0];
          dmem[addr+1] <= din[15:8];
        end
        `DM_word:
        begin
          dmem[addr] <= din[7:0];
          dmem[addr+1] <= din[15:8];
          dmem[addr+2] <= din[23:16];
          dmem[addr+3] <= din[31:24];
        end
      endcase
    end
  end

  /* 下降沿读 */
  always @(*)
  begin
    case (DMType)
      `DM_byte: begin
        dout = {{24{dmem[addr][7]}}, dmem[addr][7:0]};
      end
      `DM_byte_unsigned: begin
        dout = {24'b0, dmem[addr][7:0]};
      end
      `DM_halfword: begin
        dout = {{16{dmem[addr+1][7]}}, dmem[addr+1][7:0], dmem[addr][7:0]};
      end
      `DM_halfword_unsigned: begin
        dout = {16'b0, dmem[addr+1][7:0], dmem[addr][7:0]};
      end
      `DM_word: begin
        dout = {dmem[addr+3][7:0], dmem[addr+2][7:0], dmem[addr+1][7:0], dmem[addr][7:0]};
      end
      default: begin
        dout = 32'b0;
      end
    endcase
  end
endmodule