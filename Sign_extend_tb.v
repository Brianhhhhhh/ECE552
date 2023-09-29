module Sign_extend_tb();
	reg clk;
	reg [15:0] instruction;
	wire [15:0] signExtended;
	
	Sign_extend iSignExtend (.instruction(instruction), .sign_extended(signExtended));
	
	initial begin
		clk = 1'b0;
		instruction = 16'h0000;
		
		// T1
		@(posedge clk);
		instruction = 16'b0100101010101111;
		@(posedge clk);
		if (signExtended != (16'h000F)) begin
			$display("Test 2 failed.");
		end
		
		// T2
		@(posedge clk);
		instruction = 16'b0101101010101000;
		@(posedge clk);
		if (signExtended != (16'h0008)) begin
			$display("Test 2 failed.");
		end
		
		// T3
		@(posedge clk);
		instruction = 16'b0110101010101001;
		@(posedge clk);
		if (signExtended != (16'h0009)) begin
			$display("Test 3 failed.");
		end
		
		// T4
		@(posedge clk);
		instruction = 16'b1000101010100111;
		@(posedge clk);
		if (signExtended != (16'h0007)) begin
			$display("Test 4 failed.");
		end
		
		// T5
		@(posedge clk);
		instruction = 16'b1000101010101101;
		@(posedge clk);
		if (signExtended != (16'hFFFD)) begin
			$display("Test 5 failed.");
		end
		
		// T6
		@(posedge clk);
		instruction = 16'b1001101010100100;
		@(posedge clk);
		if (signExtended != (16'h0004)) begin
			$display("Test 6 failed.");
		end
		
		// T7
		@(posedge clk);
		instruction = 16'b1001101010101101;
		@(posedge clk);
		if (signExtended != (16'hFFFD)) begin
			$display("Test 7 failed.");
		end
		
		// T8
		@(posedge clk);
		instruction = 16'b1010101010100100;
		@(posedge clk);
		if (signExtended != (16'hFFA4)) begin
			$display("Test 8 failed.");
		end
		
		// T9
		@(posedge clk);
		instruction = 16'b1011101000100101;
		@(posedge clk);
		if (signExtended != (16'h0025)) begin
			$display("Test 9 failed.");
		end
		
		// T10
		@(posedge clk);
		instruction = 16'b1110101100100100;
		@(posedge clk);
		if (signExtended != (16'hFF24)) begin
			$display("Test 10 failed.");
		end
		
		// T11
		@(posedge clk);
		instruction = 16'b1101101010111110;
		@(posedge clk);
		if (signExtended != (16'h00BE)) begin
			$display("Test 11 failed.");
		end
		
		$stop();
	end
	
	always begin
		#10
		clk = ~clk;
	end

endmodule