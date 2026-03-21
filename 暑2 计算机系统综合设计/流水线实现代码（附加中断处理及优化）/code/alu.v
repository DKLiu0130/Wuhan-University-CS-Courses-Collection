`include "ctrl_encode_def.v"

module alu(A, B, ALUOp, C, Zero,PC);
           
   input  signed [31:0] A, B;
   input         [4:0]  ALUOp;
	input [31:0] PC;
   output signed [31:0] C;
   output Zero;
   
   reg [31:0] C;
   integer    i;
       
   always @( * ) begin
      case ( ALUOp )
`ALUOp_nop:C=A;
`ALUOp_lui:C=B;
`ALUOp_auipc:C=PC+B;
`ALUOp_add:C=A+B;
`ALUOp_sub:C=A-B;
`ALUOp_bne:C={31'b0,(A==B)};
`ALUOp_blt:C={31'b0,(A>=B)};
`ALUOp_bge:C={31'b0,(A<B)};
`ALUOp_bltu:C={31'b0,($unsigned(A)>=$unsigned(B))};
`ALUOp_bgeu:C={31'b0,($unsigned(A)<$unsigned(B))};
`ALUOp_slt:C={31'b0,(A<B)};
`ALUOp_sltu:C={31'b0,($unsigned(A)<$unsigned(B))};
`ALUOp_xor:C=A^B;
`ALUOp_or:C=A|B;
`ALUOp_and:C=A&B;
`ALUOp_sll:C=A<<B;
`ALUOp_srl:C=A>>B;
`ALUOp_sra:C=A>>>B;
      endcase
   end // end always
   
   assign Zero = (C == 32'b0);

endmodule
    
