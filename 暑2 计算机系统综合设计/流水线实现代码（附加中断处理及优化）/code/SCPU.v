`include "ctrl_encode_def.v"
module SCPU(
    input      clk,            // clock
    input      reset,          // reset
    input MIO_ready,
    input INT,
    input [31:0]  cause,
    input [31:0]  inst_in,     // instruction
    input [31:0]  Data_in,     // data from data memory
   
    output mem_w,          // output: memory write signal
    output [31:0] PC_out,     // PC address
      // memory write
    output [31:0] Addr_out,   // ALU output
    output [31:0] Data_out,// data to data memory
    output [2:0] dm_ctrl,
    output CPU_MIO,
    output [31:0]r0
//    input  [4:0] reg_sel,    // register selection (for debug use)
//    output [31:0] reg_data  // selected register data (for debug use)
//output [2:0] DMType
);
    wire        RegWrite;    // control signal to register write ID_EX
    wire        Memread;
    wire        Memwrite;
    wire [2:0]  dm_c;
    wire [5:0]  EXTOp;       // control signal to signed extension IF_ID
    wire [4:0]  ALUOp;       // ALU opertion ID_EX
    wire [2:0]  NPCOp;       // next PC operation ID_EX

    wire [2:0]  WDSel;       // (register) write data selection ID_EX
    wire [1:0]  GPRSel;      // general purpose register selection ID_EX
   
    wire        ALUSrc;      // ALU source for A ID_EX
    wire        Zero;        // ALU ouput zero

    wire [31:0] NPC;         // next PC

    wire [4:0]  rs1;          // rs ID_EX
    wire [4:0]  rs2;          // rt ID_EX
    wire [4:0]  rd;          // rd ID_EX
    wire [6:0]  Op;          // opcode IF_ID
    wire [6:0]  Funct7;       // funct7 IF_ID
    wire [2:0]  Funct3;       // funct3 IF_ID
//    wire [11:0] Imm12;       // 12-bit immediate
//    wire [31:0] Imm32;       // 32-bit immediate
//    wire [19:0] IMM;         // 20-bit immediate (address)
    // wire [4:0]  A3;          // register address for write
    reg [31:0] WD;          // register write data
    wire [31:0] RD1,RD2;         // register data specified by rs
    reg [31:0] A;
	reg [31:0] B_in;
	wire [31:0] B;           // operator for ALU B
	
	wire [4:0] iimm_shamt; // IF_ID
	wire [11:0] iimm,simm,bimm; // IF_ID
	wire [19:0] uimm,jimm; // IF_ID
	wire [31:0] immout; // 
    wire [31:0] aluout;
    
    wire IF_ID_write_enable;
    wire IF_ID_flush;
    wire [255:0] IF_ID_in;
    wire [255:0] IF_ID_out; // IF_ID
    wire ID_EX_write_enable;
    wire ID_EX_flush;
    wire [255:0] ID_EX_in;
    wire [255:0] ID_EX_out; // ID_EX
    wire EX_MEM_write_enable;
    wire EX_MEM_flush;
    wire [255:0] EX_MEM_in;
    wire [255:0] EX_MEM_out; // EX_MEM
    wire MEM_WB_write_enable;
    wire MEM_WB_flush;
    wire [255:0] MEM_WB_in;
    wire [255:0] MEM_WB_out; // MEM_WB
    
    wire IF_ID_flush_detect;
    wire ID_EX_flush_detect;
    wire EX_MEM_flush_detect;
    wire IF_ID_write_enable_stall;
    wire ID_EX_flush_stall;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;
    wire is_stall;
    wire [2:0] NPCOp_in;
    
    wire [31:0] IF_ID_PC_out;
    wire [4:0]  IF_ID_rs1;
    wire [4:0]  IF_ID_rs2;
    wire [4:0]  IF_ID_rd;
    wire [4:0] IF_ID_iimm_shamt;
    wire [11:0] IF_ID_iimm;
    wire [11:0] IF_ID_simm;
    wire [11:0] IF_ID_bimm;
    wire [19:0] IF_ID_uimm;
    wire [19:0] IF_ID_jimm;
    wire [6:0] IF_ID_Op;
    wire [6:0] IF_ID_Funct7;
    wire [2:0] IF_ID_Funct3;
    
    wire [4:0] ID_EX_rd;
    wire [4:0] ID_EX_rs1;
    wire [4:0] ID_EX_rs2;
    wire ID_EX_RegWrite;
	wire ID_EX_Memread;
	wire ID_EX_Memwrite;
	wire [5:0] ID_EX_EXTOp;
    wire [4:0] ID_EX_ALUOp;
    wire [2:0] ID_EX_NPCOp;
    wire ID_EX_ALUSrc; 
    wire [2:0]  ID_EX_WDSel;
    wire [2:0] ID_EX_dm_c;
    wire [31:0] ID_EX_immout;
    wire [31:0] ID_EX_RD1;
    wire [31:0] ID_EX_RD2;
    wire [31:0] ID_EX_PC_out;
    
    wire EX_MEM_Zero;
    wire [31:0] EX_MEM_aluout;
    wire [31:0] EX_MEM_PC_out;
    wire [2:0] EX_MEM_WDSel;
    wire EX_MEM_RegWrite;
    wire EX_MEM_Memread;
    wire EX_MEM_Memwrite;
    wire [2:0] EX_MEM_NPCOp;
    wire [2:0] EX_MEM_dm_c;
    wire [4:0] EX_MEM_rd;
    wire [31:0] EX_MEM_RD2;
    
    wire [31:0] MEM_WB_Data_in;
    wire MEM_WB_RegWrite;
    wire [4:0] MEM_WB_rd;
    wire [2:0] MEM_WB_WDSel;
    wire [31:0] MEM_WB_aluout;
    wire [31:0] MEM_WB_PC_out;
    
    // pipeline register
    
     /*
    every interrupt
    mtvec: start address of interrupt handler
    mpc: return address of interrupt
    
    overall
    
    */
    
    wire int_ret;
    wire IF_ID_int_ret;
    wire ID_EX_int_ret;
    wire EX_MEM_int_ret;
    wire MEM_WB_int_ret;
    
    wire is_int;
    wire [31:0] curr_cause;
    wire enable_int;
    wire enable_btn;
    wire enable_count;
    wire INT_judge;
    wire [31:0] cause_judge;
    wire [31:0] int_addr;
    wire int_sig;
    wire upper_int;
    
    // not done yet
    
    assign int_ret=(inst_in==32'h30200073);
    assign int_sig=EX_MEM_int_ret | INT_judge;

	assign iimm_shamt=inst_in[24:20];
	assign iimm=inst_in[31:20];
	assign simm={inst_in[31:25],inst_in[11:7]};
	assign bimm={inst_in[31],inst_in[7],inst_in[30:25],inst_in[11:8]};
	assign uimm=inst_in[31:12];
	assign jimm={inst_in[31],inst_in[19:12],inst_in[20],inst_in[30:21]}; 
   
    assign Op = inst_in[6:0];  // instruction
    assign Funct7 = inst_in[31:25]; // funct7
    assign Funct3 = inst_in[14:12]; // funct3
    assign rs1 = inst_in[19:15];  // rs1
    assign rs2 = inst_in[24:20];  // rs2
    assign rd = inst_in[11:7];  // rd
    // assign Imm12 = inst_in[31:20];// 12-bit immediate
    // assign IMM = inst_in[31:12];  // 20-bit immediate
    
    int_judger U_int_judger(
        .clk(clk),
        .rst(reset),
        .INT(INT),
        .cause(cause),
        .NPC(NPC),
        .int_ret(EX_MEM_int_ret),
        .INT_judge(INT_judge),
        .cause_judge(cause_judge),
        .int_addr(int_addr),
        .upper_int(upper_int)
    );
    
    GRE_array IF_ID_GRE_array(
        .clk(clk),
        .rst(reset),
        .write_enable(IF_ID_write_enable),
        .flush(IF_ID_flush),
        .save_out(INT_judge),
        .upper_int(upper_int),
        .load_out(EX_MEM_int_ret),
        .in(IF_ID_in),
        .out(IF_ID_out)
    );
    
    GRE_array ID_EX_GRE_array(
        .clk(clk),
        .rst(reset),
        .write_enable(ID_EX_write_enable),
        .flush(ID_EX_flush),
        .save_out(INT_judge),
        .upper_int(upper_int),
        .load_out(EX_MEM_int_ret),
        .in(ID_EX_in),
        .out(ID_EX_out)
    );
    
    GRE_array EX_MEM_GRE_array(
        .clk(clk),
        .rst(reset),
        .write_enable(EX_MEM_write_enable),
        .flush(EX_MEM_flush),
        .save_out(INT_judge),
        .upper_int(upper_int),
        .load_out(EX_MEM_int_ret),
        .in(EX_MEM_in),
        .out(EX_MEM_out)
    );
    
    GRE_array MEM_WB_GRE_array(
        .clk(clk),
        .rst(reset),
        .write_enable(MEM_WB_write_enable),
        .flush(MEM_WB_flush),
        .save_out(INT_judge),
        .upper_int(upper_int),
        .load_out(EX_MEM_int_ret),
        .in(MEM_WB_in),
        .out(MEM_WB_out)
    );
    
    Detect U_Detect(
        .NPCOp_in(ID_EX_NPCOp),
        .Zero(Zero),
        .NPCOp_out(NPCOp_in),
        .IF_ID_flush(IF_ID_flush_detect),
        .ID_EX_flush(ID_EX_flush_detect)
//        .EX_MEM_flush(EX_MEM_flush_detect)
    );
    
    Stall U_Stall(
        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),
        .ID_EX_rd(ID_EX_rd),
        .ID_EX_WDSel(ID_EX_WDSel),
        .is_stall(is_stall),
        .IF_ID_write_enable(IF_ID_write_enable_stall),
        .ID_EX_flush(ID_EX_flush_stall)
    );
    
    Forwarding U_Forwarding(
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_rd(MEM_WB_rd),
        .ID_EX_rs1(ID_EX_rs1),
        .ID_EX_rs2(ID_EX_rs2),
        .ID_EX_forwardA(ForwardA),
        .ID_EX_forwardB(ForwardB)
    );
    
    assign IF_ID_flush=IF_ID_flush_detect;
    assign ID_EX_flush=ID_EX_flush_detect | ID_EX_flush_stall;
    assign EX_MEM_flush=0;
    assign MEM_WB_flush=0;
    assign IF_ID_write_enable=IF_ID_flush_detect | IF_ID_write_enable_stall;
    assign ID_EX_write_enable=1;
    assign EX_MEM_write_enable=1;
    assign MEM_WB_write_enable=1;
   
    // instantiation of pc unit
    PC U_PC(.clk(clk), .rst(reset), .NPC(NPC), .PC(PC_out) );
    NPC U_NPC(.PC(PC_out), .NPCOp(NPCOp_in), .IMM(ID_EX_immout), .NPC(NPC), .aluout(aluout), .is_stall(is_stall), .PC_in(ID_EX_PC_out), .int_sig(int_sig), .int_addr(int_addr));
    
    assign IF_ID_in={int_ret,PC_out,rs1,rs2,rd,iimm_shamt,iimm,simm,bimm,uimm,jimm,Op,Funct7,Funct3};
    
    assign IF_ID_int_ret=IF_ID_out[145:145];
    assign IF_ID_PC_out=IF_ID_out[144:113];
    assign IF_ID_rs1=IF_ID_out[112:108];
    assign IF_ID_rs2=IF_ID_out[107:103];
    assign IF_ID_rd=IF_ID_out[102:98];
    assign IF_ID_iimm_shamt=IF_ID_out[97:93];
    assign IF_ID_iimm=IF_ID_out[92:81];
    assign IF_ID_simm=IF_ID_out[80:69];
    assign IF_ID_bimm=IF_ID_out[68:57];
    assign IF_ID_uimm=IF_ID_out[56:37];
    assign IF_ID_jimm=IF_ID_out[36:17];
    assign IF_ID_Op=IF_ID_out[16:10]; 
    assign IF_ID_Funct7=IF_ID_out[9:3];
    assign IF_ID_Funct3=IF_ID_out[2:0];
   
    // instantiation of control unit
	ctrl U_ctrl(
		.Op(IF_ID_Op), .Funct7(IF_ID_Funct7), .Funct3(IF_ID_Funct3), 
		.RegWrite(RegWrite), .MemWrite(Memwrite),
		.EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
		.ALUSrc(ALUSrc), .GPRSel(GPRSel), .WDSel(WDSel), .dm_ctrl(dm_c), .Memread(Memread)
	);
	EXT U_EXT(
		.iimm_shamt(IF_ID_iimm_shamt), .iimm(IF_ID_iimm), .simm(IF_ID_simm), .bimm(IF_ID_bimm),
		.uimm(IF_ID_uimm), .jimm(IF_ID_jimm),
		.EXTOp(EXTOp), .immout(immout)
	);
	RF U_RF(
		.clk(clk), .rst(reset), .save_out(0),
        .load_out(0),
		.RFWr(MEM_WB_RegWrite), 
		.A1(IF_ID_rs1), .A2(IF_ID_rs2), .A3(MEM_WB_rd), 
		.WD(WD), 
		.RD1(RD1), .RD2(RD2),.r0(r0)
		//.reg_sel(reg_sel),
		//.reg_data(reg_data)
	);
	
	assign ID_EX_in={IF_ID_int_ret,IF_ID_rd,IF_ID_rs1,IF_ID_rs2,RegWrite,Memread,Memwrite,EXTOp,ALUOp,NPCOp,ALUSrc,WDSel,dm_c,immout,RD1,RD2,IF_ID_PC_out};
    
    assign ID_EX_int_ret=ID_EX_out[167:167];
    assign ID_EX_rd=ID_EX_out[166:162];
    assign ID_EX_rs1=ID_EX_out[161:157];
    assign ID_EX_rs2=ID_EX_out[156:152];
    assign ID_EX_RegWrite=ID_EX_out[151:151];
	assign ID_EX_Memread=ID_EX_out[150:150]; // not need
	assign ID_EX_Memwrite=ID_EX_out[149:149];
	assign ID_EX_EXTOp=ID_EX_out[148:143];
    assign ID_EX_ALUOp=ID_EX_out[142:138];
    assign ID_EX_NPCOp=ID_EX_out[137:135];
    assign ID_EX_ALUSrc=ID_EX_out[134:134]; 
    assign ID_EX_WDSel=ID_EX_out[133:131];
    assign ID_EX_dm_c=ID_EX_out[130:128];
    assign ID_EX_immout=ID_EX_out[127:96];
    assign ID_EX_RD1=ID_EX_out[95:64];
    assign ID_EX_RD2=ID_EX_out[63:32];
    assign ID_EX_PC_out=ID_EX_out[31:0];
            
    always @*
    begin
        case(ForwardA)
            2'b00: A<=ID_EX_RD1;
            2'b10: A<=EX_MEM_aluout;
            2'b01: A<=WD;
            default: A<=ID_EX_RD1;
        endcase 
    end
    
    always @*
    begin
        case(ForwardB)
            2'b00: B_in<=ID_EX_RD2;
            2'b10: B_in<=EX_MEM_aluout;
            2'b01: B_in<=WD;
            default: B_in<=ID_EX_RD2;
        endcase
    end
	
	assign B = (ID_EX_ALUSrc) ? ID_EX_immout : B_in;
	
    // instantiation of alu unit
	alu U_alu(.A(A), .B(B), .ALUOp(ID_EX_ALUOp), .C(aluout), .Zero(Zero), .PC(ID_EX_PC_out));

    assign EX_MEM_in={ID_EX_int_ret,aluout,ID_EX_PC_out,ID_EX_WDSel,ID_EX_RegWrite,ID_EX_Memread,ID_EX_Memwrite,ID_EX_NPCOp,ID_EX_dm_c,ID_EX_rd,B_in};
    
    assign EX_MEM_int_ret = EX_MEM_out[113:113];
    assign EX_MEM_aluout = EX_MEM_out[112:81];
    assign EX_MEM_PC_out = EX_MEM_out[80:49];
    assign EX_MEM_WDSel = EX_MEM_out[48:46];
    assign EX_MEM_RegWrite = EX_MEM_out[45:45];
    assign EX_MEM_Memread = EX_MEM_out[44:44];
    assign EX_MEM_Memwrite = EX_MEM_out[43:43];
    assign EX_MEM_NPCOp = EX_MEM_out[42:40]; // not need
    assign EX_MEM_dm_c = EX_MEM_out[39:37];
    assign EX_MEM_rd = EX_MEM_out[36:32];
    assign EX_MEM_RD2 = EX_MEM_out[31:0];
   
    assign Addr_out = EX_MEM_aluout; // EX_MEM
	assign Data_out = EX_MEM_RD2; // EX_MEM
    assign mem_w = EX_MEM_Memwrite;
    assign dm_ctrl = EX_MEM_dm_c;
    
    assign MEM_WB_in={EX_MEM_int_ret,Data_in,EX_MEM_RegWrite,EX_MEM_rd,EX_MEM_WDSel,EX_MEM_aluout,EX_MEM_PC_out};
    
    assign MEM_WB_int_ret = MEM_WB_out[105:105];
    assign MEM_WB_Data_in = MEM_WB_out[104:73];
    assign MEM_WB_RegWrite = MEM_WB_out[72:72];
    assign MEM_WB_rd = MEM_WB_out[71:67];
    assign MEM_WB_WDSel = MEM_WB_out[66:64];
    assign MEM_WB_aluout = MEM_WB_out[63:32];
    assign MEM_WB_PC_out = MEM_WB_out[31:0];
    
    always @*
    begin
        case (MEM_WB_WDSel)
          `WDSel_FromALU: WD <= MEM_WB_aluout;
          `WDSel_FromMEM: WD <= MEM_WB_Data_in;
          `WDSel_FromPC:  WD <= MEM_WB_PC_out + 4;
        endcase
    end
    
endmodule