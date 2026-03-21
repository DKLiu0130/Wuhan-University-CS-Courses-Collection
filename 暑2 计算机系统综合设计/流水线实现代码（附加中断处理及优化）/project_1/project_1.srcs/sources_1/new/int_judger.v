`define count_cause {1'b1,31'd7}
`define btn_cause {1'b1,31'd11}
module int_judger(
    input clk,
    input rst,
    input INT,
    input [31:0] cause,
    input int_ret,
    input [31:0] NPC,
//    input is_int,
//    input [31:0] curr_cause,
//    input enable_int,
//    input enable_btn,
//    input enable_count,
    output reg INT_judge,
    output [31:0] cause_judge,
    output reg [31:0] int_addr,
    output reg upper_int
    );
    
    reg is_int;
    reg [31:0] curr_cause;
    reg enable_int,enable_btn,enable_count,sub_btn,sub_count,add_count;
    reg [31:0] mpc;
    reg [31:0] btn_time,count_time;
    
    initial
    begin
        is_int=0;
        curr_cause=0;
        btn_time=0;
        count_time=0;
        sub_btn=0;
        sub_count=0;
        add_count=0;
        mpc=0;
    end
    /*
    is_int=0 addr=mpc
    is_int=1 addr=handler_addr
    */
    /*
    always @ (posedge clk)
    begin
        if(INT)
        begin
            INT_judge=1;
            int_addr=32'h000001a0;
            if(!is_int)
            begin
                mpc=NPC;
                is_int=1;
            end
        end
        else if(int_ret)
        begin
            is_int=0;
        end
        else
        begin
            INT_judge=0;
            int_addr=mpc;
//            is_int=0;
//            curr_cause=0;
        end
    end
    */
    /*
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
//            enable_int=1;
//            enable_btn=1;
//            enable_count=1;
            btn_time=0;
            count_time=0;
            sub_btn=0;
            sub_count=0;
            add_count=0;
        end
        else if(INT)
        begin
            if(cause==`btn_cause) btn_time=btn_time+1;
            else if(cause==`count_cause) count_time=count_time+1;
//            if(enable_int && enable_btn && curr_cause==`count_cause && cause==`btn_cause) switch=1;
        end
        else if(sub_btn)
        begin
            sub_btn=0;
            btn_time=btn_time-1;
        end
        else if(sub_count)
        begin
            sub_count=0;
            count_time=count_time-1;
        end
        else if(add_count)
        begin
            add_count=0;
            count_time=count_time+1;
        end
        
        if(rst)
        begin
            is_int=0;
            curr_cause=0;
        end
        else if(int_ret)
        begin
            int_addr=mpc;
            is_int=0;
            curr_cause=0;
        end
        else if(!is_int && (btn_time>0 || count_time>0))
        begin
            INT_judge=1;
            mpc=NPC;
            is_int=1;
            upper_int=0;
            if(btn_time>0)
            begin
                sub_btn=1;
//                btn_time=btn_time-1;
                curr_cause=`btn_cause;
                int_addr=32'h000001a0; // not done
            end
            else if(count_time>0)
            begin
                sub_count=1;
//                count_time=count_time-1;
                curr_cause=`count_cause;
                int_addr=32'h000001a0; // not done  
            end
        end
        else if(is_int && curr_cause==`count_cause && btn_time>0)
        begin
            sub_btn=1;
            add_count=1;
//            btn_time=btn_time-1;
//            count_time=count_time+1;
            INT_judge=1;
            curr_cause=`btn_cause;
            int_addr=32'h000001a0;
            upper_int=1;
        end
        else
        begin
            INT_judge=0;
            int_addr=mpc;
            upper_int=0;
        end
    end
    */
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            btn_time <= 0;
            count_time <= 0;
            sub_btn <= 0;
            sub_count <= 0;
            add_count <= 0;
            is_int <= 0;
            curr_cause <= 0;
        end else begin
            if (INT) begin
                if (cause == `btn_cause) btn_time <= btn_time + 1;
                else if (cause == `count_cause) count_time <= count_time + 1;
            end else if (sub_btn) begin
                sub_btn <= 0;   
                btn_time <= btn_time - 1;
            end else if (sub_count) begin
                sub_count <= 0;
                count_time <= count_time - 1;
            end else if (add_count) begin
                add_count <= 0;
                count_time <= count_time + 1;
            end
    
            if (int_ret) begin
                int_addr <= mpc;
                is_int <= 0;
                curr_cause <= 0;
            end else 
            if (!is_int && (btn_time > 0 || count_time > 0)) begin
                INT_judge <= 1;
                mpc <= NPC;
                is_int <= 1;
                upper_int <= 0;
                if (btn_time > 0) begin
                    sub_btn <= 1;
                    curr_cause <= `btn_cause;
                    int_addr <= 32'h00000160; // not done
                end else if (count_time > 0) begin
                    sub_count <= 1;
                    curr_cause <= `count_cause;
                    int_addr <= 32'h00000184; // not done  
                end
            /*else if(is_int && btn_time > 0) begin
                sub_btn <= 1;
                is_int <= 0;
                curr_cause <= 0;
                int_addr <= mpc;
            end
            */
            end else if (is_int && curr_cause == `count_cause && btn_time > 0) begin
                sub_btn <= 1;
                add_count <= 1;
                INT_judge <= 1;
                curr_cause <= `btn_cause;
                int_addr <= 32'h00000160;
                upper_int <= 1;
            end else begin
                INT_judge <= 0;
                int_addr <= mpc;
                upper_int <= 0;
            end
        end
    end
    
    assign cause_judge=curr_cause;
    
endmodule
