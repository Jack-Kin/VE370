`timescale 1ns / 1ps

module ring_counter(Q, clock, reset);
    input clock, reset;
    output [3:0]Q;
    
    reg [3:0]Q;
    
    initial begin
    Q <= 4'b1110;
    end

    always @ (posedge reset or posedge clock)
		begin
			if (reset == 1'b1) Q <= 4'b1110;
			else if (Q == 4'b1110) Q <= 4'b0111;
			else if (Q == 4'b1101) Q <= 4'b1110;
			else if (Q == 4'b1011) Q <= 4'b1101;
			else if (Q == 4'b0111) Q <= 4'b1011;
		end
    
endmodule
