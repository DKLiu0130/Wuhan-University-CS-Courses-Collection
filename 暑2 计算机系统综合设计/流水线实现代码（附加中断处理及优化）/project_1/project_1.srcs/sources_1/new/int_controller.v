`define count_cause {1'b1,31'd7}
`define btn_cause {1'b1,31'd11}
/*
output int signal, btn > counter
*/
module int_controller(
    input clk,
    input rst,
    input [4:0] btn_i,
    input INT_count,
    output reg INT,
    output reg [31:0] cause
    );

    reg [1:0] btn_i_input [4:0], count_input;
    reg edge_st,edge_ed;
    integer i,btn_cnt,btn_last,count_cnt,count_last;
    
    initial
    begin
        btn_cnt=0;
        btn_last=0;
        count_cnt=0;
        count_last=0;
        for(i=0;i<=4;i=i+1)
            btn_i_input[i]<=2'b00;
        count_input<=2'b00;
    end
   
   
    always@(posedge clk)
    begin
        if(rst)
        begin
            btn_cnt=0;
            btn_last=0;
            count_cnt=0;
            count_last=0;
            for(i=0;i<=4;i=i+1)
                btn_i_input[i]<=2'b00;
            count_input<=2'b00;
        end
        else
        begin
            for(i=0;i<=4;i=i+1)
                btn_i_input[i]<={btn_i_input[i][0],btn_i[i]};
            count_input<={count_input[0],INT_count};
        end
        
        btn_last=btn_cnt;
        for(i=0;i<=2;i=i+1)
        begin
            edge_st=btn_i_input[i][0] & !btn_i_input[i][1];
            edge_ed=!btn_i_input[i][0] & btn_i_input[i][1];
            if(edge_st) btn_cnt=btn_cnt+1;
            if(edge_ed) btn_cnt=btn_cnt-1;
        end
        count_last=count_cnt;
        for(i=3;i<=4;i=i+1)
        begin
            edge_st=btn_i_input[i][0] & !btn_i_input[i][1];
            edge_ed=!btn_i_input[i][0] & btn_i_input[i][1];
            if(edge_st) count_cnt=count_cnt+1;
            if(edge_ed) count_cnt=count_cnt-1;
        end
        
        
        if(btn_last==0 && btn_cnt>0)
        begin
            INT=1;
            cause=`btn_cause;
        end
        else if(count_last==0 && count_cnt>0)
        begin
            INT=1;
            cause=`count_cause;
        end
        else
        begin
            INT=0;
            cause=0;
        end
    end

endmodule
