module CLA_16bit_tb();	

reg clk, sub;				// system clock
reg [15:0] a, b, sum;		// models the asynchronous signal coming in


/////// Instantiate DUT /////////
CLA_16bit iDUT(.sum(sum), .a(a), .b(b), .sub(sub));

always begin
  clk = 0;
  a = 16'h0000;
  b = 16'h0000;
  sub = 1'b0;
  @(posedge clk);				// wait a clock
  a = 16'h790A;
  b = 16'hABCD;
  sub = 1'b0;
  @(posedge clk);				// wait a clock
  if (a+b!=sum) begin
    $display("ERROR: Adder failed\n");
	$stop();
  end
  @(posedge clk);				// wait a clock
  a = 16'h8000;
  b = 16'h8001;
  sub = 1'b0;
  @(posedge clk);				// wait a clock
  if (sum != 16'h8000) begin
    $display("ERROR: Overflow failed\n");
	$stop();
  end
  @(posedge clk);
  a = 16'h1111;
  b = 16'h5F2B;
  sub = 1'b1;
  @(posedge clk);				// wait a clock
  if (a-b!=sum) begin
    $display("ERROR: Subtractor failed\n");
	$stop();
  end
  @(posedge clk);
  a = 16'h7000;
  b = 16'h8001;
  sub = 1'b1;
  @(posedge clk);				// wait a clock
  if (sum != 16'h7FFF) begin
    $display("ERROR: Overflow failed\n");
	$stop();
  end
 $stop;
end

always
  #5 clk <= ~clk;		// toggle clock every 10 time units
  
endmodule