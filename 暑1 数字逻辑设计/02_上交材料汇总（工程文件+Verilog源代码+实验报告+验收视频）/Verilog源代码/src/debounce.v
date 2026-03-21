module debounce
#(parameter N=1)
(
	input CLK,
	input CLK_50Hz,
	input rst_n,
	input [N-1:0] in_sig,
	output [N-1:0] sig_debounce,	//消抖后信号输出
	output [N-1:0] sig_pulse		//边沿捕获信号
);
	reg[N-1:0] sig_reg; 
	always@(posedge CLK_50Hz or negedge rst_n) begin
		if(~rst_n) begin
			sig_reg <= {N{1'b0}};
		end
		else begin
			sig_reg <= ~in_sig;
		end
	end
	
	assign sig_debounce = sig_reg;
	
	pulseGet #(.N(N)) pulseGet_debounce_key_inst(
		.CLK(CLK),
		.rst_n(rst_n),
		.sig(sig_reg),
		.sig_pulse(sig_pulse)
	);

endmodule