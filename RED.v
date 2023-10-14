module RED(a, b, sum);
input [15:0] a, b;
output [15:0] sum;

wire [3:0] s1, s2, s3, s4;
wire [7:0] s_int1, s_int2, sum_int;
wire g1, g2, g3, dummyG, dummyP;

CLA_4bit claA (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .s(s3), .g(g2), .p(dummyP));
CLA_4bit claC (.a(a[15:12]), .b(b[15:12]), .cin(g2), .s(s4), .g(dummyG), .p(dummyP));
assign s_int2 = {s4, s3};

CLA_4bit claB (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .s(s1), .g(g1), .p(dummyP));
CLA_4bit claD (.a(a[7:4]), .b(b[7:4]), .cin(g1), .s(s2), .g(dummyG), .p(dummyP));
assign s_int1 = {s2, s1};

CLA_4bit cla1 (.a(s_int1[3:0]), .b(s_int2[3:0]), .cin(1'b0), .s(sum_int[3:0]), .g(g3), .p(dummyP));
CLA_4bit cla2 (.a(s_int1[7:4]), .b(s_int2[7:4]), .cin(g3), .s(sum_int[7:4]), .g(dummyG), .p(dummyP));
assign sum = {{8{sum_int[7]}},sum_int};

endmodule