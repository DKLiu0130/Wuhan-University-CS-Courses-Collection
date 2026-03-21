`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 20:54:40
// Design Name: 
// Module Name: riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "macro.v"

module riscv(
    input clk,
    input rstn,
    input [15:0] sw_i,
    output [7:0] disp_an_o,
    output [7:0] disp_seg_o
);

/* ---------------- clock and buttons ---------------- */
wire fast_disp = sw_i[15];
wire pc_pause = sw_i[0];
wire rf_pause = sw_i[1];
wire alu_pause = sw_i[2];
wire dm_pause = sw_i[3];
wire [6:0] dm_disp_addr = {sw_i[10:4]};

wire clk_fast, clk_slow, clk_used, clk_disp;

clk_divider #(.DIV_NUM(25)) div24 (.clk(clk), .clk_out(clk_fast));
clk_divider #(.DIV_NUM(27)) div27 (.clk(clk), .clk_out(clk_slow));
clk_divider #(.DIV_NUM(14)) div12 (.clk(clk), .clk_out(clk_disp));

wire clk_addr = fast_disp ? clk_fast : clk_slow;
assign clk_used = pc_pause ? 1'b0 : clk_addr;

wire rom_disp = sw_i[14], rf_disp = sw_i[13], alu_disp = sw_i[12], dm_disp = sw_i[11];

/* ----------------- logic part ----------------- */
wire[31:0] imm_ext;
wire [31:0] A, B, C; // A op B = C;
wire [$clog2(`RF_SIZE)-1:0] rf_addr;
wire [$clog2(`ALU_SIZE)-1:0] alu_addr;
wire [$clog2(`DM_SIZE)-1:0] dm_addr;
wire[2:0] dm_type;
reg [31:0] rf_disp_data;
reg [31:0] alu_disp_data;
reg [31:0] dm_disp_data;

wire[31:0] mem_data;

/* pc */
wire[31:0] npc, pc, b_j_addr;
wire pc_src;
assign npc = (pc_src) ? b_j_addr : pc+1; // pc_src = 0, pc++; else pc_src = 1, choose for jump_addr;

// 如果跳转，就跳到 b_j_addr
assign b_j_addr = (b_j_addr_sel) ? ((pc << 2)+ imm_ext) >>> 2: (C >>> 2); // b_j_addr_sel = 1, jal or branch; else jalr;
pc u_pc(.clk(clk_used),.rstn(rstn), .npc(npc),.pc(pc));

/* im */
wire[31:0] instr;
instruction_memory u_im(.instr_addr(pc),.instr_data(instr));

/* rf */
wire[4:0] rs1,rs2,rd;
reg[31:0] wdata; wire[31:0] rdata1,rdata2;
wire reg_write, memToreg, jalr_signal;
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];

wire[1:0] wdata_sel;
always@(*) begin
    case(wdata_sel)
        `wdata_from_c:
            wdata = C; // R type, I type
        `wdata_from_mem:
            wdata = mem_data; // MEM, S type
        `wdata_from_j:
            wdata = (pc << 2) + 4; // JALR or JAL
        default:
            wdata = 32'hffffffff;
    endcase
end

// jal, jalr 写入 pc+1
register_file u_rf(.clk(clk_used),.rstn(rstn),.rs1(rs1),.rs2(rs2),.rd(rd),.reg_write(reg_write),.wdata(wdata),.rs1_data(rdata1),.rs2_data(rdata2));



/* alu */
wire [4:0] ALU_op;
wire zero, alu_src;
assign A = rdata1;
assign B = (alu_src) ? imm_ext : rdata2;
alu u_alu(.A(A),.B(B),.ALUop(ALU_op),.C(C),.zero(zero));

/* imm_gen */
wire [5:0] ext_op;
// 未扩展前立即数提取 
wire[4:0] i_imm_shamt;
wire[11:0] i_imm, s_imm, b_imm;
wire[19:0] u_imm, j_imm;
assign i_imm_shamt = instr[24:20];
assign i_imm = instr[31:20];
assign s_imm = {instr[31:25], instr[11:7]};
assign b_imm = {instr[31], instr[7], instr[30:25], instr[11:8]};
assign u_imm = {instr[31:12]};
assign j_imm = {instr[31], instr[19:12], instr[20], instr[30:21]};
EXT u_ext(.i_imm_shamt(i_imm_shamt),.iimm(i_imm),.simm(s_imm),.b_imm(b_imm),.u_imm(u_imm),.j_imm(j_imm),.EXTOp(ext_op),.immout(imm_ext));

/* ctrl */
wire[6:0] opcode;
wire[2:0] funct3;
wire [6:0] funct7;
assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

ctrl_unit u_ctrl(.Op(opcode),.Funct3(funct3),.Funct7(funct7),.Zero(zero),.RegWrite(reg_write),.MemWrite(mem_write),.EXTOp(ext_op),.ALUOp(ALU_op),.ALUSrc(alu_src),.DMType(dm_type),.wdata_sel(wdata_sel), .pc_src(pc_src), .b_j_addr_sel(b_j_addr_sel));

/* mem */
data_memory u_dm(.clk(clk_used),.rstn(rstn),.addr(C),.DMType(dm_type), .DMWr(mem_write),.din(rdata2),.dout(mem_data));

/* ------------- display part --------- */

addr_controller #(.ADDR_SIZE(`RF_SIZE)) u_rf_addr(.clk(clk_addr), .rstn(rstn), .addr_pause(rf_pause), .data_out(rf_addr));

addr_controller #(.ADDR_SIZE(`ALU_SIZE)) u_alu_addr(.clk(clk_addr), .rstn(rstn), .addr_pause(alu_pause), .data_out(alu_addr));

always @(posedge clk_addr) begin
  rf_disp_data <= u_rf.register_file[rf_addr];
end

always@(*) begin
    case(alu_addr)
    0: alu_disp_data = A;
    1: alu_disp_data = B;
    2: alu_disp_data = C;
    3: alu_disp_data = {{31{1'b0}}, zero};
    4: alu_disp_data = {32{1'b1}};
    default: alu_disp_data = 32'hff;
    endcase
end

// check one byte
always @(posedge clk_addr) begin
    dm_disp_data <= u_dm.dmem[dm_disp_addr];
end

reg [31:0] disp_data;
always@(*) begin
    case({rom_disp, rf_disp, alu_disp, dm_disp})
        `ROM_DISP: begin 
            disp_data = instr; // 显示当前指令
        end 
        `RF_DISP:  begin
            disp_data = rf_disp_data; // 循环显示所有寄存器
        end
        `ALU_DISP: begin
            disp_data = alu_disp_data; // 循环显示 A, B, C, zero, FF
        end
        `DM_DISP: begin
           disp_data = dm_disp_data;  // 循环显示所有存储单元
        end
        default: disp_data = 32'hffffffff;
    endcase
end

disp_seg16x u_disp_seg16x(.clk(clk_disp), .rstn(rstn), .disp_data(disp_data), .an_o(disp_an_o), .seg_o(disp_seg_o));



endmodule

/* ------- clk_divider  -------*/

module clk_divider #(
    parameter DIV_NUM = 24
)
(
    input clk,
    output clk_out
);
reg[DIV_NUM:0] counter;
always @(posedge clk) begin 
   counter <= counter + 1; 
end 
assign clk_out = counter[DIV_NUM];
endmodule

/* ------- addr_controller  -------*/

module addr_controller #(
    parameter ADDR_SIZE = 20
  )(
    input clk,
    input rstn,
    input addr_pause,
    output reg [$clog2(ADDR_SIZE)-1:0] data_out
  );
  always @(posedge clk, negedge rstn)
  begin
    if(!rstn)
    begin
      data_out <= 0;
    end
    else if(addr_pause)
    begin
      data_out <= data_out;
    end
    else
    begin
      if(data_out == ADDR_SIZE - 1)
      begin
        data_out <= 0;
      end
      else
      begin
        data_out <= data_out + 1;
      end
    end
  end
endmodule

