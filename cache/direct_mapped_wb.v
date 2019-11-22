module direct_mapped_wb(
	input [9:0] cpu_Address,
	input [7:0] cpu_write_data; // needs to expand to 32 bits
	input [31:0] dm_read_data; //read from main memory
	input read_write; // 0 for read cache, 1 for write
	output [31:0] cpu_read_data;
	output hit_miss;  // 0 for hit, 1 for miss
	output dm_read_write; //0 for read memory, 1 for write
	output [9:0] dm_address;
	output [31:0] dm_write_data
);

 reg pre_address;

 wire[3:0] tag;
 wire[1:0] index;//4 blocks
 wire[1:0] word;//4 word in a block
 assign tag=cpu_Address[9:6];
 assign index=cpu_Address[5:4];
 assign word=cpu_Address[3:2];


ram ram();
cache cache();

//initial begin
initial begin
    tag = 0;
    index = 0;
    word = 0;
    pre_address = 0;
end


always @(*)
begin
    if(read_write==0) 
    begin//read
        if(cache.cache_V[index]==0 || cache.cache_Tag[index] !=tag)
        begin//cache not hit
            if(cache.cache_D[index]==1)
            begin// not hit and dirty -> write back          
                dm_read_write=1;
                dm_write_data=cache[index];
                pre_address = {cache.cache_Tag[index], index};
                ram.ram[pre_address] = dm_write_data;
            end
            dm_read_write=0;//read in from dm
            cache.cache_D[index]=0;           
            dm_address=cpu_Address;
            dm_read_data = ram.ram[dm_address];
            case(word)
             2'b00: cache.cache[index][31 :0 ]=dm_read_data;
             2'b01: cache.cache[index][63 :32]=dm_read_data;
             2'b10: cache.cache[index][95 :64]=dm_read_data;
             2'b11: cache.cache[index][127:96]=dm_read_data;
            endcase
            cpu_read_data = dm_read_data;
        end
        else 
        begin
            case(word)//we need to change this part?
            2'b00: cpu_read_data=cache.cache[index][31:0];
            2'b01: cpu_read_data=cache.cache[index][63:32];
            2'b10: cpu_read_data=cache.cache[index][95:64];
            2'b11: cpu_read_data=cache.cache[index][127:96];
            endcase  
        end
    end

    else//write data
    begin
        if(cache.cache_Tag[index]!=tag)
        begin//not hit
            if(cache.cache_D[index]==1)// dirty  has extra step 
            begin
                  dm_read_write=1;//write back
                  dm_write_data=cache.cache[index];
                  pre_address = {cache.cache_Tag[index] + index};
                  ram.ram[pre_address] = dm_write_data;         
            end
            dm_read_write=0;//read data from dm
            dm_address=cpu_Address;
            dm_read_data = ram.ram[dm_address];
            case(word)//write into block
             2'b00: cache.cache[index][31 :0 ]=dm_read_data;
             2'b01: cache.cache[index][63 :32]=dm_read_data;
             2'b10: cache.cache[index][95 :64]=dm_read_data;
             2'b11: cache.cache[index][127:96]=dm_read_data;
            endcase
        end
        case(word)//write into block
             2'b00: cache.cache[index][31 :0 ]=cpu_write_data;
             2'b01: cache.cache[index][63 :32]=cpu_write_data;
             2'b10: cache.cache[index][95 :64]=cpu_write_data;
             2'b11: cache.cache[index][127:96]=cpu_write_data;
        endcase
        cache.cache_D[index]=1;//mark as dirty
    end
end



//assign part


endmodule
