module Rotator (Rot_Out, Rot_In, Rot_Val);
input [15:0] Rot_In;
input [3:0] Rot_Val;
output reg [15:0] Rot_Out;

reg [15:0] Rot_int;

always @(*) begin
		assign Rot_int = (Rot_Val[0]) ? {Rot_In[0],Rot_In[15:1]}	: Rot_In[15:0];
		assign Rot_int = (Rot_Val[1]) ? {Rot_int[1:0],Rot_int[15:2]} : Rot_int[15:0];
		assign Rot_int = (Rot_Val[2]) ? {Rot_int[3:0],Rot_int[15:4]} : Rot_int[15:0];
		assign Rot_int = (Rot_Val[3]) ? {Rot_int[7:0],Rot_int[15:8]} : Rot_int[15:0];
		assign Rot_Out = Rot_int;
	end
	
endmodule