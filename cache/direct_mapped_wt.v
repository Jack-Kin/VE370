module direct_mapped_wt(
	input [9:0] address,
	input [7:0] write_data; // needs to expand to 32 bits
	input [127:0] read_MEM_data; //read from main memory
	input read_write; // 0 for read cache, 1 for write
	output [31:0] read_CPU_data;
	output hit_miss;  // 0 for hit, 1 for miss
	output read_write_MEM; //0 for read memory, 1 for write
	output [9:0] MEM_address;
	output [127:0] write_MEM_data
);

//previous values
//make everything to reg
//...



Ram ram();
Cache cache();

//initial begin
//...


always @(*)
begin
	if (read_write == 0) begin
		if ()
	end





end



//assign part


endmodule
