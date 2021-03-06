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
    always @(negedge clk) 
    begin
        if (regWrite == 1)
            register_memory[write_register] <= write_data;
    end
    // falling edge for reading
    // always @(negedge clk) begin
    // 	assign read_data_1 = register_memory[read_register_1];
    // 	assign read_data_2 = register_memory[read_register_2];
    // end

    // Waiting for fall edge may cause some problem.
endmodule // registers
`endif
