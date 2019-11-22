module cache();

parameter block_size = 4;
parameter tag_size = 4;

reg [127:0] cache [3:0];// 4 words=16 bytes / block
reg [3:0] cache_Tag [3:0];
reg cache_V [3:0];
reg cache_U [3:0]
reg cache_D [3:0];

initial 
	begin: initialization
		integer i;
		for (i = 0; i < block_size; i = i + 1)
		begin
			cache_V[i] = 1'b0;
			cache_U[i] = 1'b0;
			cache_D[i] = 1'b0;
			cache_Tag[i] = 4'b0000;
			cache[i] = 0;
		end
	end
endmodule
