module register_16bit (write, writeData, clk, rst, readData);
	
	input write;
	input [15:0] writeData;
	input clk;
	input rst;
	output [15:0] readData;
	
	// 16 instances of DFFs
	dff idffs [15:0] (.q(readData), .d(writeData), .wen(write), .clk(clk), .rst(rst));
	
endmodule