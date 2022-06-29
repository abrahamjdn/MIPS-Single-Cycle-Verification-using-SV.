`include "PC.v"
`include "ALU.v"
`include "ALUControl.v"
`include "control_unit.v"
`include "data_memory.v"
`include "inst_mem.v"
`include "register_file.v"
`include "SignExt.v"
`include "mux.v"
`include "Adder.v"
`include "branch_decoder.v"

module MIPS (
    input clk, rst, extInst_en,
  	input [31:0] extInst,
  output [31:0] to_memdata, to_reg_file,pc_current, pc_next, regf1, regf2
);

/*---------------------Define internal nets---------------------*/
wire[31:0] PC_w, Inst_w, Reg1_w, Reg2_w, SignE_w, Mux2_w, ALUR_w, DataM_w, Mux3_w, Adder1_w, Adder2_w, Mux4_w, Mux5_w, MemInst_w;
wire[4:0] Mux1_w;
wire[3:0] ALU_Ctl_w;
wire[1:0] ALUOp_w;
wire RegDst_w, RegWrite_w, ALUSrc_w, MemtoReg_w, MemWrite_w, BEQ_w, BNE_w, Jump_w, zero_w, sel_mux4_w;


/*---------------------Module instantiatons---------------------*/

PC MIPS_PC (.clk(clk), .rst(rst), .pc_in(Mux5_w), .pc_out(PC_w));

inst_mem MIPS_inst_mem (.address(PC_w), .inst(MemInst_w));

register_file MIPS_register_file (.rst(rst), .clk(clk), .regWrite(RegWrite_w), .readReg1(Inst_w[25:21]), .readReg2(Inst_w[20:16]), .writeReg(Mux1_w), .writeData(Mux3_w), .readData1(Reg1_w), .readData2(Reg2_w));

ALU MIPS_ALU (.ALU_Ctl(ALU_Ctl_w), .A(Reg1_w), .B(Mux2_w), .ALUOut(ALUR_w), .Zero(zero_w));

ALUControl MIPS_ALUControl (.ALUOp(ALUOp_w), .func_code(Inst_w[5:0]), .ALU_Ctl(ALU_Ctl_w));

data_memory MIPS_data_memory (.rst(rst), .clk(clk), .address(ALUR_w), .memWrite(MemWrite_w), .writeData(Reg2_w), .readData(DataM_w));

SignExt MIPS_SignExt (.data_in(Inst_w[15:0]), .data_out(SignE_w));

control_unit MIPS_control_unit (.Opcode(Inst_w[31:26]), .RegDst(RegDst_w), .RegWrite(RegWrite_w), .ALUSrc(ALUSrc_w), .MemtoReg(MemtoReg_w), .MemWrite(MemWrite_w), .BEQ(BEQ_w), .BNE(BNE_w), .Jump(Jump_w), .ALUOp(ALUOp_w));

Adder MIPS_Adder1 (.SrcA(PC_w), .SrcB(32'd1), .Result(Adder1_w));

Adder MIPS_Adder2 (.SrcA(Adder1_w), .SrcB(SignE_w), .Result(Adder2_w));

branch_decoder MIPS_branch_decoder (.beq(BEQ_w), .bne(BNE_w), .zero(zero_w), .ctrl(sel_mux4_w));

mux #(.WORD_LENGTH(5)) MIPS_mux1 (.sel(RegDst_w), .Data_0(Inst_w[20:16]), .Data_1(Inst_w[15:11]), .Mux_Output(Mux1_w));

mux MIPS_mux_extInst(.sel(extInst_en), .Data_0(MemInst_w), .Data_1(extInst), .Mux_Output(Inst_w));
  
mux MIPS_mux2 (.sel(ALUSrc_w), .Data_0(Reg2_w), .Data_1(SignE_w), .Mux_Output(Mux2_w));

mux MIPS_mux3 (.sel(MemtoReg_w), .Data_0(ALUR_w), .Data_1(DataM_w), .Mux_Output(Mux3_w));

mux MIPS_mux4 (.sel(sel_mux4_w), .Data_0(Adder1_w), .Data_1(Adder2_w), .Mux_Output(Mux4_w));

mux MIPS_mux5 (.sel(Jump_w), .Data_0(Mux4_w), .Data_1({Adder1_w[31:26], Inst_w[25:0]}), .Mux_Output(Mux5_w));

  assign to_reg_file= Mux3_w;
  assign to_memdata=Reg2_w;
  assign pc_current=PC_w;
  assign pc_next=Mux5_w;
  assign regf1=Reg1_w;
  assign regf2=Mux2_w;
  
endmodule