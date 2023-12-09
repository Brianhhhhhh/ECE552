//Tag Array of 128  blocks
//Each block will have 1 byte
//BlockEnable is one-hot
//WriteEnable is one on writes and zero on reads


// DataIn = [7:2]tag [1]way [0]not used
module MetaDataArray(input clk, input rst, input [7:0] DataIn, input Write1, input Write2, input [63:0] BlockEnable, output [7:0] DataOut1, output [7:0] DataOut2, input hit);
	wire way_to_LRU = DataIn[1]; // 1 to way2, 0 to way1
	wire [7:0] DataIn1;
	wire [7:0] DataIn2;
	assign DataIn1 = hit ? {DataOut1[7:2], ~way_to_LRU, 1'b1} : {DataIn[7:2], ~way_to_LRU, 1'b1};
	assign DataIn2 = hit ? {DataOut2[7:2], way_to_LRU, 1'b1} : {DataIn[7:2], way_to_LRU, 1'b1};

	// hit : modify tag LRU and valid
	// miss : do nothing
	// miss & write : modify way 0 or 1, tag
	MBlock Mblk1[63:0]( .clk(clk), .rst(rst), .Din(DataIn1), .WriteEnable(hit | (~hit & write1)), .Enable(BlockEnable), .Dout(DataOut1));
	MBlock Mblk2[63:0]( .clk(clk), .rst(rst), .Din(DataIn2), .WriteEnable(hit | (~hit & write2)), .Enable(BlockEnable), .Dout(DataOut2));
	
endmodule

// [7:2]tag [1]LRU [0]valid
module MBlock( input clk,  input rst, input [7:0] Din, input WriteEnable, input Enable, output [7:0] Dout);
	MCell mc[7:0]( .clk(clk), .rst(rst), .Din(Din[7:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[7:0]));
endmodule

module MCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~WriteEnable) ? q:q; // always = q
	dff dffm(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule

// if(blk1.is_Vld == 0 && blk2.is_Vld == 0)
// is_LRU = 1;
// else
// is_LRU = 0;


// is_Vld == 1;
// assign dataIn_Meta = {tag, is_Vld, is_LRU};
// assign dataIn_To_Update = (tag == DataOut1[7:2]) ?	DataOut2 | 8'h01	: DataOut1 | 8'h01;
// MetaDataArray update(.clk(clk), .rst(rst), .DataIn(dataIn_To_Update), .Write1(write1), .Write2(write2), .BlockEnable(BlockEnable), .DataOut1(don't care), .DataOut2(don't care));
// MetaDataArray write(.clk(clk), .rst(rst), .DataIn(dataIn_Meta), .Write1(write1), .Write2(write2), .BlockEnable(BlockEnable), .DataOut1(don't care), .DataOut2(don't care));