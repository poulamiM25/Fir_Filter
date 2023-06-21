`timescale 1 us/ 1 ns
//**************************************************************************************************************//
//**************************************************Multiplier**************************************************//
//**************************************************************************************************************//
module Fx_10bit_Multiplier(input1,input2,Product);
input [9:0] input1;
input [9:0] input2;
output wire [18:0] Product;
wire PP [0:8][8:0];
//stage1 Sum and Carry
wire [0:11] sum1,carry1;
//stage2 Sum and Carry
wire [0:17] sum2,carry2;
//stage3 Sum and Carry
wire [0:11] sum3,carry3;
//stage4 Sum and Carry
wire [13:0] sum4,carry4;
//stage1 Sum and Carry
//wire [0:15] sum5,carry5;
//wire [16:0] carry5;
wire [1:0] carry5;
wire [17:0] sum5;
genvar i;
genvar j;
generate
for (i=0;i<9;i=i+1) begin:x
//generate
  for (j=0;j<9;j=j+1) begin:y
    assign PP [i][j] = input1[j]&input2[i];
end
//endgenerate
end
endgenerate
//Reduction 9 6 4 3 2
//Stage1 Reduction from  9 wires to 6
HA H1(.inp1(PP[6][0]),.inp2(PP[5][1]),.sum(sum1[0]),.Cout(carry1[0]));
HA H2(.inp1(PP[4][3]),.inp2(PP[3][4]),.sum(sum1[1]),.Cout(carry1[1]));
HA H3(.inp1(PP[2][6]),.inp2(PP[1][7]),.sum(sum1[2]),.Cout(carry1[2]));
HA H4(.inp1(PP[2][7]),.inp2(PP[1][8]),.sum(sum1[3]),.Cout(carry1[3]));
FA F1(.inp1(PP[7][0]),.inp2(PP[6][1]),.Cin(PP[5][2]),.sum(sum1[4]),.Cout(carry1[4]));
FA F2(.inp1(PP[8][0]),.inp2(PP[7][1]),.Cin(PP[6][2]),.sum(sum1[5]),.Cout(carry1[5]));
FA F3(.inp1(PP[8][1]),.inp2(PP[7][2]),.Cin(PP[6][3]),.sum(sum1[6]),.Cout(carry1[6]));
FA F4(.inp1(PP[8][2]),.inp2(PP[7][3]),.Cin(PP[6][4]),.sum(sum1[7]),.Cout(carry1[7]));
FA F5(.inp1(PP[8][3]),.inp2(PP[7][4]),.Cin(PP[6][5]),.sum(sum1[8]),.Cout(carry1[8]));
FA F6(.inp1(PP[5][3]),.inp2(PP[4][4]),.Cin(PP[3][5]),.sum(sum1[9]),.Cout(carry1[9]));
FA F7(.inp1(PP[5][4]),.inp2(PP[4][5]),.Cin(PP[3][5]),.sum(sum1[10]),.Cout(carry1[10]));
FA F8(.inp1(PP[5][5]),.inp2(PP[4][6]),.Cin(PP[3][7]),.sum(sum1[11]),.Cout(carry1[11]));

//Stage2 Reduction from  6 wires to 4
HA H5(.inp1(PP[4][0]),.inp2(PP[3][1]),.sum(sum2[0]),.Cout(carry2[0]));
HA H6(.inp1(PP[2][3]),.inp2(PP[1][4]),.sum(sum2[1]),.Cout(carry2[1]));
FA F9(.inp1(PP[5][0]),.inp2(PP[4][1]),.Cin(PP[3][2]),.sum(sum2[2]),.Cout(carry2[2]));
FA F10(.inp1(sum1[0]),.inp2(PP[4][2]),.Cin(PP[3][3]),.sum(sum2[3]),.Cout(carry2[3]));
FA F11(.inp1(sum1[4]),.inp2(carry1[0]),.Cin(sum1[1]),.sum(sum2[4]),.Cout(carry2[4]));
FA F12(.inp1(sum1[5]),.inp2(carry1[4]),.Cin(sum1[9]),.sum(sum2[5]),.Cout(carry2[5]));
FA F13(.inp1(sum1[6]),.inp2(carry1[5]),.Cin(sum1[10]),.sum(sum2[6]),.Cout(carry2[6]));
FA F14(.inp1(sum1[7]),.inp2(carry1[6]),.Cin(sum1[11]),.sum(sum2[7]),.Cout(carry2[7]));
FA F15(.inp1(sum1[8]),.inp2(carry1[7]),.Cin(PP[5][6]),.sum(sum2[8]),.Cout(carry2[8]));
FA F16(.inp1(PP[8][4]),.inp2(carry1[8]),.Cin(PP[7][5]),.sum(sum2[9]),.Cout(carry2[9]));
FA F17(.inp1(PP[2][4]),.inp2(PP[1][5]),.Cin(PP[0][6]),.sum(sum2[10]),.Cout(carry2[10]));
FA F18(.inp1(PP[2][5]),.inp2(PP[1][6]),.Cin(PP[0][7]),.sum(sum2[11]),.Cout(carry2[11]));
FA F19(.inp1(carry1[1]),.inp2(sum1[2]),.Cin(PP[0][8]),.sum(sum2[12]),.Cout(carry2[12]));
FA F20(.inp1(carry1[9]),.inp2(sum1[3]),.Cin(carry1[2]),.sum(sum2[13]),.Cout(carry2[13]));
FA F21(.inp1(carry1[10]),.inp2(PP[2][8]),.Cin(carry1[3]),.sum(sum2[14]),.Cout(carry2[14]));
FA F22(.inp1(carry1[11]),.inp2(PP[4][7]),.Cin(PP[3][8]),.sum(sum2[15]),.Cout(carry2[15]));
FA F23(.inp1(PP[6][6]),.inp2(PP[5][7]),.Cin(PP[4][8]),.sum(sum2[16]),.Cout(carry2[16]));
FA F24(.inp1(PP[8][5]),.inp2(PP[7][6]),.Cin(PP[6][7]),.sum(sum2[17]),.Cout(carry2[17]));

//Stage3 Reduction from  4 wires to 3
HA H7(.inp1(PP[3][0]),.inp2(PP[2][1]),.sum(sum3[0]),.Cout(carry3[0]));
FA F25(.inp1(sum2[0]),.inp2(PP[2][2]),.Cin(PP[1][3]),.sum(sum3[1]),.Cout(carry3[1]));
FA F26(.inp1(sum2[2]),.inp2(carry2[0]),.Cin(sum2[1]),.sum(sum3[2]),.Cout(carry3[2]));

FA F27(.inp1(sum2[3]),.inp2(carry2[2]),.Cin(sum2[10]),.sum(sum3[3]),.Cout(carry3[3]));
FA F28(.inp1(sum2[4]),.inp2(carry2[3]),.Cin(sum2[11]),.sum(sum3[4]),.Cout(carry3[4]));

FA F29(.inp1(sum2[5]),.inp2(carry2[4]),.Cin(sum2[12]),.sum(sum3[5]),.Cout(carry3[5]));
FA F30(.inp1(sum2[6]),.inp2(carry2[5]),.Cin(sum2[13]),.sum(sum3[6]),.Cout(carry3[6]));
FA F31(.inp1(sum2[7]),.inp2(carry2[6]),.Cin(sum2[14]),.sum(sum3[7]),.Cout(carry3[7]));
FA F32(.inp1(sum2[8]),.inp2(carry2[7]),.Cin(sum2[15]),.sum(sum3[8]),.Cout(carry3[8]));
FA F33(.inp1(sum2[9]),.inp2(carry2[8]),.Cin(sum2[16]),.sum(sum3[9]),.Cout(carry3[9]));
FA F34(.inp1(sum2[17]),.inp2(carry2[9]),.Cin(PP[5][8]),.sum(sum3[10]),.Cout(carry3[10]));
FA F35(.inp1(PP[8][6]),.inp2(carry2[17]),.Cin(PP[7][7]),.sum(sum3[11]),.Cout(carry3[11]));

//Stage4 Reduction from  3 wires to 2
HA H8(.inp1(PP[2][0]),.inp2(PP[1][1]),.sum(sum4[0]),.Cout(carry4[0]));
FA F36(.inp1(sum3[0]),.inp2(PP[1][2]),.Cin(PP[0][3]),.sum(sum4[1]),.Cout(carry4[1]));
FA F37(.inp1(sum3[1]),.inp2(carry3[0]),.Cin(PP[0][4]),.sum(sum4[2]),.Cout(carry4[2]));
FA F38(.inp1(sum3[2]),.inp2(carry3[1]),.Cin(PP[0][5]),.sum(sum4[3]),.Cout(carry4[3]));
FA F39(.inp1(sum3[3]),.inp2(carry3[2]),.Cin(carry2[1]),.sum(sum4[4]),.Cout(carry4[4]));
FA F40(.inp1(sum3[4]),.inp2(carry3[3]),.Cin(carry2[10]),.sum(sum4[5]),.Cout(carry4[5]));
FA F41(.inp1(sum3[5]),.inp2(carry3[4]),.Cin(carry2[11]),.sum(sum4[6]),.Cout(carry4[6]));
FA F42(.inp1(sum3[6]),.inp2(carry3[5]),.Cin(carry2[12]),.sum(sum4[7]),.Cout(carry4[7]));
FA F43(.inp1(sum3[7]),.inp2(carry3[6]),.Cin(carry2[13]),.sum(sum4[8]),.Cout(carry4[8]));
FA F44(.inp1(sum3[8]),.inp2(carry3[7]),.Cin(carry2[14]),.sum(sum4[9]),.Cout(carry4[9]));
FA F45(.inp1(sum3[9]),.inp2(carry3[8]),.Cin(carry2[15]),.sum(sum4[10]),.Cout(carry4[10]));
FA F46(.inp1(sum3[10]),.inp2(carry3[9]),.Cin(carry2[16]),.sum(sum4[11]),.Cout(carry4[11]));
FA F47(.inp1(sum3[11]),.inp2(carry3[10]),.Cin(PP[6][8]),.sum(sum4[12]),.Cout(carry4[12]));
FA F48(.inp1(PP[8][7]),.inp2(carry3[11]),.Cin(PP[7][8]),.sum(sum4[13]),.Cout(carry4[13]));

//stage 5 Final addition
wire [15:0]inp1_BK;
wire [15:0]inp2_BK;
assign inp1_BK[13:0]=sum4[13:0];
assign inp1_BK[14]=PP[8][8];
assign inp1_BK[15]=0;
assign inp2_BK[0]=PP[0][2];
assign inp2_BK[14:1]=carry4[13:0];
assign inp2_BK[15]=0;

HA H9(.inp1(PP[1][0]),.inp2(PP[0][1]),.sum(sum5[1]),.Cout(carry5[0]));
BrentKung BK1(.inp1(inp1_BK),.inp2(inp2_BK),.Cin(carry5[0]),.sum(sum5[17:2]),.Cout(carry5[1]));

assign sum5[0]=PP[0][0];
assign Product[16:0]=sum5[16:0];
assign Product[17]=carry5[1];
assign Product[18]=input1[9]^input2[9];

endmodule
//**************************************************************************************************************//
//**************************************************ADDER**************************************************//
//**************************************************************************************************************//

module Fx_19bit_adder(a,b,s);
input [18:0] a,b;
output [18:0] s;


//*****************************************************************************************************
reg [17:0]adder_inp1,adder_inp2;
	reg adder_Cin,Twos_adder_Cin;
	wire cout;
	wire Twos_cout;
	
	wire [18:0] sum_32,Twos_sum_32;
	
	reg [17:0] Twos_inp1;
	reg [18:0] reg_s;
	reg [19:0] Twos_inp2_32;
	wire [19:0] Twos_inp1_32;
	
	
	
	always @ (*)
	begin
		if (a[18]==b[18]) begin
			adder_inp1<=a[17:0];
			adder_inp2<=b[17:0];
			adder_Cin <= 1'b0;
		end
		else begin
			if (a[18]==0 && b[18]==1) begin
				adder_inp1<=a[17:0];
				adder_inp2<=~b[17:0];
				adder_Cin <= 1'b1;
			end
			else begin
				adder_inp1<=~a[17:0];
				adder_inp2<=b[17:0];
				adder_Cin <= 1'b1;
		   end
	   end
	   if(a[18]==b[18]) begin
			reg_s [18] <= a[18];
			reg_s [17:0] <=sum_32[17:0];
		end
		else begin
			    Twos_inp1 <=~sum_32[17:0];
				Twos_inp2_32 <=18'd0;
				Twos_adder_Cin <=1'b1;
			if(sum_32[18]==1) begin
				reg_s [18] <= 1'b0;
				reg_s [17:0] <=sum_32[17:0];
			end
			else begin
				reg_s [18] <= 1'b1;
				reg_s [17:0] <=Twos_sum_32[17:0];
			end
		end
	end
	
	
	
	
	assign s=reg_s;
   bk b10(.inp1(adder_inp1),.inp2(adder_inp2),.Cin(adder_Cin),.sum(sum_32));	
	bk b11(.inp1(Twos_inp1),.inp2(Twos_inp2_32),.Cin(Twos_adder_Cin),.sum(Twos_sum_32));	
	
endmodule	


//**************************************************************************************************************//

module bk(inp1,inp2,Cin,sum);
input [17:0] inp1,inp2;
input Cin;
output [18:0] sum;
wire C0;
wire C1;
//wire sum3;
wire Cout;
FA H(.inp1(inp1[0]),.inp2(inp2[0]),.Cin(Cin),.sum(sum[0]),.Cout(C0));
FA F1(.inp1(inp1[1]),.inp2(inp2[1]),.Cin(C0),.sum(sum[1]),.Cout(C1));
BrentKung BK(.inp1(inp1[17:2]),.inp2(inp2[17:2]),.Cin(C1),.sum(sum[17:2]),.Cout(Cout)); 
assign sum[18]=Cout;
endmodule

//Module Half adder//
module HA(inp1,inp2,sum,Cout);
	input inp1,inp2;
	output sum,Cout;
	assign sum=inp1^inp2;
	assign Cout=inp1&inp2;
endmodule
//Module Full adder//
module FA(inp1,inp2,Cin,sum,Cout);
	input inp1,inp2,Cin;
	output sum,Cout;
	assign sum=inp1^inp2^Cin;
	assign Cout=(inp1&inp2)|(inp1&Cin)|(inp2&Cin);
endmodule
//Module BrentKung adder//
/******************* P and G calculation *************************/
module P_G(input g_i,input g_i_1,input p_i, input p_i_1, output g_out,output p_out);
assign g_out=g_i | (p_i & g_i_1);
assign p_out=p_i & p_i_1;
endmodule
/******************* Carry out Calculation *************************/
module carry_out(input g_in,input p_in,input c_in,output c_out);
assign c_out= g_in | (p_in & c_in);
endmodule
/******************* sum calculation *************************/
module sum_calculation(a_i,b_i,c_i,Sum);
input [15:0] a_i;
input [15:0] b_i;
input [15:0] c_i;
output [15:0] Sum;
assign Sum=a_i ^ b_i ^ c_i;
endmodule
/*******************Brent Kung *************************/
module BrentKung(inp1,inp2,Cin,sum,Cout);
input[15:0] inp1,inp2;
input Cin;
output[15:0] sum;
output Cout;
wire[15:0] G1,P1,c;
wire[7:0] G2,P2;
wire[3:0] G3,P3;
wire[1:0] G4,P4;
wire G5,P5;
genvar j;
generate 
	for(j=0;j<16;j=j+1) begin : x0
		assign G1[j]=inp1[j] & inp2[j];
		assign P1[j]=inp1[j] ^ inp2[j];
	end
endgenerate
/*******************G and P calculation *************************/
genvar i;
generate 
for(i=0;i<8;i=i+1) begin : x1
P_G GP1 (G1[2*i+1],G1[2*i],P1[2*i+1],P1[2*i],G2[i],P2[i]);
end
for(i=0;i<4;i=i+1)begin :x2
P_G GP2 (G2[2*i+1],G2[2*i],P2[2*i+1],P2[2*i],G3[i],P3[i]);
end
for(i=0;i<2;i=i+1) begin :x3
P_G GP3 (G3[2*i+1],G3[2*i],P3[2*i+1],P3[2*i],G4[i],P4[i]);
end
endgenerate
P_G GP4 (G4[1],G4[0],P4[1],P4[0],G5,P5);

/*******************Carry calculation *************************/
assign c[0]=Cin;
assign c[1]=G1[0]|P1[0] & c[0];
assign c[2]=G2[0]|P2[0] & c[0];
assign c[4]=G3[0]|P3[0] & c[0];
assign c[8]=G4[0]|P4[0] & c[0];
assign Cout=G5|P5 & c[0];
//C_odd C3,C5,C7,C9,C11,C13,C15
generate 
for(i=1;i<8;i=i+1) begin :x4
	carry_out C_odd(G1[2*i],P1[2*i],c[2*i],c[2*i+1]);
end
endgenerate
//C6,C10,C14
generate 
for(i=1;i<4;i=i+1) begin :x5
	carry_out C_6_10_14(G2[2*i],P2[2*i],c[4*i],c[4*i+2]);
end
endgenerate
//C13
carry_out C_12(G3[2],P3[2],c[10],c[12]);
sum_calculation S (inp1,inp2,c,sum);
endmodule



