module cpu(clk, rst_n, hlt, pc);
	input clk;
	input rst_n;
	output hlt;
	output [15:0] pc;
	
	// wires in IF/ID
	wire ppp, ggg, ovfl;
	wire [15:0] pcplus2, pcplus2_IF2D;
	wire [15:0] newAddr; 			// new address of PC
	wire [15:0] curAddr;			// current address of PC
	wire wen, haltNotBranch;
	wire [15:0] instruction;
	wire [15:0] instruction_Stall, instruction_IF2D;
	
	// wires in ID/EX
	wire set_ctrl_zero, PC_Write, IF_ID_Write;
	wire [15:0] instructionN;
	wire [3:0] Opcode, Rd, Rt, Rs, tempoRs, tempoRt, Rs_D2EX, Rt_D2EX, Rd_D2EX;
	wire [2:0] BranchCCC;
	wire readReg; 					// signal indicating LLB & LHB
	wire SW;	  					// signal indicating SW
	wire writeToReg, writeToReg_D2EX;
	wire [3:0] ALUOp, ALUOp_D2EX;
	wire Branch;
	wire BranchReg;
	wire MemRead, MemRead_D2EX;
	wire MemtoReg, MemtoReg_D2EX;
	wire MemWrite, MemWrite_D2EX;
	wire ALUSrc, ALUSrc_D2EX;
	wire HALT, HALT_D2EX;
	wire PCS, PCS_D2EX;
	wire pp,gg,ov;
	wire BranchFinal;
	wire [15:0] targetaddr, newAddr_D2EX;
	wire [15:0] readData1, readData2, readData1_D2EX, readData2_D2EX;
	wire [15:0] immediate, immediate_D2EX;
	wire [15:0] pcplus2_D2EX;
	
	// wires in EX/MEM
	
	// wires in MEM/WB
	
	
	
	// ++++++++++++++++++++++++++++++++++++++++ IF/ID ++++++++++++++++++++++++++++++++++++++++++++++
	
	// PC + 2
	CLA_16bit branchadder1(.a(16'h0002), .b(curAddr), .sum(pcplus2), .sub(1'b0), .ppp(ppp), .ggg(ggg), .ovfl(ovfl));
	
	// MUX selecting input address to PC Reg
	assign newAddr = (BranchFinal) ? newAddr_D2EX : pcplus2;

	// PC Register
	assign haltNotBranch = (instruction_Stall[15:12] == 4'b1111 & BranchFinal == 1'b0);		// halt is fetched but branch is not taken in decide stage, disable PC from fetching more instructions
	assign wen = ~(haltNotBranch | PC_Write);
	PCRegister iPCReg(.clk(clk), .rst(~rst_n), .wen(wen), .newAddr(newAddr), .curAddr(curAddr));
	
	// Instruction Memory
	memory_ins insMemory(.data_out(instruction), .data_in(16'h0000), .addr(curAddr), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));
	
	// IF/ID Register
	assign instruction_Stall = (BranchFinal) ? 16'hA000 : instruction; 						// Insert NOP
	IF2ID iIF2D(.clk(clk), .rst_n(~rst_n), .Instr(instruction_Stall), .PC_Inc(pcplus2), .Instr_Out(instruction_IF2D), .PC_Inc_Out(pcplus2_IF2D), .wen(~IF_ID_Write));
	
	// ++++++++++++++++++++++++++++++++++++++++ IF/ID ++++++++++++++++++++++++++++++++++++++++++++++
	
	
	
	// ++++++++++++++++++++++++++++++++++++++++ ID/EX ++++++++++++++++++++++++++++++++++++++++++++++
	
	// Hazard detection unit
	module HazardDetection(.ID_EX_MemRead(???), .ID_EX_Rt(???), .IF_ID_Rs(Rs), .IF_ID_Rt(Rt), .IF_ID_MemWrite(MemWrite), .PC_Write(PC_Write), .IF_ID_Write(IF_ID_Write), .set_ctrl_zero(set_ctrl_zero));
	
	// Stall instruction
	assign instructionN = (set_ctrl_zero) ? 16'hA000 : instruction_IF2D;					// LLB $0, 0x00 --> 1010 0000 0000 0000 	insert NOP
	
	// Decode
	assign Opcode = instructionN[15:12];
	assign Rd = instructionN[11:8];
	assign tempoRt = instructionN[3:0];
	assign tempoRs = instructionN[7:4];
	assign BranchCCC = instructionN[11:9];
	assign Rs = (readReg) ? Rd : tempoRs;
	assign Rt = (SW) ? Rd : tempoRt;
	control iControl(.opCode(Opcode), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(writeToReg), .HALT(HALT), .PCS(PCS), .readReg(readReg), .SW(SW));
	
	// New address of PC
	CLA_16bit branchadder2(.a(pcplus2_IF2D), .b(immediate << 1), .sum(targetaddr), .sub(1'b0), .ppp(pp), .ggg(gg), .ovfl(ov)); 	// Target address of branch
	BranchMux iBranchMux(.branch(Branch), .ccc(BranchCCC), .Flag(flag_out), .branch_out(BranchFinal));
	assign newAddr_D2EX = BranchFinal ? (BranchReg ? readData1 : targetaddr) : pcplus2_IF2D;	// newAddr_D2EX will be passed to IF/ID
	
	// Register file
	RegisterFile iRegisterFile(.clk(clk), .rst(~rst_n), .SrcReg1(Rs), .SrcReg2(Rt), .DstReg(Rd), .WriteReg(???), .DstData(???), .SrcData1(readData1), .SrcData2(readData2));
	
	// Immediate
	Sign_extend iSignExtend (.instruction(instructionN), .sign_extended(immediate));
	
	// ID/EX Register
	D2EX iD2EX(.ALUSrc(ALUSrc), .ALUOp(ALUOp), .readData1(readData1), .readData2(readData2), .Immediate(immediate), .Rs(Rs), .Rt(Rt), .MemRead(MemRead), .MemWrite(MemWrite), 
				.RegWrite(writeToReg), .MemtoReg(MemtoReg), .PCS(PCS), .HALT(HALT), .clk(clk), .rst_n(~rst_n), .Rd(Rd), .PC_Inc(pcplus2_IF2D), .ALUSrc_Out(ALUSrc_D2EX), 
				.ALUOp_Out(ALUOp_D2EX), .readData1_Out(readData1_D2EX), .readData2_Out(readData2_D2EX), .Immediate_Out(immediate_D2EX), .Rs_Out(Rs_D2EX), .Rt_Out(Rt_D2EX), 
				.MemRead_Out(MemRead_D2EX), .MemWrite_Out(MemWrite_D2EX), .RegWrite_Out(writeToReg_D2EX), .MemtoReg_Out(MemtoReg_D2EX), .PCS_Out(PCS_D2EX), .HALT_Out(HALT_D2EX), 
				.Rd_Out(Rd_D2EX), .PC_Inc_Out(pcplus2_D2EX));
	
	// ++++++++++++++++++++++++++++++++++++++++ ID/EX +++++++++++++++++++++++++++++++++++++++++++++++
	
	
	
	// ++++++++++++++++++++++++++++++++++++++++ EX/MEM ++++++++++++++++++++++++++++++++++++++++++++++
	
	// wires in ALU
	wire [15:0] In2;
	wire [2:0] Flag;
	wire [15:0] ALU_Out;
	
	// wires in data memory
	wire [15:0] dataMem;
	wire enable;
	
	// wires in MUX
	wire [15:0] writeData;
	
	
	// ALU
	wire [2:0] flag_out;
	assign In2 = ALUSrc ? immediate : readData2; // ALUSrc mux
	ALU iALU(.ALU_Out(ALU_Out), .In1(readData1), .In2(In2), .ALUOp(ALUOp), .Flag(Flag), .Flagin(flag_out));

	// flag register
	flag_register iflag_register(.clk(clk),.rst(~rst_n),.flag_in(Flag),.flag_out(flag_out));

	// data memory
	assign enable = MemRead | MemWrite;
	memory_data datMemory(.data_out(dataMem), .data_in(readData2), .addr(ALU_Out), .enable(enable), .wr(MemWrite), .clk(clk), .rst(~rst_n));
	
	// MUX selecting ALU_Out, dataMem, newAddr of PC to be written into register
	assign writeData = MemtoReg ? dataMem : PCS ? newAddr : ALU_Out;
	
	assign hlt = HALT;
	assign pc = curAddr;
endmodule