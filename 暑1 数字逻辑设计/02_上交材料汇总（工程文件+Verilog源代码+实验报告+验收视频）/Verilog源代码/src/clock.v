module clock(
	input CLK_1k,      //时钟信号
	input rst,         //复位按键（低电平有效
    input sw_st_1,     // 设置数位
    input sw_st_2,     // 设置数字
	output [7:0] Digitron_Out,  //数码管显示
	output [3:0] DigCS,    //片选信号
    output beep,       // 蜂鸣器
    output led1,
    output led_out     //附加功能
);

    //时钟分频
	wire CLK_1Hz;
	wire CLK_50Hz;
	clk_div_sub clk_div_sub_inst
(
	.CLK_1k(CLK_1k) ,	// input  CLK_1k_sig
	.CLK_1Hz(CLK_1Hz) ,	// output  CLK_1Hz_sig
	.CLK_50Hz(CLK_50Hz) 	// output  CLK_50Hz_sig
);

    //1Hz时钟上升沿捕获
	wire CLK_1Hz_pulse;
	pulseGet pulseGet_inst_clk
(
	.CLK(CLK_1k) ,	// input  CLK_sig
	.rst_n(1'b1) ,	// input  rst_n_sig
	.sig(CLK_1Hz) ,	// input [N-1:0] sig_sig
	.sig_pulse(CLK_1Hz_pulse) 	// output [N-1:0] sig_pulse_sig
);
	defparam pulseGet_inst_clk.N = 1;
    assign led1=CLK_1Hz;
    //sw_1消抖与上升沿捕获1
	wire sw_st_1_pulse;
	debounce debounce_inst_sw1
(
	.CLK(CLK_1k) ,	// input  CLK_sig
	.CLK_50Hz(CLK_50Hz) ,	// input  CLK_50Hz_sig
	.rst_n(1'b1) ,	// input  rst_n_sig
	.in_sig(sw_st_1) ,	// input [N-1:0] in_sig_sig
	.sig_debounce() ,	// output [N-1:0] sig_debounce_sig
	.sig_pulse(sw_st_1_pulse) 	// output [N-1:0] sig_pulse_sig
);
	defparam debounce_inst_sw1.N = 1;

    //sw_2消抖与上升沿捕获2
	wire sw_st_2_pulse;
	debounce debounce_inst_sw2
(
	.CLK(CLK_1k) ,	// input  CLK_sig
	.CLK_50Hz(CLK_50Hz) ,	// input  CLK_50Hz_sig
	.rst_n(1'b1) ,	// input  rst_n_sig
	.in_sig(sw_st_2) ,	// input [N-1:0] in_sig_sig
	.sig_debounce() ,	// output [N-1:0] sig_debounce_sig
	.sig_pulse(sw_st_2_pulse) 	// output [N-1:0] sig_pulse_sig
);
	defparam debounce_inst_sw2.N = 1; 




    //状态机 
    parameter DISPLAY = 2'b00;       //显示模式
    parameter SET_MIN = 2'b10;       //设置分钟 
    parameter SET_SEC = 2'b11;       //设置秒钟
	
    reg [1:0] state = DISPLAY;   //状态机，用于跟踪数码管的功能状态
	reg [1:0] next_state = DISPLAY;
	//状态转移
	always@(posedge sw_st_1_pulse)begin
		case(state)
            DISPLAY : next_state = SET_MIN;
            SET_MIN : next_state = SET_SEC;
            SET_SEC : next_state = DISPLAY;
        endcase
	end
    
    always@(posedge CLK_1k)
        state <= next_state ;
    assign led_out=(state==DISPLAY&&CLK_1Hz);

    //计数器主体 
	reg [7:0] Sec = 8'd0;
    reg [7:0] Min = 8'd0;

    reg [7:0] Sec1 = 8'd0;
    reg [7:0] Min1= 8'd0;

    always @(posedge CLK_1k) begin
        if(sw_st_2_pulse) begin
            case (state)
                    SET_MIN : begin 
                                Min1 = (Min1 == 59) ? 8'd0 : Min1 + 1;
                    end
                    SET_SEC : begin 
                            Sec1 = (Sec1 == 59) ? 8'd0 : Sec1 + 1;
                    end
            endcase
        end
        else begin if (!rst) begin
            Sec <= 8'd0;
            Min <= 8'd0;
            Min1 <= 8'd0;
            Sec1 <= 8'd0;
        end
        else begin 
            case (state)
                SET_MIN : begin 
                        Min <= Min1;
                end
                SET_SEC : begin 
                        Sec <= Sec1;
                end
                default : begin 
                    if (CLK_1Hz_pulse) begin
                        
                        if (Sec == 59) begin
                            Sec <= 8'd0;
                            if (Min == 59) begin
                                Min <= 8'd0;
                            end else begin
                                Min <= Min + 1;
                            end
                        end else begin
                            Sec <= Sec + 1;
                        end 
                    end 
                    Min1<=Min;
                    Sec1<=Sec;
                end
            endcase
        end
        end
    end
	wire [3:0] Sec_ones;	
	wire [3:0] Sec_tens;	
	wire [3:0] Min_ones;	
	wire [3:0] Min_tens;	


    dec2bcd dut_dec2bcd1
(
	.dec_in(Sec) ,	
	.ones_out(Sec_ones) ,	
	.tens_out(Sec_tens) 
);
    dec2bcd dut_dec2bcd2
(
	.dec_in(Min) ,	
	.ones_out(Min_ones) ,	
	.tens_out(Min_tens) 
);

    //数码管输出
	reg [7:0] Digitron_Out_reg = 8'd0;
	reg [3:0] DigCS_reg = 4'b0111;
	
	wire [7:0]Digitron_Sec_tens;
	wire [7:0]Digitron_Sec_ones;
	wire [7:0]Digitron_Min_tens;
	wire [7:0]Digitron_Min_ones;
	GetDigitron gd1(Sec_tens,Digitron_Sec_tens);
	GetDigitron gd2(Sec_ones,Digitron_Sec_ones);
    GetDigitron gd3(Min_tens,Digitron_Min_tens);
	GetDigitron gd4(Min_ones,Digitron_Min_ones);


	always@(posedge CLK_1k) begin
		DigCS_reg = {DigCS_reg[2], DigCS_reg[1],DigCS_reg[0], DigCS_reg[3]};
		casex({DigCS_reg})
			4'b1011: begin Digitron_Out_reg <= Digitron_Sec_tens; end
			4'b0111: begin Digitron_Out_reg <= Digitron_Sec_ones; end
            4'b1101: begin Digitron_Out_reg <= Digitron_Min_ones; end
            4'b1110: begin Digitron_Out_reg <= Digitron_Min_tens; end
			default: begin Digitron_Out_reg <= 8'd1111_1111; end
		endcase
	end
	
	assign Digitron_Out = Digitron_Out_reg;
	assign DigCS = DigCS_reg;
    assign beep=((Min==59)&&(Sec==59));
endmodule



