module cpu(clk, rst_n, hlt, pc);
	input clk;
	input rst_n;
	output hlt;
	output [15:0] pc;
	
	// wires in PC register
	wire [15:0] newAddr, curAddr;	// new address and current address of PC
	
	// wires in instruction memory
	wire [15:0] instruction;
	
	// wires in decode
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
	
	// wires in ALU
	wire [15:0] In2;
	wire [2:0] Flag;
	wire [15:0] ALU_Out;
	
	// wires in data memory
	wire [15:0] dataMem;
	
	// wires in MUX
	wire [15:0] writeData;
	
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	// PC register
	PCRegister iPCReg(.clk(clk), .rst(~rst_n), .wen(~HALT), .newAddr(newAddr), .curAddr(curAddr));
	
	// instruction memory	data_in???
	memory1c insMemory(.data_out(instruction), .data_in(16'h0000), .addr(curAddr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	
	// decode
	decode idecode(.clk(clk), .rst(~rst_n), .instruction(instruction), .writeData(writeData), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .HALT(HALT), .PCS(PCS), .immediate(immediate), .BranchCCC(BranchCCC), .readData1(readData1), .readData2(readData2));
	
	// ALU
	assign In2 = ALUSrc ? immediate : readData2; // ALUSrc mux
	ALU iALU(.ALU_Out(ALU_Out), .In1(readData1), .In2(In2), .ALUOp(ALUOp), .Flag(Flag));
	
	// data memory
	memory1c datMemory(.data_out(dataMem), .data_in(readData2), .addr(ALU_Out), .enable(MemRead), .wr(MemWrite), .clk(clk), .rst(~rst_n));
	
	// MUX selecting ALU_Out, dataMem, newAddr of PC to be written into register	newAddr???
	assign writeData = MemtoReg ? dataMem : PCS ? newAddr : ALU_Out;
	
	// newAddr, Branch ???
	
	
	assign hlt = HALT;
	assign pc = curAddr;
endmodule