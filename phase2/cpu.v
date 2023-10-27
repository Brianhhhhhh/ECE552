module cpu(clk, rst_n, hlt, pc);
	input clk;
	input rst_n;
	output hlt;
	output [15:0] pc;
	
	// wires in PC Register
	wire [15:0] newAddr, curAddr;	// new address and current address of PC
	
	// wires in Instruction Memory
	wire [15:0] instruction;
	
	// wires in Decode
	wire readReg; 					// signal indicating LLB & LHB
	wire SW;	  					// signal indicating SW
	wire writeToReg;
	wire [3:0] Opcode, Rd, Rt, Rs, tempoRs, tempoRt;
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
	
	// wire in branch
	wire BranchFinal;
	
	
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
	
	
	// PC Register
	PCRegister iPCReg(.clk(clk), .rst(~rst_n), .wen(~HALT), .newAddr(newAddr), .curAddr(curAddr));
	
	// Instruction Memory
	memory_ins insMemory(.data_out(instruction), .data_in(16'h0000), .addr(curAddr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	
	// Decode
	assign Opcode = instruction[15:12];
	assign Rd = instruction[11:8];
	assign tempoRt = instruction[3:0];
	assign tempoRs = instruction[7:4];
	assign BranchCCC = instruction[11:9];
	
	// Rs
	assign Rs = (readReg) ? Rd : tempoRs;
	
	// Rt
	assign Rt = (SW) ? Rd : tempoRt;
	
	// immediate
	Sign_extend iSignExtend (.instruction(instruction), .sign_extended(immediate));
	
	// control signals
	control iControl(.opCode(Opcode), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(writeToReg), .HALT(HALT), .PCS(PCS), .readReg(readReg), .SW(SW));
	
	// readData1 & readData2 from the register file
	RegisterFile iRegisterFile(.clk(clk), .rst(~rst_n), .SrcReg1(Rs), .SrcReg2(Rt), .DstReg(Rd), .WriteReg(writeToReg), .DstData(writeData), .SrcData1(readData1), .SrcData2(readData2));
	
	// ALU
	assign In2 = ALUSrc ? immediate : readData2; // ALUSrc mux
	ALU iALU(.ALU_Out(ALU_Out), .In1(readData1), .In2(In2), .ALUOp(ALUOp), .Flag(Flag), .Flagin(flag_out));

	// flag register
	flag_register iflag_register(.clk(clk),.rst(~rst_n),.flag_in(Flag),.flag_out(flag_out));

	// data memory
	assign enable = MemRead | MemWrite;
	memory_data datMemory(.data_out(dataMem), .data_in(readData2), .addr(ALU_Out), .enable(enable), .wr(MemWrite), .clk(clk), .rst(~rst_n));
	
	// MUX selecting ALU_Out, dataMem, newAddr of PC to be written into register
	assign writeData = MemtoReg ? dataMem : PCS ? newAddr : ALU_Out;
	
	// Branch
	BranchMux  iBranchMux(.branch(Branch), .ccc(BranchCCC), .Flag(flag_out), .branch_out(BranchFinal));
	wire ppp, ggg, ovfl;
	wire pp,gg,ov;
	wire [15:0] pcplus2;
	wire [15:0] targetaddr;
	// pcplus2 = curAddr + 2;
	CLA_16bit branchadder1(.a(16'h0002), .b(curAddr), .sum(pcplus2), .sub(1'b0), .ppp(ppp), .ggg(ggg), .ovfl(ovfl));
	// targetaddr  = pcplus2 + immdiate << 1;
	CLA_16bit branchadder2(.a(pcplus2), .b(immediate << 1), .sum(targetaddr), .sub(1'b0), .ppp(pp), .ggg(gg), .ovfl(ov));
	
	// New address of PC
	assign newAddr = BranchFinal ? (BranchReg ? readData1 : targetaddr) : pcplus2;
	
	assign hlt = HALT;
	assign pc = curAddr;
endmodule