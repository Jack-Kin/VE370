`ifndef MODULE_ALU
`define MODULE_ALU
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2018 12:49:04 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    ALUCtrl,a,b,zero,ALU_result
    );
    input [3:0] ALUCtrl;
    input [31:0] a, b;
    output zero;
    output [31:0] ALU_result;
    reg zero;
    reg [31:0] ALU_result;
    always @ (*)
    begin
        case (ALUCtrl)
            4'b0000:
            begin
                ALU_result <= (a & b);
                zero <= (a & b == 0) ? 1:0;
            end
            4'b0001:
            begin
                ALU_result <= (a | b);
                zero <= (a | b == 0) ? 1:0;
            end
            4'b0010:
            begin
                ALU_result <= a + b;
                zero <= (a + b == 0) ? 1:0;
            end
            4'b0110:
            begin
                ALU_result <= a - b;
                zero <= ( a == b) ? 1:0;
            end
            4'b0111:
            begin
                ALU_result <= (a < b) ? 1:0;
                zero <= (a < b) ? 0:1;
            end
            default:
            begin
                ALU_result <= a;
                zero <= (a == 0) ? 1:0;
            end
        endcase    
    end
endmodule
`endif