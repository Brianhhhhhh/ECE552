module IF2D (clk,rst_n,Instr,PC_Inc,Instr_Out,PC_Inc_Out);
	input clk,rst_n;
	input [15:0] Instr,PC_Inc;
	output [15:0] Instr_Out,PC_Inc_Out;
	
	dff iFF_Instr[15:0](.q(Instr_Out), .d(Instr), .wen(16'hFFFF), .clk({16{clk}}), .rst({16{rst_n}}));
	dff iFF_PC_Inc[15:0](.q(PC_Inc_Out), .d(PC_Inc), .wen(16'hFFFF), .clk({16{clk}}), .rst({16{rst_n}}));
	
endmodule