`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/09 12:38:39
// Design Name: 
// Module Name: disp_seg16x
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


module disp_seg16x(
    input clk,
    input rstn,
    input [31:0] disp_data,
    output[7:0] an_o,
    output[7:0] seg_o
);

    wire[3:0] digits[7:0];

    genvar i;
    for(i=0;i<8;i=i+1) begin
       assign digits[i] = disp_data[4*i+3:4*i]; // 4*i
    end

    reg [2:0] selector;
    always @(posedge clk) begin
       selector <= selector + 1; 
    end

    reg[7:0] reg_an_o, reg_seg_o;
    always @(*) begin
      reg_an_o = ~(8'b1 << selector); // 8'b1 !
    end

    always @(*) begin
      reg_seg_o = seven_seg_translator(digits[selector]);
    end

    assign an_o = reg_an_o;
    assign seg_o = reg_seg_o;




    function [7:0] seven_seg_translator;
        input[3:0] num;
        case(num)
            4'b0000: seven_seg_translator = 8'hC0;
            4'b0001: seven_seg_translator = 8'hF9;
            4'b0010: seven_seg_translator = 8'hA4;
            4'b0011: seven_seg_translator = 8'hB0;
            4'b0100: seven_seg_translator = 8'h99;
            4'b0101: seven_seg_translator = 8'h92;
            4'b0110: seven_seg_translator = 8'h82;
            4'b0111: seven_seg_translator = 8'hF8;
            4'b1000: seven_seg_translator = 8'h80;
            4'b1001: seven_seg_translator = 8'h90;
            4'b1010: seven_seg_translator = 8'h88;
            4'b1011: seven_seg_translator = 8'h83;
            4'b1100: seven_seg_translator = 8'hC6;
            4'b1101: seven_seg_translator = 8'hA1;
            4'b1110: seven_seg_translator = 8'h86;
            4'b1111: seven_seg_translator = 8'h8E;
            default: seven_seg_translator = 8'hFF;
        endcase
    endfunction


endmodule
