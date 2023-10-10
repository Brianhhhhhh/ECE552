module decode(clk, rst, instruction, writeData, ALUOp, Branch, BranchReg, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, HALT, PCS, readReg, immediate, BranchCCC, readData1, readData2);

	input clk, rst;
	input [15:0] instruction;
	input [15:0] writeData;
	
	output [3:0] ALUOp;
	output Branch;
	output BranchReg;
	output MemRead;
	output MemtoReg;
	output MemWrite;
	output ALUSrc;
	output RegWrite;
	output HALT;
	output PCS;
	output readReg;
	output [15:0] immediate;
	output [2:0] BranchCCC;
	inout [15:0] readData1, readData2;
	
	wire [3:0] Opcode, Rd, Rt, tempoRs, tempoRt, Rs;
	assign Opcode = instruction[15:12];
	assign Rd = instruction[11:8];
	assign tempoRt = instruction[3:0];
	assign tempoRs = instruction[7:4];
	assign BranchCCC = instruction[11:9];
	
	// determine Rs
	readReg1_mux iReadReg1Mux (.Opcode(Opcode), .tempo(tempoRs), .rd(Rd), .rs(Rs));
	
	// determine Rt
	readReg2_mux iReadReg2Mux (.Opcode(Opcode), .tempo(tempoRt), .rd(Rd), .rt(Rt));
	
	// determine immediate
	Sign_extend iSignExtend (.instruction(instruction), .sign_extended(immediate));
	
	// determine control signals
	wire write;
	control iControl(.opCode(Opcode), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(write), .HALT(HALT), .PCS(PCS), .readReg(readReg));
	assign RegWrite = write;
	
	// determine readData1 & readData2 from the register file
	RegisterFile iRegisterFile(.clk(clk), .rst(rst), .SrcReg1(Rs), .SrcReg2(Rt), .DstReg(Rd), .WriteReg(write), .DstData(writeData), .SrcData1(readData1), .SrcData2(readData2));

endmodule