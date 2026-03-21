module gowin_top_entity(
Sys_clk  ,
Beep ,
Key , 
Sw ,
Dig_Seg_Sel  ,
Seg_Blue_Led ,
led1,
led_out
);
///////////////
    //global clock
    input            Sys_clk  ;        // 全局时钟信号
           
    output       Beep ; //蜂鸣器控制信号

    input     Key ;          //按键信号     
    input   [2:1]  Sw ; 
    
//seg_led interface
    output    [3:0]  Dig_Seg_Sel  ;        // 数码管位选信号
    output    [7:0]  Seg_Blue_Led  ;        // 数码管段选信号
///////////////
wire            sys_rst_n ;       // 复位信号
wire Key;
    output led1;
output led_out;

// Key pressed 0 unpress 1 ; Sw On 1 Off 0
//Blue Led  1 light 0 unlight

Digital_Clock digital_clock_inst(
    .CLK_50M(Sys_clk),.rst(Key),.sw_st_1(Sw[1]),.sw_st_2(Sw[2]),
    .DigCS(Dig_Seg_Sel),.Digitron_Out(Seg_Blue_Led),.beep(Beep),.led1(led1),.led_out(led_out));

endmodule
