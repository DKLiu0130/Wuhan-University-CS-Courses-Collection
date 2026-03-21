`include "ctrl_encode_def.v"

module NPC(PC, NPCOp, IMM, NPC,aluout, is_stall, PC_in, int_sig, int_addr);  // next pc module
    
   input  [31:0] PC;        // pc
   input  [2:0]  NPCOp;     // next pc operation
   input  [31:0] IMM;       // immediate
   input [31:0] aluout;
   output reg [31:0] NPC;   // next pc
   input is_stall;
   input [31:0] PC_in;
   input int_sig;
   input [31:0] int_addr;
   
   wire [2:0] NPCOp_in;
   wire [31:0] PCPLUS4;
 
   assign NPCOp_in=int_sig ? `NPC_INTADDR : NPCOp; 
   assign PCPLUS4 = is_stall ? PC : PC + 4; // pc + 4   
   
   always @(*) begin
      case (NPCOp_in)
          `NPC_PLUS4:  NPC = PCPLUS4;
          `NPC_BRANCH: NPC = PC_in+IMM;
          `NPC_JUMP:   NPC = PC_in+IMM;
		  `NPC_JALR:	NPC = aluout;
		  `NPC_INTADDR: NPC = int_addr;
          default:     NPC = PCPLUS4;
      endcase
   end // end always
   
endmodule
