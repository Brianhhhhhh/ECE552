module readReg1_mux(selSignal, rs, rd, readReg1);
	input selSignal;
	input [3:0] rs, rd;
	output [3:0] readReg1;
	
	// if selSignal is 1 (instruction is LLB or LHB), rd will be the input of readReg1
	assign readReg1 = selSignal ? rd : rs;

endmodule