`timescale 1ns / 1ps


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


//add two modules
`include "clock_divider.v";
`include "ring_counter.v";


//I made some change here
module board(
clk,reset,C,AN,clock,switch
    );

    input clk,reset,clock;
    input [4:0] switch;
    output reg [6:0] C;
    output [3:0] AN;
    
    initial begin
    	    C = 7'b1111111;
    end

wire [31:0] rs0, rs1, rs2, rs3, rs4, rs5, rt0, rt1, rt2;

//=====================================================
//following not changed 

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
assign IF_Flush = beq_mux & bne_mux &jump;
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
assign ID_target=ID_PC_plus4 + ID_extend<<2;
Registers get_reg(
    .read_register_1(ID_instruction[25:21]),
    .read_register_2(ID_instruction[20:16]),
    .regWrite(WB_RegWrite),
    .write_register(WB_rd),
    .write_data(write_data),
    .read_data_1(ID_read1),
    .read_data_2(ID_read2),
    .clk(clk),
    .rs0(rs0),
    .rs1(rs1),
    .rs2(rs2),
    .rs3(rs3),
    .rs4(rs4),
    .rs5(rs5),
    .rs6(rs6),
    .rs7(rs7),    
    .rt0(rt0),
    .rt1(rt1),
    .rt2(rt2),
    .rt3(rt3),
    .rt4(rt4),
    .rt5(rt5),
    .rt6(rt6),
    .rt7(rt7),
    .rt8(rt8),
    .rt9(rt9)
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

//=====================================================

//I made some change here
    wire clock_d;
    reg [31:0] Q2;
    reg [3:0] Q;

    clock_divider clock1(clock_d, clock, reset);

    ring_counter ring(AN, clock_d, reset);


    
    //only 9 registers and 1 PC are to be shown on the board
    always @(*) begin
		if      (switch == 5'b00000) Q2 <= PC_out;
		else if (switch == 5'b01000) Q2 <= rt0; //$t0 is $8
		else if (switch == 5'b01001) Q2 <= rt1;
		else if (switch == 5'b01010) Q2 <= rt2;
// 		else if (switch == 5'b01011) Q2 <= rt3;
// 		else if (switch == 5'b01100) Q2 <= rt4;
// 		else if (switch == 5'b01101) Q2 <= rt5;
// 		else if (switch == 5'b01110) Q2 <= rt6;
// 		else if (switch == 5'b01111) Q2 <= rt7;
		else if (switch == 5'b10000) Q2 <= rs0;//$s0 is $16
		else if (switch == 5'b10001) Q2 <= rs1;
		else if (switch == 5'b10010) Q2 <= rs2;
		else if (switch == 5'b10011) Q2 <= rs3;
		else if (switch == 5'b10100) Q2 <= rs4;
		else if (switch == 5'b10101) Q2 <= rs5;
// 		else if (switch == 5'b10110) Q2 <= rs6;
// 		else if (switch == 5'b10111) Q2 <= rs7;
// 		else if (switch == 5'b11000) Q2 <= rt8;
// 		else if (switch == 5'b11001) Q2 <= rt9;
	end


    // here only needs to use 4 hexo numbers because first 4 numbers must be 0 for the small instruction value
    always @ (*) begin
		if (AN == 4'b1110) Q <= Q2[3:0];
		else if (AN == 4'b1101) Q <= Q2[7:4];
		else if (AN == 4'b1011) Q <= Q2[11:8];
		else if (AN == 4'b0111) Q <= Q2[15:12];
	end

	// ssd numbers
	always @ (*) begin
        case (Q)
            4'h0: C = 7'b1000000;
            4'h1: C = 7'b1111001;
            4'h2: C = 7'b0100100;
            4'h3: C = 7'b0110000;
            4'h4: C = 7'b0011001;
            4'h5: C = 7'b0010010;
            4'h6: C = 7'b0000010;
            4'h7: C = 7'b1111000;
            4'h8: C = 7'b0000000;
            4'h9: C = 7'b0010000;
            4'ha: C = 7'b0001000;
            4'hb: C = 7'b0000011;
            4'hc: C = 7'b1000110;
            4'hd: C = 7'b0100001;
            4'he: C = 7'b0000110;
            4'hf: C = 7'b0001110;
            default: C = 7'b1111111;
        endcase
	end



endmodule



