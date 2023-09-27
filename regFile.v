module regFile(clk, rst, readReg1, readReg2, writeReg, writeData, readData1, readData2);
	input clk, rst;
	input [3:0] readReg1;
	input [3:0] readReg2;
	input [3:0] writeReg;
	input [15:0] writeData;
	
	output reg [15:0] readData1;
	output reg [15:0] readData2;
	
	// a 16-element array, each element is a 16-bit wire
	wire [15:0] dataout [15:0];
	// output of decoder for write register
	reg [15:0] writeEn;
	
	// 16 instances of 16-bit registers
	register_16bit register0 (.write(writeEn[0]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[0]));
	register_16bit register1 (.write(writeEn[1]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[1]));
	register_16bit register2 (.write(writeEn[2]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[2]));
	register_16bit register3 (.write(writeEn[3]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[3]));
	
	register_16bit register4 (.write(writeEn[4]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[4]));
	register_16bit register5 (.write(writeEn[5]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[5]));
	register_16bit register6 (.write(writeEn[6]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[6]));
	register_16bit register7 (.write(writeEn[7]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[7]));
	
	register_16bit register8 (.write(writeEn[8]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[8]));
	register_16bit register9 (.write(writeEn[9]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[9]));
	register_16bit register10 (.write(writeEn[10]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[10]));
	register_16bit register11 (.write(writeEn[11]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[11]));
	
	register_16bit register12 (.write(writeEn[12]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[12]));
	register_16bit register13 (.write(writeEn[13]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[13]));
	register_16bit register14 (.write(writeEn[14]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[14]));
	register_16bit register15 (.write(writeEn[15]), .writeData(writeData), .clk(clk), .rst(rst), .readData(dataout[15]));
	
	// one-hot decoder of write register to generate write enable
	always@(*) begin
		case(writeReg)		
			4'd0: writeEn = 16'h0001;
			4'd1: writeEn = 16'h0002;
			4'd2: writeEn = 16'h0004;
			4'd3: writeEn = 16'h0008;
			4'd4: writeEn = 16'h0010;
			4'd5: writeEn = 16'h0020;
			4'd6: writeEn = 16'h0040;
			4'd7: writeEn = 16'h0080;
			4'd8: writeEn = 16'h0100;
			4'd9: writeEn = 16'h0200;
			4'd10: writeEn = 16'h0400;
			4'd11: writeEn = 16'h0800;
			4'd12: writeEn = 16'h1000;
			4'd13: writeEn = 16'h2000;
			4'd14: writeEn = 16'h4000;
			4'd15: writeEn = 16'h8000;
		endcase
	end
	
	// one-hot decoder of readReg1 to generate wordline to select readData1
	always@(*) begin
		case(readReg1)		
			4'd0: readData1 = dataout[0];
			4'd1: readData1 = dataout[1];
			4'd2: readData1 = dataout[2];
			4'd3: readData1 = dataout[3];
			4'd4: readData1 = dataout[4];
			4'd5: readData1 = dataout[5];
			4'd6: readData1 = dataout[6];
			4'd7: readData1 = dataout[7];
			4'd8: readData1 = dataout[8];
			4'd9: readData1 = dataout[9];
			4'd10: readData1 = dataout[10];
			4'd11: readData1 = dataout[11];
			4'd12: readData1 = dataout[12];
			4'd13: readData1 = dataout[13];
			4'd14: readData1 = dataout[14];
			4'd15: readData1 = dataout[15];
			default: readData1 = 16'h0000;
		endcase
	end
	
	// one-hot decoder of readReg2 to generate wordline to select readData2
	always@(*) begin
		case(readReg2)		
			4'd0: readData2 = dataout[0];
			4'd1: readData2 = dataout[1];
			4'd2: readData2 = dataout[2];
			4'd3: readData2 = dataout[3];
			4'd4: readData2 = dataout[4];
			4'd5: readData2 = dataout[5];
			4'd6: readData2 = dataout[6];
			4'd7: readData2 = dataout[7];
			4'd8: readData2 = dataout[8];
			4'd9: readData2 = dataout[9];
			4'd10: readData2 = dataout[10];
			4'd11: readData2 = dataout[11];
			4'd12: readData2 = dataout[12];
			4'd13: readData2 = dataout[13];
			4'd14: readData2 = dataout[14];
			4'd15: readData2 = dataout[15];
			default: readData2 = 16'h0000;
		endcase
	end
	
endmodule