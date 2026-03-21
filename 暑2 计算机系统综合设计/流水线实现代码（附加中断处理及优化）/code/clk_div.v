`timescale 1ns / 1ps
module clk_div(input clk,
					input rst,
					input SW2,
					output reg[31:0]clkdiv,
					output Clk_CPU,
					output INT_count
					);
					
// Clock divider-ʱ�ӷ�Ƶ��


	always @ (posedge clk or posedge rst) begin 
		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; end
		
	assign Clk_CPU=(SW2)? clkdiv[25] : clkdiv[6];
//	assign INT_count=clkdiv[28];
	assign INT_count=0;
	
endmodule
