module readReg1_mux(Opcode, tempo, rd, rs);
	input [3:0] Opcode;
	input [3:0] tempo, rd;
	output [3:0] rs;
	
	// opcode is LLB or LHB, rd is rs
	wire select;
	assign select = (Opcode == 4'b1010) | (Opcode == 4'b1011);
	assign rs = select ? rd : tempo;
	
endmodule