`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 10:04:33
// Design Name: 
// Module Name: register_file
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


module register_file(
        input clk,
        input rstn,
        input [4:0] rs1,
        input [4:0] rs2,
        input [4:0] rd,
        input reg_write,
        input [31:0] wdata,
        output reg [31:0] rs1_data,
        output reg [31:0] rs2_data
    );

    reg[31:0] register_file[31:0];

    integer i;
    always @(posedge clk, negedge rstn) begin
       if(!rstn) begin
        for(i=0;i<32;i=i + 1) begin
            register_file[i] <= i;
        end
       end
       else if(reg_write && rd != 0) begin
        register_file[rd] <= wdata;
       end 
    end

    always @(negedge clk) begin
       rs1_data <= register_file[rs1];
       rs2_data <= register_file[rs2]; 
    end

endmodule
