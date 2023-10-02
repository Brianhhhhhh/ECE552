module Shifter (Shift_Out, Shift_In, Shift_Val, Mode);
input [15:0] Shift_In; // This is the input data to perform shift operation on
input [3:0] Shift_Val; // Shift amount (used to shift the input data)
input Mode; // To indicate 0=SLL or 1=SRA
output reg [15:0] Shift_Out; // Shifted output data

always @(*) begin 
	case(Shift_Val)
		4'h0: Shift_Out = Shift_In;
		4'h1: Shift_Out = (Mode == 1) ? {{4'h1{Shift_In[15]}},Shift_In[15:1]} : Shift_In << 4'h1;
		4'h2: Shift_Out = (Mode == 1) ? {{4'h2{Shift_In[15]}},Shift_In[15:2]} : Shift_In << 4'h2;
		4'h3: Shift_Out = (Mode == 1) ? {{4'h3{Shift_In[15]}},Shift_In[15:3]} : Shift_In << 4'h3;
		4'h4: Shift_Out = (Mode == 1) ? {{4'h4{Shift_In[15]}},Shift_In[15:4]} : Shift_In << 4'h4;
		4'h5: Shift_Out = (Mode == 1) ? {{4'h5{Shift_In[15]}},Shift_In[15:5]} : Shift_In << 4'h5;
		4'h6: Shift_Out = (Mode == 1) ? {{4'h6{Shift_In[15]}},Shift_In[15:6]} : Shift_In << 4'h6;
		4'h7: Shift_Out = (Mode == 1) ? {{4'h7{Shift_In[15]}},Shift_In[15:7]} : Shift_In << 4'h7;
		4'h8: Shift_Out = (Mode == 1) ? {{4'h8{Shift_In[15]}},Shift_In[15:8]} : Shift_In << 4'h8;
		4'h9: Shift_Out = (Mode == 1) ? {{4'h9{Shift_In[15]}},Shift_In[15:9]} : Shift_In << 4'h9;
		4'hA: Shift_Out = (Mode == 1) ? {{4'hA{Shift_In[15]}},Shift_In[15:10]} : Shift_In << 4'hA;
		4'hB: Shift_Out = (Mode == 1) ? {{4'hB{Shift_In[15]}},Shift_In[15:11]} : Shift_In << 4'hB;
		4'hC: Shift_Out = (Mode == 1) ? {{4'hC{Shift_In[15]}},Shift_In[15:12]} : Shift_In << 4'hC;
		4'hD: Shift_Out = (Mode == 1) ? {{4'hD{Shift_In[15]}},Shift_In[15:13]} : Shift_In << 4'hD;
		4'hE: Shift_Out = (Mode == 1) ? {{4'hE{Shift_In[15]}},Shift_In[15:14]} : Shift_In << 4'hE;
		4'hF: Shift_Out = (Mode == 1) ? {4'hF{Shift_In[15]}} : Shift_In << 4'hF;
		default : Shift_Out = Shift_In;
	endcase
end 
endmodule
