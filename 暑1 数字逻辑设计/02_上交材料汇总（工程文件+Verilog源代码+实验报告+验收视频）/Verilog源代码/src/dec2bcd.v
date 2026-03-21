module dec2bcd(
	input  [7:0] dec_in,
	output [3:0] ones_out,
	output [3:0] tens_out
);
	
	reg [3:0] ones;	//个位
	reg [3:0] tens;	//十位
	integer i;
	 
	always @(*) begin
		ones 		= 4'd0;
		tens 		= 4'd0;
		
		for(i = 7; i >= 0; i = i - 1) begin
			if (ones >= 4'd5) 		ones = ones + 4'd3;
			if (tens >= 4'd5) 		tens = tens + 4'd3;
			tens	 = {tens[2:0],ones[3]};
			ones	 = {ones[2:0],dec_in[i]};
		end
	end	
	
	assign ones_out = ones;
	assign tens_out = tens;
	
endmodule