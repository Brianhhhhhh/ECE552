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
	wire enable;
	// wires in MUX
	wire [15:0] writeData;

	// wire in flag_register
	wire [2:0] flag_out;

	wire BranchFinal;
	
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	// PC register
	PCRegister iPCReg(.clk(clk), .rst(~rst_n), .wen(~HALT), .newAddr(newAddr), .curAddr(curAddr));
	
	// instruction memory	data_in???
	memory_ins insMemory(.data_out(instruction), .data_in(16'h0000), .addr(curAddr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	
	// decode
	decode idecode(.clk(clk), .rst(~rst_n), .instruction(instruction), .writeData(writeData), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .HALT(HALT), .PCS(PCS), .immediate(immediate), .BranchCCC(BranchCCC), .readData1(readData1), .readData2(readData2));
	
	// ALU
	assign In2 = ALUSrc ? immediate : readData2; // ALUSrc mux
	ALU iALU(.ALU_Out(ALU_Out), .In1(readData1), .In2(In2), .ALUOp(ALUOp), .Flag(Flag), .Flagin(flag_out));

	// flag register
	flag_register iflag_register(.clk(clk),.rst(~rst_n),.flag_in(Flag),.flag_out(flag_out));

	// data memory
	assign enable = MemRead | MemWrite;
	memory_data datMemory(.data_out(dataMem), .data_in(readData2), .addr(ALU_Out), .enable(enable), .wr(MemWrite), .clk(clk), .rst(~rst_n));
	
	// MUX selecting ALU_Out, dataMem, newAddr of PC to be written into register	newAddr???
	assign writeData = MemtoReg ? dataMem : PCS ? newAddr : ALU_Out;
	
	
	BranchMux  iBranchMux(.branch(Branch), .ccc(BranchCCC), .Flag(flag_out), .branch_out(BranchFinal));
	wire ppp, ggg, ovfl;
	wire pp,gg,ov;
	wire [15:0] pcplus2;
	wire [15:0] targetaddr;
	// pcplus2 = curAddr + 2;
	CLA_16bit branchadder1(.a(16'h0002), .b(curAddr), .sum(pcplus2), .sub(1'b0), .ppp(ppp), .ggg(ggg), .ovfl(ovfl));
	// targetaddr  = pcplus2 + immdiate << 1;
	CLA_16bit branchadder2(.a(pcplus2), .b(immediate << 1), .sum(targetaddr), .sub(1'b0), .ppp(pp), .ggg(gg), .ovfl(ov));

	assign newAddr = BranchFinal ? (BranchReg ? readData1 : targetaddr) : pcplus2;
	
	assign hlt = HALT;
	assign pc = curAddr;
endmodule