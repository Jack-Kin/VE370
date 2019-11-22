`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/31 09:19:47
// Design Name: 
// Module Name: forward_mux
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
`ifndef MODULE_FORWARD_MUX
`define MODULE_FORWARD_MUX
module forward_mux(
EX_read,
WB_result,
MEM_result,
out,
select
    );
        parameter N = 32;
        input[N-1:0] EX_read,MEM_result,WB_result;
        input [1:0] select;
        output[N-1:0] out;
        reg [N-1:0] out;
        always@(*)
        begin
        if(select==2'b00) out<=EX_read;
        else if(select==2'b01) out<=WB_result;
        else if(select==2'b10) out<=MEM_result;
        end
    endmodule
`endif
