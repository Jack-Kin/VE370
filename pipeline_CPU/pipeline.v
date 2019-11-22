`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/02 23:08:08
// Design Name: 
// Module Name: pipeline
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

/*`include "Mux_N_bit.v"
`include "forward_mux.v"
`include "pipe_write.v";
`include "ALU_control.v";
`include "program_counter.v";
`include "instruction_memory.v";
`include "adder.v";
`include "forwarding.v";
`include "ALU.v";
`include "PC_MUX.v";
`include "sign_extension.v";
`include "Control.v";*/
module pipeline(
clk,reset
    );
input clk,reset;
// ALU  
wire [31:0] ALU_a,ALU_b,ALU_out,EX_result,MEM_result,WB_result,temp_ALU_b;
wire [3:0] ALU_control;
wire [5:0] EX_func;
wire [1:0] ID_ALUOp, EX_ALUOp,selectA,selectB, beqA, beqB;
//Control Signals
wire ID_RegDst,ID_Jump,ID_Branch,ID_ALUSrc,ID_MemRead,ID_MemWrite,ID_MemtoReg,ID_RegWrite,ID_Bne,
EX_RegDst,EX_Jump,EX_Branch,EX_ALUSrc,EX_MemRead,EX_MemWrite,EX_MemtoReg,EX_RegWrite,EX_Bne,
MEM_Jump,MEM_Branch,MEM_MemRead,MEM_MemWrite,MEM_MemtoReg,MEM_RegWrite,MEM_Bne,
WB_MemtoReg,WB_RegWrite,EX_Zero,MEM_Zero;
//address
wire [31:0] ID_extend, EX_extend,ID_Jaddress,ID_target;
//PC Signals
wire [31:0] PC_in, PC_out, IF_PC_plus4, ID_PC_plus4;
// Instructions memory signals
wire [31:0] IF_instruction, ID_instruction, sw_data, beq1, beq2;
//Register data
wire [31:0] ID_read1, ID_read2, EX_read1,EX_read2,write_data,MEM_read2,MEM_data,WB_data; 
//Registers
wire [4:0] EX_rs,EX_rt,EX_rd,temp_rd, MEM_rd, WB_rd;
//bne,neq
wire beq_mux,bne_mux,ID_Zero,sw_src;
assign ID_Zero= (beq1==beq2)? 1:0;
assign beq_mux = ID_Zero & ID_Branch;
assign bne_mux = (~ID_Zero) & ID_Bne;
//hazard
wire PC_write, IF_Flush, IF_Write,beq,bne,jump;
assign beq = (IF_instruction[31:26]==6'b000100)?1:0;
assign bne = (IF_instruction[31:26]==6'b000101)?1:0;
assign jump = (IF_instruction[31:26]==6'b000010)?1:0;
assign IF_Flush = beq_mux | bne_mux |ID_Jump;
// Connect PC
 program_counter PC(PC_in,PC_out,reset,clk,~PC_write);
//IF
//instruction memory
instruction_memory get_ins(
     .address(PC_out),
     .instruction(IF_instruction)
 );
// Cal PC + 4
adder add_PC_plus4(
    .a(PC_out),
    .b(32'b0100),
    .sum(IF_PC_plus4)
);

//Jump target address
assign ID_Jaddress={ID_PC_plus4[31:28],ID_instruction[25:0],2'b00};
//Hazard Detection Unit
HazardDtection HD(
  //IF_instruction,
  clk,
  bne,
  beq,
  jump,
  ID_MemRead,
  ID_RegWrite,
  EX_MemRead,
  EX_rt,
  ID_instruction[20:16],
  ID_instruction[15:11],
  IF_instruction[26:21],
  IF_instruction[20:16],
  IF_Write,
  PC_write
    );
// Register File 
assign ID_target=ID_PC_plus4 + ID_extend * 4;
Registers get_reg(
    .read_register_1(ID_instruction[25:21]),
    .read_register_2(ID_instruction[20:16]),
    .regWrite(WB_RegWrite),
    .write_register(WB_rd),
    .write_data(write_data),
    .read_data_1(ID_read1),
    .read_data_2(ID_read2),
    .clk(clk)
);
Control controller(ID_instruction[31:26], ID_ALUOp,ID_RegDst,ID_Jump,ID_Branch,ID_Bne,ID_MemRead, ID_MemtoReg,ID_MemWrite,ID_ALUSrc,ID_RegWrite);
sign_extension sign_ext(
    .shortInput(ID_instruction[15:0]),
    .longOutput(ID_extend)
);
//EX
// ALU
 ALU alu(
     .ALUCtrl(ALU_control),
     .a(ALU_a),
     .b(ALU_b),
     .ALU_result(EX_result),
     .zero(EX_Zero)
 );
// ALU control
 ALU_control alu_ctrl(
     .funct(EX_func),
     .ALUOp(EX_ALUOp),
     .ALUCtrl(ALU_control)
 );
//forwarding

forwarding forwarding_unit(
ID_Branch,
ID_Bne,
ID_instruction[25:21],
ID_instruction[20:16],
MEM_RegWrite,
WB_RegWrite,
MEM_MemWrite,
MEM_rd,
EX_rs,
EX_rt,
WB_rd,
beqA,
beqB,
selectA,
selectB,
sw_src
);
//MEM
data_memory dm(
    .clk(clk),
    .MemRead(MEM_MemRead),
    .MemWrite(MEM_MemWrite),
    .address(MEM_result),
    .write_data(sw_data),
    .read_data(MEM_data)
);
// Mux
Mux_N_bit#(5) mux_select_write_reg(
    .in1(EX_rt),
    .in2(EX_rd),
    .select(EX_RegDst),
    .out(temp_rd)
);
Mux_N_bit#(32) mux_select_ALU_in(
    .in1(temp_ALU_b),
    .in2(EX_extend),
    .select(EX_ALUSrc),
    .out(ALU_b)
);
forward_mux BEQ_MUX1(ID_read1,write_data,MEM_result,beq1,beqA);
forward_mux BEQ_MUX2(ID_read2,write_data,MEM_result,beq2,beqB);
forward_mux ALU_MUX1(EX_read1,write_data,MEM_result,ALU_a,selectA);
forward_mux ALU_MUX2(EX_read2,write_data,MEM_result,temp_ALU_b,selectB);
Mux_N_bit#(32) mux_write(
    .in1(WB_result),
    .in2(WB_data),
    .select(WB_MemtoReg),
    .out(write_data)
);
Mux_N_bit#(32) mux_sw(
    .in1(MEM_read2),
    .in2(write_data),
    .select(sw_src),
    .out(sw_data)
);
PC_MUX next_PC(IF_PC_plus4,bne_mux,beq_mux,ID_Jump,ID_Jaddress,ID_target,PC_in);
//overwrite register
pipe_write#(64) IF_ID ({IF_instruction,IF_PC_plus4},{ID_instruction,ID_PC_plus4},IF_Flush,clk,~IF_Write);
ID_EXpipeline ID_EX(
    ID_RegWrite,
    ID_MemtoReg,
    ID_MemRead,
    ID_MemWrite,
    ID_ALUOp,
    ID_ALUSrc,
    ID_RegDst,
    ID_read1,
    ID_read2,
    ID_extend,
    ID_instruction[15:11],
    ID_instruction[20:16],
    ID_instruction[25:21],
    ID_instruction[5:0],
    EX_RegWrite,
    EX_MemtoReg,
    EX_MemRead,
    EX_MemWrite,
    EX_ALUOp,
    EX_ALUSrc,
    EX_RegDst,
    EX_read1,
    EX_read2,
    EX_extend,
    EX_rd,
    EX_rt,
    EX_rs,
    EX_func,
    clk
    );
 /*EX_MEMpipe EX_MEM( EX_RegWrite,EX_MemtoReg,EX_MemRead,EX_MemWrite,EX_result, EX_read2,temp_rd,
 MEM_RegWrite, MEM_MemtoReg,MEM_MemRead,MEM_MemWrite,MEM_result, MEM_read2, MEM_rd,clk);*/
/*pipe_write#(115) ID_EX({ID_extend,ID_instruction[25:21],ID_instruction[20:16],ID_instruction[15:11],ID_instruction[5:0],ID_read1,ID_read2,
ID_RegDst,ID_ALUSrc,ID_ALUOp,ID_MemRead,ID_MemtoReg,ID_MemWrite,ID_RegWrite},
{EX_extend,EX_rs,EX_rt,EX_rd,EX_func,EX_read1,EX_read2,EX_RegDst,EX_ALUSrc,EX_ALUOp,EX_MemRead,EX_MemtoReg,EX_MemWrite,EX_RegWrite},
0,clk,0);*/
pipe_write#(85) EX_MEM({temp_rd,EX_result,EX_read2,EX_Zero,EX_MemRead,EX_MemWrite,EX_MemtoReg,EX_RegWrite},
{MEM_rd,MEM_result,MEM_read2,MEM_Zero,MEM_MemRead,MEM_MemWrite,MEM_MemtoReg,MEM_RegWrite},
0,clk,0);
pipe_write#(71) MEM_WB({MEM_result,MEM_data,MEM_rd,MEM_MemtoReg,MEM_RegWrite},
{WB_result,WB_data,WB_rd,WB_MemtoReg,WB_RegWrite},
0,clk,0);
endmodule
