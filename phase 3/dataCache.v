module dataCache(clk, rst, address, dataIn, dataOut, writeEn, readEn, miss);
	input clk, rst, writeEn, readEn;
	input [15:0] address, dataIn, 
	output [15:0] dataOut;
	output miss;

	// use set offset to read two tags from cache
	
	// determine if the cache hit or cache miss by comparing tags
	
	// 


endmodule