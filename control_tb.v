module control_tb();
	reg clk;
	reg [3:0] opCode;
	wire [3:0] ALUOp;
	wire Branch;
	wire BranchReg;
	wire MemRead;
	wire MemtoReg;
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	wire HALT;
	wire PCS;
	wire readReg;
	
	control ictrl(.opCode(opCode), .ALUOp(ALUOp), .Branch(Branch), .BranchReg(BranchReg), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .HALT(HALT), .PCS(PCS), .readReg(readReg));
	
	initial begin
		clk = 1'b0;
		opCode = 4'b0000;
		
		@(posedge clk);
		opCode = 4'b0000;
		
		@(posedge clk);
		opCode = 4'b0001;
		
		@(posedge clk);
		opCode = 4'b0010;
		
		@(posedge clk);
		opCode = 4'b0011;
		
		@(posedge clk);
		opCode = 4'b0100;
		
		@(posedge clk);
		opCode = 4'b0101;
		
		@(posedge clk);
		opCode = 4'b0110;
		
		@(posedge clk);
		opCode = 4'b0111;
		
		@(posedge clk);
		opCode = 4'b1000;
		
		@(posedge clk);
		opCode = 4'b1001;
		
		@(posedge clk);
		opCode = 4'b1010;
		
		@(posedge clk);
		opCode = 4'b1011;
		
		@(posedge clk);
		opCode = 4'b1100;
		
		@(posedge clk);
		opCode = 4'b1101;
		
		@(posedge clk);
		opCode = 4'b1110;
		
		@(posedge clk);
		opCode = 4'b1111;
		
		#10
		$stop();
	end
		
	always begin
		#10
		clk = ~clk;
	end

endmodule