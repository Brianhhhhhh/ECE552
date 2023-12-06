module insCache(clk, rst, metaIn, dataIn, blockEn, wordEn, metaWrite1, metaWrite2, dataWrite1, dataWrite2, metaOut1, metaOut2, dataOut1, dataOut2);
	input clk, rst, metaWrite1, metaWrite2, dataWrite1, dataWrite2; 
	input [7:0] metaIn;
	input [15:0] dataIn;
	input [63:0] blockEn;
	input [7:0] wordEn;
	output [7:0] metaOut1, metaOut2;
	output [15:0] dataOut1, dataOut2;
	
	// metadata array
	MetaDataArray metaData(.clk(clk), .rst(rst), .memDataIn(), .Write1(), .Write2(), .BlockEnable1(blockEnable), .BlockEnable2(blockEnable), .DataOut1(meta1), .DataOut2(meta2));
	
	// data array
	DataArray dataArray(.clk(clk), .rst(rst), .memDataIn(dataIn), .WriteW1(dataWrite1), .WriteW2(dataWrite2), .BlockEnable(blockEn), .WordEnable(wordEn), .DataOutW1(dataOut1), .DataOutW2(dataOut2));

endmodule