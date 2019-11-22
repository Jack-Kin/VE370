`ifndef MODULE_REGISTERS
`define MODULE_REGISTERS
`timescale 1ns / 1ps

module Registers (
    input      	clk, 
    			regWrite,
    input       [4:0]   read_register_1, 	read_register_2,
    input       [4:0]   write_register,
    input       [31:0]  write_data,
    output      [31:0]  read_data_1,read_data_2
    //add something
    output      [31:0]  rs0,rs1,rs2,rs3,rs4,rs5,rs6,rs7,rt0,rt1,rt2,rt3,rt4,rt5,rt6,rt7,rt8,rt9;
);
	parameter size = 32;          // 32-bit CPU, $0 - $31
    reg [31:0] register_memory [0:size-1];
    integer i;

    initial begin
        for (i = 0; i < size; i = i + 1)
            register_memory[i] = 32'b0;
    end
    assign read_data_1 = register_memory[read_register_1];
    assign read_data_2 = register_memory[read_register_2];
    always @(posedge clk) begin
        if (regWrite == 1)
            register_memory[write_register] <= write_data;
    end
    // falling edge for reading
    // always @(negedge clk) begin
    // 	assign read_data_1 = register_memory[read_register_1];
    // 	assign read_data_2 = register_memory[read_register_2];
    // end

    // Waiting for fall edge may cause some problem.
    
    
    
    //assign registers
	assign rs0=register[16];
	assign rs1=register[17];
	assign rs2=register[18];
	assign rs3=register[19];
	assign rs4=register[20];
	assign rs5=register[21];
	assign rs6=register[22];
	assign rs7=register[23];
	assign rt0=register[8];
	assign rt1=register[9];
	assign rt2=register[10];
	assign rt3=register[11];
	assign rt4=register[12];
	assign rt5=register[13];
	assign rt6=register[14];
	assign rt7=register[15];
	assign rt8=register[24];
	assign rt9=register[25];
    
    
endmodule // registers
`endif
