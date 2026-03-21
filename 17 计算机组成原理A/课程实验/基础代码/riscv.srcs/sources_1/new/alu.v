`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 20:59:44
// Design Name: 
// Module Name: alu
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

module alu(
        input signed [31:0] A,
        input signed [31:0] B,
        input [4:0] ALUop,
        output signed [31:0] C,
        output zero
);
    reg signed [31:0] reg_c;
    always @(*) begin
       case(ALUop)
        `ALUOp_add: reg_c = A + B;
        `ALUOp_sub: reg_c = A - B;
        default: reg_c = 0;
       endcase
    end

    assign C = reg_c;
    assign zero = (C == 0);

endmodule
