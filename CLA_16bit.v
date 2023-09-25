module CLA_16bit(a, b, sub, sum);
input [15:0] a,b;
input sub;
output [15:0] sum;

wire [3:0] cOut;
wire [15:0] bPrime, sumRaw;
wire ovfl;

assign bPrime = (sub) ? ~b	: b;

CLA_4bit cla1 (.a(a[3:0]), .b(bPrime[3:0]), .cin(sub), .sum(sumRaw[3:0]), .cout(cOut[0]));
CLA_4bit cla2 (.a(a[7:4]), .b(bPrime[7:4]), .cin(cOut[0]), .sum(sumRaw[7:4]), .cout(cOut[1]));
CLA_4bit cla3 (.a(a[11:8]), .b(bPrime[11:8]), .cin(cOut[1]), .sum(sumRaw[11:8]), .cout(cOut[2]));
CLA_4bit cla4 (.a(a[15:12]), .b(bPrime[15:12]), .cin(cOut[2]), .sum(sumRaw[15:12]), .cout(cOut[3]));

assign ovfl = ((a[15]&bPrime[15]&!sumRaw[15])||(!a[15]&!bPrime[15]&sumRaw[15])) ? 1'b1 : 1'b0;
assign sum = (ovfl) ? ((a[15]) ? 16'h8000 : 16'h7FFF) : sumRaw;
endmodule