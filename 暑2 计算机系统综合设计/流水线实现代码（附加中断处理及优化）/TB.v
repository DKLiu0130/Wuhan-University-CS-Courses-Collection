module FGPA_single_CPU_tb();
    reg clk, rstn;
    reg [4:0]btn_i;
    reg [15:0]sw_i;
    wire[31:0] pc;

    wire [7:0]disp_an_o, disp_seg_o;
    wire [15:0]led_o;
   
    top xgriscv(
        .rstn (rstn),
        .btn_i (btn_i),
        .sw_i (sw_i),
        .clk (clk),

        .disp_an_o (disp_an_o),
        .disp_seg_o (disp_seg_o),
        .led_o (led_o)
    );

    integer counter = 0;
   
    initial begin
        // input instruction for simulation
        // $readmemh("test_SINGLE.hex", xgriscv.U_imem.RAM);
        clk = 1;
        rstn = 1;
        sw_i = 0;
        btn_i = 0;
        #5 ;
        rstn = 0;
        #150 ;
        rstn = 1;
        #16000 ;
        btn_i = 5'b00001;
    end
   
    always begin
        #(50) clk = ~clk;

        if (clk == 1'b1) 
        begin
            counter = counter + 1;
            /*if (pc == 32'h8000078) begin 
                $stop;
            end*/
        end
      
    end
endmodule

