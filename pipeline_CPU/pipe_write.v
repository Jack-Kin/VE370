`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/31 10:10:26
// Design Name: 
// Module Name: pipe_write
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
`ifndef MODULE_PIPE_WRITE
`define MODULE_PIPE_WRITE
module pipe_write(
Reg_in,
Reg_out,
flush,
clk,
hold
);
//after finish the stage, push the items into next pipelined register(every stage execute at the same time)
//IFtoID: instruction, PC+4
//IDtoEX:Jump, Branch, MemRead, MemtoReg,ALUop,MemWrite,ALUSrc,RegWrite, ID_rs, ID_rt, ID_read1,ID_read2,ID_rd,PC+4
//EXtoMEM: MemRead, MemtoReg,,MemWrite,RegWrite,EX_out, EX_rd
//MEMtoWB: MemtoReg,,RegWrite,WB_rd
   parameter size =  64; //size of the pipelined registers
   input [size-1:0] Reg_in;
   input flush,clk,hold;
   output [size-1:0] Reg_out;
   reg [size-1:0] Reg_out;
   always@(negedge clk) // second half clock for write
   begin
   if(flush==1 || hold ==1) Reg_out<=0;
   else   Reg_out<=Reg_in;
   end 
endmodule
`endif
