module GRE_array(
    input clk,
    input rst,
    input write_enable,
    input flush,
    input save_out,
    input upper_int,
    input load_out,
    input [255:0] in,
    output reg [255:0] out
    );
    
    reg [255:0] out_int;
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            out=0;
        end
        else
        begin
            if(write_enable)
            begin
                if(save_out)
                begin
                    if(!upper_int) out_int<=out;
                    out<=0;
                end
                else if(flush)
                    out<=0;
                else if(load_out)
                    out<=out_int;
                else
                    out<=in;
            end
        end 
    end
    
endmodule