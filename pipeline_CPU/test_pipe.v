`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/03 01:44:44
// Design Name: 
// Module Name: test_pipe
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
//`include "pipeline.v"
module test_pipe;
parameter half_period = 1;
  reg  clk,reset=0;
  pipeline pipeline1(clk,reset);
  initial begin
  clk<=1'b0;
  end
  
  always
  begin
   #half_period clk = ~clk; 
   $display("Time: %d,  Clock = %b,  PC = 0x%h,", $time, clk, test_pipe.pipeline1.PC_out); 
 $display("IF_Instruction = 0x%h, ID_Instruction = 0x%h",test_pipe.pipeline1.IF_instruction,test_pipe.pipeline1.ID_instruction);
 $display("[$s0] = 0x%h, [$s1] = 0x%h, [$s2] = 0x%h", 
                   test_pipe.pipeline1.get_reg.register_memory[16], 
                  test_pipe.pipeline1.get_reg.register_memory[17],
                  test_pipe.pipeline1.get_reg.register_memory[18]);
$display("[$s3] = 0x%h, [$s4] = 0x%h, [$s5] = 0x%h",  test_pipe.pipeline1.get_reg.register_memory[19], 
                                    test_pipe.pipeline1.get_reg.register_memory[20],
                                    test_pipe.pipeline1.get_reg.register_memory[21]);
  end
  initial #100 $stop;
endmodule
