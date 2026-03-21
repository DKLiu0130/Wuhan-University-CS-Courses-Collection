module clk_div(
	input CLK_50M,
	output CLK_1kHz
);
	reg CLK_1kHz_reg = 1'b0;
	reg [15:0] cnt_1k = 16'd0;
	always@(posedge CLK_50M) begin
		cnt_1k <= (cnt_1k < 16'd49_999)? cnt_1k+1'b1 : 16'd0;
		CLK_1kHz_reg <= (cnt_1k < 16'd24_999)? 1'b0 : 1'b1;
	end
	assign CLK_1kHz = CLK_1kHz_reg;

endmodule