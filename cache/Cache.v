`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 10:03:52 PM
// Design Name: 
// Module Name: Cache
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


module Cache_writeback_DM(
input read_write,//write 1, read 0
input[9:0] cpu_Address,
input[31:0] cpu_write_data,
input[127:0] dm_read_data,
output reg[127:0] dm_write_data,
output reg[31:0] cpu_read_data,
output reg[9:0] dm_address,
output reg hit_miss,
output reg dm_read_write
// read_write: 0 for read, 1 for write
// Address: 10 bits byte address
// write_data: 32 bits value (8 bits are enough for this project demo)
// keep track of the output of your (cache+memory) block, which are read_data and hit_miss
// also please find a way to show the content of the main memory
    );
 reg[127:0] cache[3:0];
 reg[3:0] cache_Tag[3:0];
 reg[3:0] cache_V;
 reg[3:0] cache_D;
 wire[3:0] tag;
 wire[1:0] c_block_address;//4 blocks
 wire[1:0] word;//4 word in a block
 assign tag=cpu_Address[9:6];
 assign c_block_address=cpu_Address[5:4];
 assign word=cpu_Address[3:2];
 initial begin
    cache_V=4'b0;
    cache_D=4'b0;
 end
 always@(*) begin
    if(read_write==0)begin//read
        if(cache_V[c_block_address]==1&&cache_Tag[c_block_address]==tag)begin//cache hit
            case(word)
            2'b00: cpu_read_data=cache[c_block_address][31:0];
            2'b01: cpu_read_data=cache[c_block_address][63:32];
            2'b10: cpu_read_data=cache[c_block_address][95:64];
            2'b11: cpu_read_data=cache[c_block_address][127:96];
            endcase
        end else begin
            if(cache_D[c_block_address]==1)begin// dirty  has extra step          
                dm_read_write=1;//write back
                dm_write_data=cache[c_block_address];
            end
            dm_read_write=0;//read in from dm
            dm_address=cpu_Address;
            cache[c_block_address]=dm_read_data;
            cache_D[c_block_address]=0;     
            case(word)
                 2'b00: cpu_read_data=cache[c_block_address][31:0];
                 2'b01: cpu_read_data=cache[c_block_address][63:32];
                 2'b10: cpu_read_data=cache[c_block_address][95:64];
                 2'b11: cpu_read_data=cache[c_block_address][127:96];
            endcase            
        end
    end
    else//write data
    begin
        if(cache_Tag[c_block_address]!=tag)begin//not hit
            if(cache_D[c_block_address]==1)// dirty  has extra step 
            begin
                  dm_read_write=1;//write back
                  dm_write_data=cache[c_block_address];         
            end
            dm_read_write=0;//read data from dm
            dm_address=cpu_Address;
            cache[c_block_address]=dm_read_data;
        end
        case(word)//write into block
             2'b00: cache[c_block_address][31 :0 ]=cpu_write_data;
             2'b01: cache[c_block_address][63 :32]=cpu_write_data;
             2'b10: cache[c_block_address][95 :64]=cpu_write_data;
             2'b11: cache[c_block_address][127:96]=cpu_write_data;
        endcase       
        cache_D[c_block_address]=1;//mark as dirty
    end
  end
endmodule
