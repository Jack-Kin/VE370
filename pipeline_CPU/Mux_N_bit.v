`ifndef MODULE_MUX_N_BIT
`define MODULE_MUX_N_BIT
module Mux_N_bit(in1,in2,out,select);
    parameter N = 32;
    input[N-1:0] in1,in2;
    input select;
    output[N-1:0] out;
    assign out = select?in2:in1;
endmodule
`endif