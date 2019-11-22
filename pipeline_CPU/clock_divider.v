`timescale 1ns / 1ps

module clock_divider(divided_clock, clock, reset);

    input clock, reset;
    output divided_clock;
    
    reg divided_clock1;
    
    initial begin
    divided_clock1 <= 0;
    end
    
    parameter r = 100;
    integer now = 1;
    
    //notice that reset is not used here
    always @ (posedge reset or posedge clock)
        begin
        if (now <= r/2) divided_clock1 = 1;
        else divided_clock1 =0;
        if (now == r) now =1;
        else now = now + 1;
        end
        
    assign divided_clock = divided_clock1;

endmodule
