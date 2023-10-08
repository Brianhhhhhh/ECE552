module RegisterFile_Testbench();

  reg clk;
  reg rst;
  reg [3:0] SrcReg1, SrcReg2, DstReg;
  reg WriteReg;
  reg [15:0] DstData;
  wire [15:0] SrcData1, SrcData2;
  
  RegisterFile dut (
    .clk(clk),
    .rst(rst),
    .SrcReg1(SrcReg1),
    .SrcReg2(SrcReg2),
    .DstReg(DstReg),
    .WriteReg(WriteReg),
    .DstData(DstData),
    .SrcData1(SrcData1),
    .SrcData2(SrcData2)
  );
  
  // Clock generation
  always begin
	#5
    clk = ~clk;
  end
  
  // Reset generation
  initial begin
	clk = 1'b0;
    rst = 1'b1;
	SrcReg1 = 4'h0;
	SrcReg2 = 4'h0;
	DstReg = 4'h0;
    WriteReg = 1'b0;
	DstData = 16'h0000;
	
	#10;
    rst = 1'b0;
    // write 16'h1234 to register 0
    SrcReg1 = 4'h1;
    SrcReg2 = 4'h2;
    DstReg = 4'h0;
    WriteReg = 1'b1;
    DstData = 16'h1234;
    #10;
	
	// write 16'h2345 to register 3 and read register 0 & register 2
    SrcReg1 = 4'h0;
    SrcReg2 = 4'h2;
    DstReg = 4'h3;
    WriteReg = 1'b1;
    DstData = 16'h2345;
    #10;
	if (SrcData1 != 16'h1234 || SrcData2 != 16'h0000) begin
		$display("Test 1 failed.");
	end
	
    // write 16'hFFFF to register 15 and read register 15 and register 3
    SrcReg1 = 4'hF;
    SrcReg2 = 4'h3;
    DstReg = 4'hF;
    WriteReg = 1'b1;
	DstData = 16'hFFFF;
    #10;
	if (SrcData1 != 16'hFFFF || SrcData2 != 16'h2345) begin
		$display("Test 2 failed.");
	end
       
    // write 16'h9876 to regiter 9 and read register 9 and register 15
    SrcReg1 = 4'hF;
    SrcReg2 = 4'h9;
    DstReg = 4'h9;
    WriteReg = 1'b1;
    DstData = 16'h9876;
    #10;
	if (SrcData1 != 16'hFFFF || SrcData2 != 16'h9876) begin
		$display("Test 3 failed.");
	end
	
	// Write to register when WriteReg is 0
	SrcReg1 = 4'hF;
    SrcReg2 = 4'h9;
    DstReg = 4'h9;
    WriteReg = 1'b0;
    DstData = 16'h8765;
    #20;
	if (SrcData1 != 16'hFFFF || SrcData2 != 16'h9876) begin
		$display("Test 4 failed.");
	end
	
	// write 16'hABCD to register 5 and read register 5
	SrcReg1 = 4'h5;
    SrcReg2 = 4'h5;
    DstReg = 4'h5;
    WriteReg = 1'b1;
    DstData = 16'hABCD;
    #10;
	if (SrcData1 != 16'hABCD || SrcData2 != 16'hABCD) begin
		$display("Test 5 failed.");
	end

	$display("Passed.");
    $stop();
  end
endmodule
