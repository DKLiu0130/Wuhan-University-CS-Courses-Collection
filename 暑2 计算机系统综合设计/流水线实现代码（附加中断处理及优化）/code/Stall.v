module Stall(
    input [4:0] IF_ID_rs1,
    input [4:0] IF_ID_rs2,
    input [4:0] ID_EX_rd,
    input [2:0] ID_EX_WDSel,
    output reg is_stall,
    output reg IF_ID_write_enable,
    output reg ID_EX_flush
    );
    
    always @*
    begin
        if((ID_EX_rd!=0 && (IF_ID_rs1==ID_EX_rd || IF_ID_rs2==ID_EX_rd) && ID_EX_WDSel==3'b001))
        begin
            is_stall<=1;
            IF_ID_write_enable<=0;
            ID_EX_flush<=1;
        end
        else
        begin
            is_stall<=0;
            IF_ID_write_enable<=1;
            ID_EX_flush<=0;
        end
    end
    
endmodule
