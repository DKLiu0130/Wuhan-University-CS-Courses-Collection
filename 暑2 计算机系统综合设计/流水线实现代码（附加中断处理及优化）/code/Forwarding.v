module Forwarding(
    input EX_MEM_RegWrite,
    input [4:0] EX_MEM_rd,
    input MEM_WB_RegWrite,
    input [4:0] MEM_WB_rd,
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    output reg [1:0] ID_EX_forwardA,
    output reg [1:0] ID_EX_forwardB
    );
    
    always @*
    begin
        if(EX_MEM_RegWrite && EX_MEM_rd == ID_EX_rs1 && EX_MEM_rd!=0)
            ID_EX_forwardA = 2'b10;
        else if(MEM_WB_RegWrite && MEM_WB_rd == ID_EX_rs1 && MEM_WB_rd!=0)
            ID_EX_forwardA = 2'b01;
        else
            ID_EX_forwardA = 2'b00;
    end
    
    always @*
    begin
        if(EX_MEM_RegWrite && EX_MEM_rd == ID_EX_rs2 && EX_MEM_rd!=0)
            ID_EX_forwardB = 2'b10;
        else if(MEM_WB_RegWrite && MEM_WB_rd == ID_EX_rs2 && MEM_WB_rd!=0)
            ID_EX_forwardB = 2'b01;
        else
            ID_EX_forwardB = 2'b00;
    end
    
endmodule
