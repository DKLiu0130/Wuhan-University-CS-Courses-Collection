module pulseGet
#(parameter N=1)
(
	input CLK,
	input rst_n,
	input [N-1:0] sig,
	output [N-1:0]sig_pulse
);
	
	reg[N-1:0] sig_reg0 = {N{1'b0}};
	reg[N-1:0] sig_reg1 = {N{1'b0}};
	
	always@(posedge CLK or negedge rst_n) begin
		if(~rst_n) begin
			sig_reg0 <= {N{1'b0}};
			sig_reg1 <= {N{1'b0}};
		end
		else begin
			sig_reg0 <= sig;
			sig_reg1 <= sig_reg0;
		end
	end
	
	assign sig_pulse = (~sig_reg1) & (sig_reg0);

endmodule