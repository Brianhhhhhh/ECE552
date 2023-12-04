module dataCache(clk, rst, address, dataIn, dataOut, memWrite, memRead, stall);
	input clk, rst, memWrite, memRead;
	input [15:0] address, dataIn, 
	output [15:0] dataOut;
	output stall;

	wire [5:0] tag;
	wire [5:0] set;
	wire [2:0] offset;
	
	wire [63:0] blockEnable;
	wire [7:0] wordEnable;
	
	wire [7:0] meta1, meta2;
	wire [15:0] data1, data2;
	
	wire way1Act;
	wire way2Act;
	wire cacheMiss;
		
	// tag, set, offset bits of requested address
	assign tag = address[15:10];
	assign set = address[9:4];
	assign offset = address[3:1];
	
	// determine which way is activated
	assign way1Act = tag == meta1[7:2];
	assign way2Act = tag == meta2[7:2];
	assign cacheMiss = ~way1Act & ~way2Act;
	
	// wordEnable and blockEnable
	wordEnable iwordEn(.offset(offset), .wordEnable(wordEnable));
	blockEnable iblockEn(.setBits(set), .blockEnable(blockEnable));
	
	// metadata array in cache
	MetaDataArray metaData(.clk(clk), .rst(rst), .DataIn(), .Write1(), .Write2(), .BlockEnable1(), .BlockEnable2(), .DataOut1(meta1), .DataOut2(meta2));
	
	// data array in cahce
	// DataIn: memory data out (cache miss) or dataIn
	// WriteW1: way1Act & (memWrite | can write from FSM)
	// WriteW2: way2Act & (memWrite | can write from FSM)
	// BlockEnable: blockEnable
	// WordEnable: wordEnable | wordEnable from FSM when cache miss
	DataArray dataArray(.clk(clk), .rst(rst), .DataIn(), .WriteW1(), .WriteW2(), .BlockEnable(), .WordEnable(), .DataOutW1(data1), .DataOutW2(data2));
	
endmodule