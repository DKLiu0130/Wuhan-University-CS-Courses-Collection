`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 20:58:18
// Design Name: 
// Module Name: pc
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


module pc(
        input clk,
        input rstn,
        input [31:0] npc,
        output reg [31:0] pc
);
    always @(posedge clk or negedge rstn) begin
        if(~rstn)
            pc <= 0;
        else
            pc <= npc;
   end
endmodule
