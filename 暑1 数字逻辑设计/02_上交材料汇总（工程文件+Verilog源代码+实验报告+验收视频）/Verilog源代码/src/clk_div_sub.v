module clk_div_sub(
	input CLK_1k,
	output CLK_1Hz,
	output CLK_50Hz
);

//--------------------1Hz信号产生--------------------------
	reg clk_1hz_reg = 1'b0;
	reg [9:0] cnt_1hz = 10'd0;
	always@(posedge CLK_1k) begin
		cnt_1hz <= (cnt_1hz < 10'd999)? cnt_1hz+1'b1 : 10'd0;
		clk_1hz_reg <= (cnt_1hz < 10'd499)? 1'b0 : 1'b1;
	end
	assign CLK_1Hz = clk_1hz_reg;
	
//--------------------50Hz信号产生-----------------------
	reg clk_50hz_reg = 1'b0;
	reg [4:0] cnt_50hz =5'd0;
	always@(posedge CLK_1k) begin
		cnt_50hz <= (cnt_50hz < 5'd19)? cnt_50hz+1'b1 : 5'd0;
		clk_50hz_reg <= (cnt_50hz < 5'd9)? 1'b0 : 1'b1;
	end
	assign CLK_50Hz = clk_50hz_reg;

endmodule
