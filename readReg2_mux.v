module readReg2_mux(Opcode, tempo, rd, rt);
	input [3:0] Opcode;
	input [3:0] tempo, rd;
	output [3:0] rt;
	
	// opcode is SW, rd is rt
	wire select;
	assign select = (Opcode == 4'b1001);
	assign rt = select ? rd : tempo;

endmodule