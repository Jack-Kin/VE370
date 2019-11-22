module testbanch;

reg [9:0] address;
reg [7:0] write_data;//in this project, 8 bit is enough for wirte
reg read_write;
reg clk;

//make all the output of cache as wire
wire [31:0] cpu_read_data;
wire hit_miss;
wire dm_read_write;
wire [9:0] dm_address;
wire [31:0] dm_write_data;

//include the cache_and_ram module
direct_mapped_wb dmwb(
    .cpu_Address(address),
    .cpu_write_data(write_data),
    .dm_read_data(dm_read_data),
    .read_write(read_write),
    .cpu_read_data(cpu_read_data),
    .hit_miss(hit_miss),
    .dm_read_write(dm_read_write),
    .dm_address(dm_address),
    .dm_write_data(dm_write_data)
);


//include the test
initial
begin
clk = 1'b1;

#0 read_write = 0; address = 10'b0000000000; //should miss
#10 read_write = 1; address = 10'b0000000000; write_data = 8'b11111111; //should hit
#10 read_write = 0; address = 10'b0000000000; //should hit and read out 0xff

//here check main memory content,
//the first byte should remain 0x00 if it is write-back,
//should change to 0xff if it is write-through.

#10 read_write = 0; address = 10'b1000000000; //should miss
#10 read_write = 0; address = 10'b0000000000; //should hit for 2-way associative, should miss for directly mapped

#10 read_write = 0; address = 10'b1100000000; //should miss
#10 read_write = 0; address = 10'b1000000000; //should miss both for directly mapped and for 2-way associative (Least-Recently-Used policy)

//here check main memory content,
//the first byte should be 0xff

#always #1 clk = ~clk;

endmodule
