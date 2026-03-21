module Digital_Clock(
	input CLK_50M,     //时钟信号
	input rst,         //复位按键（低电平有效
    input sw_disp,     // 显示切换
    input sw_st_1,     // 设置数位
    input sw_st_2,     // 设置数字
    input sw_st_3,     // 设置闹钟
    input alm_on,      // 闹钟是否开启
	output [7:0] Digitron_Out,  //数码管显示
	output [3:0] DigCS,    //片选信号
    output beep,       // 蜂鸣器
    output led1,
    output led_out
);
	//时钟分频，使用50M系统时钟产生1kHz时钟
	wire CLK_1k;
	clk_div clk_div_inst
(
	.CLK_50M(CLK_50M) ,	// input  CLK_50M_sig
	.CLK_1kHz(CLK_1k) 	// output  CLK_1kHz_sig
);

	clock clock_inst
(
	.CLK_1k(CLK_1k) ,	// input  CLK_1k_sig
	.rst(rst) ,	// input  rst_sig
	.Digitron_Out(Digitron_Out) ,	// output [6:0] Digitron_Out_sig
	.DigCS(DigCS), 	// output [1:0] DigCS_sig
    .sw_st_1(sw_st_1),
    .sw_st_2(sw_st_2),
    .beep(beep),
    .led1(led1),
    .led_out(led_out)
);



endmodule