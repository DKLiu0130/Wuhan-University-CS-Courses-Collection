//数码管译码模块
module GetDigitron(
	input [3:0] bin,
	output reg [7:0] seg
);
	always @(*) begin
		case(bin)
			4'd0 : seg <= 8'b0011_1111;     
            4'd1 : seg <= 8'b0000_0110; 
            4'd2 : seg <= 8'b0101_1011;  
            4'd3 : seg <= 8'b0100_1111;  
            4'd4 : seg <= 8'b0110_0110;     
            4'd5 : seg <= 8'b0110_1101;    
            4'd6 : seg <= 8'b0111_1101;     
            4'd7 : seg <= 8'b0000_0111;     
            4'd8 : seg <= 8'b0111_1111;     
            4'd9 : seg <= 8'b0110_1111;     
            4'd10: seg <= 8'b0000_0000;           //不显示任何字符
            4'd11: seg <= 8'b0100_0000;           //显示负号(-)
            default: 
                   seg <= 8'b0000_0000;	    //{7'b1000000,dot_disp};
        endcase
	end
endmodule
