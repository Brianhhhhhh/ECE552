module PADDSB_tb();	

reg clk;				// system clock
reg [15:0] a, b, sum;		// models the asynchronous signal coming in


/////// Instantiate DUT /////////
PADDSB iDUT(.sum(sum), .a(a), .b(b));

initial begin
  clk = 0;
  a = 16'h0000;
  b = 16'h0000;
  @(posedge clk);				// wait a clock
  a = 16'h760A;
  b = 16'hA6CD;
  @(posedge clk);				// wait a clock
  if (sum != 16'h17C8) begin
    $display("ERROR: Adder failed\n");
	$stop();
  end
  @(posedge clk);
  a = 16'hF78B;
  b = 16'hB87F;
  @(posedge clk);				// wait a clock
  if (sum != 16'hAFFA) begin
    $display("ERROR: Adder failed\n");
	$stop();
  end
 $stop;
end

always
  #5 clk <= ~clk;		// toggle clock every 10 time units
  
endmodule