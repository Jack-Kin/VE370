`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/03 00:39:50
// Design Name: 
// Module Name: PC_MUX
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


module PC_MUX(
IF_PC_plus4,
bne_mux,
beq_mux,
ID_Jump,
ID_Jaddress,
ID_target,
PC_in
    );
input [31:0] IF_PC_plus4, ID_Jaddress, ID_target;
input beq_mux,bne_mux, ID_Jump;
output [31:0] PC_in;
reg [31:0] PC_in;
always@(*)
begin
if (beq_mux==1||bne_mux ==1) PC_in<=ID_target;
else if (ID_Jump==1) PC_in<=ID_Jaddress;
else PC_in<=IF_PC_plus4;
end
endmodule
