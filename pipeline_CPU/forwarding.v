`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/31 00:55:55
// Design Name: 
// Module Name: forwarding
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

module forwarding(
    input beq,
    input bne,
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input EM_RW, 
    input MW_RW,
    input MEM_MemWrite,
    input [4:0] EM_Rd,
    input [4:0] IE_Rs,
    input [4:0] IE_Rt,
    input [4:0] MW_Rd,
    output [1:0] beqA,
    output [1:0] beqB,
    output  [1:0] ForwardA,
    output  [1:0] ForwardB,
    output sw_src
    
    );

reg [1:0] tmpA,tmp_beqA;
reg [1:0] tmpB, tmp_beqB;
reg temp_sw_src;
initial begin
    tmp_beqA<=0;
    tmp_beqB<=0;
	tmpA<=0;
	tmpB<=0;
	temp_sw_src<=0;
end

always@(*)
begin
if(EM_RW && (EM_Rd!=0) && (EM_Rd==ID_rs)&& (bne||beq))
	begin
 		tmp_beqA<=2'b10;
	end
else if((bne||beq)&&(MW_RW && (MW_Rd!=0) && (MW_Rd==ID_rs))&& ~(EM_RW && (EM_Rd!=0) && (EM_Rd==IE_Rs)))
	begin
 		tmp_beqA<=2'b01;
	end
else
	begin
 		tmp_beqA<=2'b00;
	end
if(EM_RW && (EM_Rd!=0) && (EM_Rd==ID_rt)&& (bne||beq))
        begin
             tmp_beqB<=2'b10;
        end
    else if((bne||beq)&&(MW_RW && (MW_Rd!=0) && (MW_Rd==ID_rt))&& ~(EM_RW && (EM_Rd!=0) && (EM_Rd==IE_Rs)))
        begin
             tmp_beqB<=2'b01;
        end
    else
        begin
             tmp_beqB<=2'b00;
        end



if(MEM_MemWrite && MW_RW &&(EM_Rd==MW_Rd))
  begin
  temp_sw_src<=1'b1;
  end
else
begin
 temp_sw_src<=1'b0;
end  
if(EM_RW && (EM_Rd!=0) && (EM_Rd==IE_Rs))
	begin
 		tmpA<=2'b10;
	end
else if((MW_RW && (MW_Rd!=0) && (MW_Rd==IE_Rs))&& ~(EM_RW && (EM_Rd!=0) && (EM_Rd==IE_Rs)))
	begin
 		tmpA<=2'b01;
	end
else
	begin
 		tmpA<=2'b00;
	end

if(EM_RW && (EM_Rd!=0) && (EM_Rd==IE_Rt))
	begin
 		tmpB<=2'b10;
	end
else if((MW_RW && (MW_Rd!=0) && (MW_Rd==IE_Rt))&& ~(EM_RW && (EM_Rd!=0) && (EM_Rd==IE_Rt)))
	begin
 		tmpB<=2'b01;
	end
else
	begin
 		tmpB<=2'b00;
	end
end

assign beqA=tmp_beqA;
assign beqB=tmp_beqB;
assign ForwardA=tmpA;
assign ForwardB=tmpB;
assign sw_src=temp_sw_src;
endmodule
/*module forwarding(
EX_rs,EX_rt,
MEM_rd,MEM_RegWrite,
WB_rd, WB_RegWrite,
selectA, selectB
);
input EX_rs,EX_rt,MEM_rd,MEM_RegWrite,WB_rd, WB_RegWrite;
output [1:0] selectA, selectB;
reg [1:0] selectA, selectB;
initial begin
selectA<=2'b00;
selectB<=2'b00;
end
always@(*)
begin
selectA<=2'b00;
selectB<=2'b00;
if((MEM_RegWrite==1'b1)&&(MEM_rd!=0)) //EX hazard
begin
if(EX_rs==MEM_rd) selectA<=2'b10;
if(EX_rt==MEM_rd) selectB<=2'b10;
end
if((WB_RegWrite==1'b1)&&(WB_rd!=0)) // MEM hazard
begin
if(selectA==2'b00)
begin
if(EX_rs==MEM_rd) selectA<=2'b01;
end
if(selectA==2'b00)
begin
if(EX_rt==MEM_rd) selectB<=2'b01;
end
end
end
endmodule*/
