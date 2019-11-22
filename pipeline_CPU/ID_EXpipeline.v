`timescale 1ns / 1ps


module ID_EXpipeline(
    input RegWrite,
    input MemtoReg,
    input MemRead,
    input MemWrite,
    input [1:0] ALUop,
    input ALUsrc,
    input RegDst,
    input [31:0] Readdata1,
    input [31:0] Readdata2,
    input [31:0] ExtendResult,
    input [4:0] Rd,
    input [4:0] Rt,
    input [4:0] Rs,
    input [5:0] func,

    output reg RegWrite1,
    output reg MemtoReg1,
    output reg MemRead1,
    output reg MemWrite1,
    output reg [1:0] ALUop1,
    output reg ALUsrc1,
    output reg RegDst1,
    output reg [31:0] RData1,
    output reg [31:0] RData2,
    output reg [31:0] ER,
    output reg [4:0]Rd1,
    output reg [4:0]Rt1,
    output reg [4:0]Rs1,
    output reg [5:0] func1,
    input clk
    );

    always@(negedge clk)
	 begin
	  Rs1<=Rs;
	  RegWrite1<=RegWrite;
	  MemtoReg1<=MemtoReg;
	  MemRead1<=MemRead;
	  MemWrite1<=MemWrite;
	  ALUop1<=ALUop;
	  ALUsrc1<=ALUsrc;
	  RData1<=Readdata1;
	  RData2<=Readdata2;
	  ER<=ExtendResult;
	  Rd1<=Rd;
	  Rt1<=Rt;
	  RegDst1<=RegDst;
	  func1<=func;
	 end

endmodule

