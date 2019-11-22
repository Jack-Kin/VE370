`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 11:22:23 PM
// Design Name: 
// Module Name: Main Memory
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


module Main_Memory_WB(
input read_write,//write 1, read 0
input[9:0] Address,
input[127:0] write_data,
output reg [31:0] read_data
    );
    
reg[127:0] Memory[255:0];
wire[7:0] Block_Address;

assign Block_Address= Address[9:2];

always@(*)begin
    case(read_write)
        1'b1:Memory[Block_Address]=write_data;
        1'b0:read_data=Memory[Block_Address];
    endcase
end
endmodule


module Main_Memory_WT(
input read_write,//write 1, read 0
input[9:0] Address,
input[32:0] write_data,//????
output reg [127:0] read_data
    );
    
reg[31:0] Memory[1023:0];
wire[9:0] Block_Address;

assign Block_Address= {Address[9:2],2'b00};

always@(*)begin
    case(read_write)
        1'b1:Memory[Address]=write_data;//write
        1'b0:read_data={Memory[Block_Address+3],Memory[Block_Address+2],Memory[Block_Address+1],Memory[Block_Address]};//read
    endcase
end
endmodule
