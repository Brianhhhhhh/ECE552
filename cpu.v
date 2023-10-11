module cpu(clk, rst_n, hlt, pc);
	input clk;
	input rst_n;
	output hlt;
	output [15:0] pc;
	
	wire [15:0] newAddr, curAddr;	// new address and current address of PC
	wire [15:0] instruction;
	wire [3:0] ALUOp;
	wire Branch;
	wire BranchReg;
	wire MemRead;
	wire MemtoReg;
	wire MemWrite;
	wire ALUSrc;
	wire HALT;
	wire PCS;
	wire [15:0] immediate;
	wire [2:0] BranchCCC;
	wire [15:0] readData1, readData2;
	
	// PC register
	PCRegister iPCReg(.clk(clk), .rst(~rst_n), .wen(~HALT), .newAddr(newAddr), .curAddr(curAddr));
	
	// instruction memory
	memory1c insMem(.data_out(instruction), .data_in(16'h0000), .addr(curAddr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	
	// decode 		fix writeData
	// decode idecode(.clk(clk), .rst(~rst_n), .instruction(instruction), .writeData(), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .HALT(HALT), .PCS(PCS), .immediate(immediate), .BranchCCC(BranchCCC), .readData1(readData1), .readData2(readData2));

endmodule