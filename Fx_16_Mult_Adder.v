`timescale 1 us/ 1 ns

//**********************************Multiplier***********************************************//
module Fx_16_Mult(a,b,P);
//	input clk;
	input [15:0] a;
	input [15:0] b;
	output [30:0] P;

	wire PP [0:14][14:0];
	//stage1 Sum and Carry
	wire [1:6] sum1,carry1;
	//stage2 Sum and Carry
	wire [1:36] sum2,carry2;
	//stage3 Sum and Carry
	wire [1:48] sum3,carry3;
	//stage4 Sum and Carry
	wire [1:42] sum4,carry4;
	//stage5 Sum and Carry
	wire [24:1] sum5,carry5;
	//stage6 Sum and Carry
	wire [26:1] sum6,carry6;
	//stage6 Sum and Carry
	wire [28:0] sum7;
	wire [1:6] carry7;


	genvar i;
	genvar j;
	generate
		for (i=0;i<15;i=i+1) begin:x
		  for (j=0;j<15;j=j+1) begin:y
			 assign PP [i][j] = a[j] & b[i];
			end
		end
	endgenerate
	//Reduction 15 13 9 6 4 3 2
	//Stage1 Reduction from  15 wires to 13
	
	HA ha1_1(.inp1(PP[13][0]),.inp2(PP[12][1]),.sum(sum1[1]),.Cout(carry1[1]));
	FA fa1_2(.inp1(PP[14][0]),.inp2(PP[13][1]),.Cin(PP[12][2]),.sum(sum1[2]),.Cout(carry1[2]));
	FA fa1_3(.inp1(PP[14][1]),.inp2(PP[13][2]),.Cin(PP[12][3]),.sum(sum1[3]),.Cout(carry1[3]));
	FA fa1_4(.inp1(PP[14][2]),.inp2(PP[13][3]),.Cin(PP[12][4]),.sum(sum1[4]),.Cout(carry1[4]));
	HA fa1_5(.inp1(PP[11][3]),.inp2(PP[10][4]),.sum(sum1[5]),.Cout(carry1[5]));
	HA fa1_6(.inp1(PP[11][4]),.inp2(PP[10][5]),.sum(sum1[6]),.Cout(carry1[6]));
	
	
	//Stage2 Reduction from  13 wires to 9
	HA ha2_1(.inp1(PP[9][0]),.inp2(PP[8][1]),.sum(sum2[1]),.Cout(carry2[1]));
	FA fa2_2(.inp1(PP[10][0]),.inp2(PP[9][1]),.Cin(PP[8][2]),.sum(sum2[2]),.Cout(carry2[2]));
	FA fa2_3(.inp1(PP[11][0]),.inp2(PP[10][1]),.Cin(PP[9][2]),.sum(sum2[3]),.Cout(carry2[3]));
	FA fa2_4(.inp1(PP[12][0]),.inp2(PP[11][1]),.Cin(PP[10][2]),.sum(sum2[4]),.Cout(carry2[4]));
	FA fa2_5(.inp1(sum1[1]),.inp2(PP[12][1]),.Cin(PP[11][2]),.sum(sum2[5]),.Cout(carry2[5]));
	FA fa2_6(.inp1(sum1[2]),.inp2(carry1[1]),.Cin(sum1[5]),.sum(sum2[6]),.Cout(carry2[6]));
	FA fa2_7(.inp1(sum1[3]),.inp2(carry1[2]),.Cin(sum1[6]),.sum(sum2[7]),.Cout(carry2[7]));
	FA fa2_8(.inp1(sum1[4]),.inp2(carry1[3]),.Cin(PP[11][5]),.sum(sum2[8]),.Cout(carry2[8]));
	FA fa2_9(.inp1(PP[14][3]),.inp2(carry1[4]),.Cin(PP[13][4]),.sum(sum2[9]),.Cout(carry2[9]));
	FA fa2_10(.inp1(PP[14][4]),.inp2(PP[13][5]),.Cin(PP[12][6]),.sum(sum2[10]),.Cout(carry2[10]));
	FA fa2_11(.inp1(PP[14][5]),.inp2(PP[13][6]),.Cin(PP[12][7]),.sum(sum2[11]),.Cout(carry2[11]));
	FA fa2_12(.inp1(PP[14][6]),.inp2(PP[13][7]),.Cin(PP[12][8]),.sum(sum2[12]),.Cout(carry2[12]));
	HA ha2_13(.inp1(PP[7][3]),.inp2(PP[6][4]),.sum(sum2[13]),.Cout(carry2[13]));
	FA fa2_14(.inp1(PP[8][3]),.inp2(PP[7][4]),.Cin(PP[6][5]),.sum(sum2[14]),.Cout(carry2[14]));
	FA fa2_15(.inp1(PP[9][3]),.inp2(PP[8][4]),.Cin(PP[7][5]),.sum(sum2[15]),.Cout(carry2[15]));
	FA fa2_16(.inp1(PP[9][4]),.inp2(PP[8][5]),.Cin(PP[7][6]),.sum(sum2[16]),.Cout(carry2[16]));
	FA fa2_17(.inp1(PP[9][5]),.inp2(PP[8][6]),.Cin(PP[7][7]),.sum(sum2[17]),.Cout(carry2[17]));
	FA fa2_18(.inp1(carry1[5]),.inp2(PP[9][6]),.Cin(PP[8][7]),.sum(sum2[18]),.Cout(carry2[18]));
	FA fa2_19(.inp1(carry1[6]),.inp2(PP[10][6]),.Cin(PP[9][7]),.sum(sum2[19]),.Cout(carry2[19]));
	FA fa2_20(.inp1(PP[12][5]),.inp2(PP[11][6]),.Cin(PP[10][7]),.sum(sum2[20]),.Cout(carry2[20]));
	FA fa2_21(.inp1(PP[11][7]),.inp2(PP[10][8]),.Cin(PP[9][9]),.sum(sum2[21]),.Cout(carry2[21]));
	FA fa2_22(.inp1(PP[11][8]),.inp2(PP[10][9]),.Cin(PP[9][10]),.sum(sum2[22]),.Cout(carry2[22]));
	
	HA ha2_23(.inp1(PP[5][6]),.inp2(PP[4][7]),.sum(sum2[23]),.Cout(carry2[23]));
	FA fa2_24(.inp1(PP[6][6]),.inp2(PP[5][7]),.Cin(PP[4][8]),.sum(sum2[24]),.Cout(carry2[24]));
	FA fa2_25(.inp1(PP[6][7]),.inp2(PP[5][8]),.Cin(PP[4][9]),.sum(sum2[25]),.Cout(carry2[25]));
	FA fa2_26(.inp1(PP[6][8]),.inp2(PP[5][9]),.Cin(PP[4][10]),.sum(sum2[26]),.Cout(carry2[26]));
	FA fa2_27(.inp1(PP[7][8]),.inp2(PP[6][9]),.Cin(PP[5][10]),.sum(sum2[27]),.Cout(carry2[27]));
	FA fa2_28(.inp1(PP[8][8]),.inp2(PP[7][9]),.Cin(PP[6][10]),.sum(sum2[28]),.Cout(carry2[28]));
	FA fa2_29(.inp1(PP[9][8]),.inp2(PP[8][9]),.Cin(PP[7][10]),.sum(sum2[29]),.Cout(carry2[29]));
	FA fa2_30(.inp1(PP[8][10]),.inp2(PP[7][11]),.Cin(PP[6][12]),.sum(sum2[30]),.Cout(carry2[30]));
	HA ha2_31(.inp1(PP[3][9]),.inp2(PP[2][10]),.sum(sum2[31]),.Cout(carry2[31]));
	FA fa2_32(.inp1(PP[3][10]),.inp2(PP[2][11]),.Cin(PP[1][12]),.sum(sum2[32]),.Cout(carry2[32]));
	FA fa2_33(.inp1(PP[3][11]),.inp2(PP[2][12]),.Cin(PP[1][13]),.sum(sum2[33]),.Cout(carry2[33]));
	FA fa2_34(.inp1(PP[4][11]),.inp2(PP[3][12]),.Cin(PP[2][13]),.sum(sum2[34]),.Cout(carry2[34]));
	FA fa2_35(.inp1(PP[5][11]),.inp2(PP[4][12]),.Cin(PP[3][13]),.sum(sum2[35]),.Cout(carry2[35]));
	FA fa2_36(.inp1(PP[6][11]),.inp2(PP[5][12]),.Cin(PP[4][13]),.sum(sum2[36]),.Cout(carry2[36]));

	//Stage3 Reduction from  9 wires to 6
	HA ha3_1(.inp1(PP[6][0]),.inp2(PP[5][1]),.sum(sum3[1]),.Cout(carry3[1]));
	FA fa3_2(.inp1(PP[7][0]),.inp2(PP[6][1]),.Cin(PP[5][2]),.sum(sum3[2]),.Cout(carry3[2]));	
	FA fa3_3(.inp1(PP[8][0]),.inp2(PP[7][1]),.Cin(PP[6][2]),.sum(sum3[3]),.Cout(carry3[3]));	
	FA fa3_4(.inp1(sum2[1]),.inp2(PP[8][1]),.Cin(PP[7][2]),.sum(sum3[4]),.Cout(carry3[4]));
	FA fa3_5(.inp1(sum2[2]),.inp2(carry2[1]),.Cin(sum2[13]),.sum(sum3[5]),.Cout(carry3[5]));	
	FA fa3_6(.inp1(sum2[3]),.inp2(carry2[2]),.Cin(sum2[14]),.sum(sum3[6]),.Cout(carry3[6]));	
	FA fa3_7(.inp1(sum2[4]),.inp2(carry2[3]),.Cin(sum2[15]),.sum(sum3[7]),.Cout(carry3[7]));	
	FA fa3_8(.inp1(sum2[5]),.inp2(carry2[4]),.Cin(sum2[16]),.sum(sum3[8]),.Cout(carry3[8]));	
	FA fa3_9(.inp1(sum2[6]),.inp2(carry2[5]),.Cin(sum2[17]),.sum(sum3[9]),.Cout(carry3[9]));	
	FA fa3_10(.inp1(sum2[7]),.inp2(carry2[6]),.Cin(sum2[18]),.sum(sum3[10]),.Cout(carry3[10]));	
	FA fa3_11(.inp1(sum2[8]),.inp2(carry2[7]),.Cin(sum2[19]),.sum(sum3[11]),.Cout(carry3[11]));	
	FA fa3_12(.inp1(sum2[9]),.inp2(carry2[8]),.Cin(sum2[20]),.sum(sum3[12]),.Cout(carry3[12]));	
	FA fa3_13(.inp1(sum2[10]),.inp2(carry2[9]),.Cin(sum2[21]),.sum(sum3[13]),.Cout(carry3[13]));	
	FA fa3_14(.inp1(sum2[11]),.inp2(carry2[10]),.Cin(sum2[22]),.sum(sum3[14]),.Cout(carry3[14]));	
	FA fa3_15(.inp1(sum2[12]),.inp2(carry2[11]),.Cin(PP[11][9]),.sum(sum3[15]),.Cout(carry3[15]));	
	FA fa3_16(.inp1(PP[14][7]),.inp2(carry2[12]),.Cin(PP[13][8]),.sum(sum3[16]),.Cout(carry3[16]));
	FA fa3_17(.inp1(PP[14][8]),.inp2(PP[13][9]),.Cin(PP[12][10]),.sum(sum3[17]),.Cout(carry3[17]));
	FA fa3_18(.inp1(PP[14][9]),.inp2(PP[13][10]),.Cin(PP[12][11]),.sum(sum3[18]),.Cout(carry3[18]));
	HA ha3_19(.inp1(PP[4][3]),.inp2(PP[3][4]),.sum(sum3[19]),.Cout(carry3[19]));	
	FA fa3_20(.inp1(PP[5][3]),.inp2(PP[4][4]),.Cin(PP[3][5]),.sum(sum3[20]),.Cout(carry3[20]));
	FA fa3_21(.inp1(PP[5][4]),.inp2(PP[4][5]),.Cin(PP[3][6]),.sum(sum3[21]),.Cout(carry3[21]));	
	FA fa3_22(.inp1(PP[5][5]),.inp2(PP[4][6]),.Cin(PP[3][7]),.sum(sum3[22]),.Cout(carry3[22]));	
	FA fa3_23(.inp1(carry2[13]),.inp2(sum2[23]),.Cin(PP[3][8]),.sum(sum3[23]),.Cout(carry3[23]));
	FA fa3_24(.inp1(carry2[14]),.inp2(sum2[24]),.Cin(carry2[23]),.sum(sum3[24]),.Cout(carry3[24]));
	FA fa3_25(.inp1(carry2[15]),.inp2(sum2[25]),.Cin(carry2[24]),.sum(sum3[25]),.Cout(carry3[25]));
	FA fa3_26(.inp1(carry2[16]),.inp2(sum2[26]),.Cin(carry2[25]),.sum(sum3[26]),.Cout(carry3[26]));
	FA fa3_27(.inp1(carry2[17]),.inp2(sum2[27]),.Cin(carry2[26]),.sum(sum3[27]),.Cout(carry3[27]));
	FA fa3_28(.inp1(carry2[18]),.inp2(sum2[28]),.Cin(carry2[27]),.sum(sum3[28]),.Cout(carry3[28]));
	FA fa3_29(.inp1(carry2[19]),.inp2(sum2[29]),.Cin(carry2[28]),.sum(sum3[29]),.Cout(carry3[29]));
	FA fa3_30(.inp1(carry2[20]),.inp2(sum2[30]),.Cin(carry2[29]),.sum(sum3[30]),.Cout(carry3[30]));
	FA fa3_31(.inp1(carry2[21]),.inp2(PP[8][11]),.Cin(carry2[30]),.sum(sum3[31]),.Cout(carry3[31]));
	FA fa3_32(.inp1(carry2[22]),.inp2(PP[10][10]),.Cin(PP[9][11]),.sum(sum3[32]),.Cout(carry3[32]));
	FA fa3_33(.inp1(PP[12][9]),.inp2(PP[11][10]),.Cin(PP[10][11]),.sum(sum3[33]),.Cout(carry3[33]));	
	FA fa3_34(.inp1(PP[11][11]),.inp2(PP[10][12]),.Cin(PP[9][13]),.sum(sum3[34]),.Cout(carry3[34]));
	HA ha3_35(.inp1(PP[2][6]),.inp2(PP[1][7]),.sum(sum3[35]),.Cout(carry3[35]));
	FA fa3_36(.inp1(PP[2][7]),.inp2(PP[1][8]),.Cin(PP[0][9]),.sum(sum3[36]),.Cout(carry3[36]));
	FA fa3_37(.inp1(PP[2][8]),.inp2(PP[1][9]),.Cin(PP[0][10]),.sum(sum3[37]),.Cout(carry3[37]));
	FA fa3_38(.inp1(PP[2][9]),.inp2(PP[1][10]),.Cin(PP[0][11]),.sum(sum3[38]),.Cout(carry3[38]));
	FA fa3_39(.inp1(sum2[31]),.inp2(PP[1][11]),.Cin(PP[0][12]),.sum(sum3[39]),.Cout(carry3[39]));		
	FA fa3_40(.inp1(sum2[32]),.inp2(carry2[31]),.Cin(PP[0][13]),.sum(sum3[40]),.Cout(carry3[40]));
	FA fa3_41(.inp1(sum2[33]),.inp2(carry2[32]),.Cin(PP[0][14]),.sum(sum3[41]),.Cout(carry3[41]));
	FA fa3_42(.inp1(sum2[34]),.inp2(carry2[33]),.Cin(PP[1][14]),.sum(sum3[42]),.Cout(carry3[42]));	
	FA fa3_43(.inp1(sum2[35]),.inp2(carry2[34]),.Cin(PP[2][14]),.sum(sum3[43]),.Cout(carry3[43]));	
	FA fa3_44(.inp1(sum2[36]),.inp2(carry2[35]),.Cin(PP[3][14]),.sum(sum3[44]),.Cout(carry3[44]));	
	FA fa3_45(.inp1(PP[5][13]),.inp2(carry2[36]),.Cin(PP[4][14]),.sum(sum3[45]),.Cout(carry3[45]));	
	FA fa3_46(.inp1(PP[7][12]),.inp2(PP[6][13]),.Cin(PP[5][14]),.sum(sum3[46]),.Cout(carry3[46]));
	FA fa3_47(.inp1(PP[8][12]),.inp2(PP[7][13]),.Cin(PP[6][14]),.sum(sum3[47]),.Cout(carry3[47]));
	FA fa3_48(.inp1(PP[9][12]),.inp2(PP[8][13]),.Cin(PP[7][14]),.sum(sum3[48]),.Cout(carry3[48]));	



	//Stage4 Reduction from  6 wires to 4

	HA ha4_1(.inp1(PP[4][0]),.inp2(PP[5][1]),.sum(sum4[1]),.Cout(carry4[1]));
	FA fa4_2(.inp1(PP[5][0]),.inp2(PP[4][1]),.Cin(PP[3][2]),.sum(sum4[2]),.Cout(carry4[2]));
	FA fa4_3(.inp1(sum3[1]),.inp2(PP[4][2]),.Cin(PP[3][3]),.sum(sum4[3]),.Cout(carry4[3]));
	FA fa4_4(.inp1(sum3[2]),.inp2(carry3[1]),.Cin(sum3[19]),.sum(sum4[4]),.Cout(carry4[4]));
	FA fa4_5(.inp1(sum3[3]),.inp2(carry3[2]),.Cin(sum3[20]),.sum(sum4[5]),.Cout(carry4[5]));
	FA fa4_6(.inp1(sum3[4]),.inp2(carry3[3]),.Cin(sum3[21]),.sum(sum4[6]),.Cout(carry4[6]));
	FA fa4_7(.inp1(sum3[5]),.inp2(carry3[4]),.Cin(sum3[22]),.sum(sum4[7]),.Cout(carry4[7]));
	FA fa4_8(.inp1(sum3[6]),.inp2(carry3[5]),.Cin(sum3[23]),.sum(sum4[8]),.Cout(carry4[8]));
	FA fa4_9(.inp1(sum3[7]),.inp2(carry3[6]),.Cin(sum3[24]),.sum(sum4[9]),.Cout(carry4[9]));
	FA fa4_10(.inp1(sum3[8]),.inp2(carry3[7]),.Cin(sum3[25]),.sum(sum4[10]),.Cout(carry4[10]));
	FA fa4_11(.inp1(sum3[9]),.inp2(carry3[8]),.Cin(sum3[26]),.sum(sum4[11]),.Cout(carry4[11]));
	FA fa4_12(.inp1(sum3[10]),.inp2(carry3[9]),.Cin(sum3[27]),.sum(sum4[12]),.Cout(carry4[12]));
	FA fa4_13(.inp1(sum3[11]),.inp2(carry3[10]),.Cin(sum3[28]),.sum(sum4[13]),.Cout(carry4[13]));
	FA fa4_14(.inp1(sum3[12]),.inp2(carry3[11]),.Cin(sum3[29]),.sum(sum4[14]),.Cout(carry4[14]));
	FA fa4_15(.inp1(sum3[13]),.inp2(carry3[12]),.Cin(sum3[30]),.sum(sum4[15]),.Cout(carry4[15]));
	FA fa4_16(.inp1(sum3[14]),.inp2(carry3[13]),.Cin(sum3[31]),.sum(sum4[16]),.Cout(carry4[16]));
	FA fa4_17(.inp1(sum3[15]),.inp2(carry3[14]),.Cin(sum3[32]),.sum(sum4[17]),.Cout(carry4[17]));
	FA fa4_18(.inp1(sum3[16]),.inp2(carry3[15]),.Cin(sum3[33]),.sum(sum4[18]),.Cout(carry4[18]));
	FA fa4_19(.inp1(sum3[17]),.inp2(carry3[16]),.Cin(sum3[34]),.sum(sum4[19]),.Cout(carry4[19]));
	FA fa4_20(.inp1(sum3[18]),.inp2(carry3[17]),.Cin(PP[11][12]),.sum(sum4[20]),.Cout(carry4[20]));
	FA fa4_21(.inp1(PP[14][10]),.inp2(carry3[18]),.Cin(PP[13][11]),.sum(sum4[21]),.Cout(carry4[21]));
	FA fa4_22(.inp1(PP[14][11]),.inp2(PP[13][12]),.Cin(PP[12][13]),.sum(sum4[22]),.Cout(carry4[22]));
	HA ha4_23(.inp1(PP[2][3]),.inp2(PP[1][4]),.sum(sum4[23]),.Cout(carry4[23]));
	FA fa4_24(.inp1(PP[2][4]),.inp2(PP[1][5]),.Cin(PP[0][6]),.sum(sum4[24]),.Cout(carry4[24]));
	FA fa4_25(.inp1(PP[2][5]),.inp2(PP[1][6]),.Cin(PP[0][7]),.sum(sum4[25]),.Cout(carry4[25]));
	FA fa4_26(.inp1(carry3[19]),.inp2(sum3[35]),.Cin(PP[0][8]),.sum(sum4[26]),.Cout(carry4[26]));
	FA fa4_27(.inp1(carry3[20]),.inp2(sum3[36]),.Cin(carry3[35]),.sum(sum4[27]),.Cout(carry4[27]));
	FA fa4_28(.inp1(carry3[21]),.inp2(sum3[37]),.Cin(carry3[36]),.sum(sum4[28]),.Cout(carry4[28]));
	FA fa4_29(.inp1(carry3[22]),.inp2(sum3[38]),.Cin(carry3[37]),.sum(sum4[29]),.Cout(carry4[29]));
	FA fa4_30(.inp1(carry3[23]),.inp2(sum3[39]),.Cin(carry3[38]),.sum(sum4[30]),.Cout(carry4[30]));
	FA fa4_31(.inp1(carry3[24]),.inp2(sum3[40]),.Cin(carry3[39]),.sum(sum4[31]),.Cout(carry4[31]));
	FA fa4_32(.inp1(carry3[25]),.inp2(sum3[41]),.Cin(carry3[40]),.sum(sum4[32]),.Cout(carry4[32]));
	FA fa4_33(.inp1(carry3[26]),.inp2(sum3[42]),.Cin(carry3[41]),.sum(sum4[33]),.Cout(carry4[33]));
	FA fa4_34(.inp1(carry3[27]),.inp2(sum3[43]),.Cin(carry3[42]),.sum(sum4[34]),.Cout(carry4[34]));
	FA fa4_35(.inp1(carry3[28]),.inp2(sum3[44]),.Cin(carry3[43]),.sum(sum4[35]),.Cout(carry4[35]));
	FA fa4_36(.inp1(carry3[29]),.inp2(sum3[45]),.Cin(carry3[44]),.sum(sum4[36]),.Cout(carry4[36]));
	FA fa4_37(.inp1(carry3[30]),.inp2(sum3[46]),.Cin(carry3[45]),.sum(sum4[37]),.Cout(carry4[37]));
	FA fa4_38(.inp1(carry3[31]),.inp2(sum3[47]),.Cin(carry3[46]),.sum(sum4[38]),.Cout(carry4[38]));
	FA fa4_39(.inp1(carry3[32]),.inp2(sum3[48]),.Cin(carry3[47]),.sum(sum4[39]),.Cout(carry4[39]));
	FA fa4_40(.inp1(carry3[33]),.inp2(PP[8][14]),.Cin(carry3[48]),.sum(sum4[40]),.Cout(carry4[40]));
	FA fa4_41(.inp1(carry3[34]),.inp2(PP[10][13]),.Cin(PP[9][14]),.sum(sum4[41]),.Cout(carry4[41]));
	FA fa4_42(.inp1(PP[12][12]),.inp2(PP[11][13]),.Cin(PP[10][14]),.sum(sum4[42]),.Cout(carry4[42]));

	//Stage5 Reduction from  4 wires to 3
	HA ha5_1(.inp1(PP[3][0]),.inp2(PP[2][1]),.sum(sum5[1]),.Cout(carry5[1]));
	FA fa5_2(.inp1(sum4[1]),.inp2(PP[2][2]),.Cin(PP[1][3]),.sum(sum5[2]),.Cout(carry5[2]));
	FA fa5_3(.inp1(sum4[2]),.inp2(carry4[1]),.Cin(sum4[23]),.sum(sum5[3]),.Cout(carry5[3]));
	FA fa5_4(.inp1(sum4[3]),.inp2(carry4[2]),.Cin(sum4[24]),.sum(sum5[4]),.Cout(carry5[4]));
	FA fa5_5(.inp1(sum4[4]),.inp2(carry4[3]),.Cin(sum4[25]),.sum(sum5[5]),.Cout(carry5[5]));
	FA fa5_6(.inp1(sum4[5]),.inp2(carry4[4]),.Cin(sum4[26]),.sum(sum5[6]),.Cout(carry5[6]));
	FA fa5_7(.inp1(sum4[6]),.inp2(carry4[5]),.Cin(sum4[27]),.sum(sum5[7]),.Cout(carry5[7]));
	FA fa5_8(.inp1(sum4[7]),.inp2(carry4[6]),.Cin(sum4[28]),.sum(sum5[8]),.Cout(carry5[8]));
	FA fa5_9(.inp1(sum4[8]),.inp2(carry4[7]),.Cin(sum4[29]),.sum(sum5[9]),.Cout(carry5[9]));
	FA fa5_10(.inp1(sum4[9]),.inp2(carry4[8]),.Cin(sum4[30]),.sum(sum5[10]),.Cout(carry5[10]));
	FA fa5_11(.inp1(sum4[10]),.inp2(carry4[9]),.Cin(sum4[31]),.sum(sum5[11]),.Cout(carry5[11]));
	FA fa5_12(.inp1(sum4[11]),.inp2(carry4[10]),.Cin(sum4[32]),.sum(sum5[12]),.Cout(carry5[12]));
	FA fa5_13(.inp1(sum4[12]),.inp2(carry4[11]),.Cin(sum4[33]),.sum(sum5[13]),.Cout(carry5[13]));
	FA fa5_14(.inp1(sum4[13]),.inp2(carry4[12]),.Cin(sum4[34]),.sum(sum5[14]),.Cout(carry5[14]));
	FA fa5_15(.inp1(sum4[14]),.inp2(carry4[13]),.Cin(sum4[35]),.sum(sum5[15]),.Cout(carry5[15]));
	FA fa5_16(.inp1(sum4[15]),.inp2(carry4[14]),.Cin(sum4[36]),.sum(sum5[16]),.Cout(carry5[16]));
	FA fa5_17(.inp1(sum4[16]),.inp2(carry4[15]),.Cin(sum4[37]),.sum(sum5[17]),.Cout(carry5[17]));
	FA fa5_18(.inp1(sum4[17]),.inp2(carry4[16]),.Cin(sum4[38]),.sum(sum5[18]),.Cout(carry5[18]));
	FA fa5_19(.inp1(sum4[18]),.inp2(carry4[17]),.Cin(sum4[39]),.sum(sum5[19]),.Cout(carry5[19]));
	FA fa5_20(.inp1(sum4[19]),.inp2(carry4[18]),.Cin(sum4[40]),.sum(sum5[20]),.Cout(carry5[20]));
	FA fa5_21(.inp1(sum4[20]),.inp2(carry4[19]),.Cin(sum4[41]),.sum(sum5[21]),.Cout(carry5[21]));
	FA fa5_22(.inp1(sum4[21]),.inp2(carry4[20]),.Cin(sum4[42]),.sum(sum5[22]),.Cout(carry5[22]));
	FA fa5_23(.inp1(sum4[22]),.inp2(carry4[21]),.Cin(PP[11][14]),.sum(sum5[23]),.Cout(carry5[23]));
	FA fa5_24(.inp1(PP[14][12]),.inp2(carry4[22]),.Cin(PP[13][13]),.sum(sum5[24]),.Cout(carry5[24]));


	//Stage6 Reduction from  3 wires to 2
	HA ha6_1(.inp1(PP[2][0]),.inp2(PP[1][1]),.sum(sum6[1]),.Cout(carry6[1]));
	FA fa6_2(.inp1(sum5[1]),.inp2(PP[1][2]),.Cin(PP[0][3]),.sum(sum6[2]),.Cout(carry6[2]));
	FA fa6_3(.inp1(sum5[2]),.inp2(carry5[1]),.Cin(PP[0][4]),.sum(sum6[3]),.Cout(carry6[3]));
	FA fa6_4(.inp1(sum5[3]),.inp2(carry5[2]),.Cin(PP[0][5]),.sum(sum6[4]),.Cout(carry6[4]));
	FA fa6_5(.inp1(sum5[4]),.inp2(carry5[3]),.Cin(carry4[23]),.sum(sum6[5]),.Cout(carry6[5]));
	FA fa6_6(.inp1(sum5[5]),.inp2(carry5[4]),.Cin(carry4[24]),.sum(sum6[6]),.Cout(carry6[6]));
	FA fa6_7(.inp1(sum5[6]),.inp2(carry5[5]),.Cin(carry4[25]),.sum(sum6[7]),.Cout(carry6[7]));
	FA fa6_8(.inp1(sum5[7]),.inp2(carry5[6]),.Cin(carry4[26]),.sum(sum6[8]),.Cout(carry6[8]));
	FA fa6_9(.inp1(sum5[8]),.inp2(carry5[7]),.Cin(carry4[27]),.sum(sum6[9]),.Cout(carry6[9]));
	FA fa6_10(.inp1(sum5[9]),.inp2(carry5[8]),.Cin(carry4[28]),.sum(sum6[10]),.Cout(carry6[10]));
	FA fa6_11(.inp1(sum5[10]),.inp2(carry5[9]),.Cin(carry4[29]),.sum(sum6[11]),.Cout(carry6[11]));
	FA fa6_12(.inp1(sum5[11]),.inp2(carry5[10]),.Cin(carry4[30]),.sum(sum6[12]),.Cout(carry6[12]));
	FA fa6_13(.inp1(sum5[12]),.inp2(carry5[11]),.Cin(carry4[31]),.sum(sum6[13]),.Cout(carry6[13]));
	FA fa6_14(.inp1(sum5[13]),.inp2(carry5[12]),.Cin(carry4[32]),.sum(sum6[14]),.Cout(carry6[14]));
	FA fa6_15(.inp1(sum5[14]),.inp2(carry5[13]),.Cin(carry4[33]),.sum(sum6[15]),.Cout(carry6[15]));
	FA fa6_16(.inp1(sum5[15]),.inp2(carry5[14]),.Cin(carry4[34]),.sum(sum6[16]),.Cout(carry6[16]));
	FA fa6_17(.inp1(sum5[16]),.inp2(carry5[15]),.Cin(carry4[35]),.sum(sum6[17]),.Cout(carry6[17]));
	FA fa6_18(.inp1(sum5[17]),.inp2(carry5[16]),.Cin(carry4[36]),.sum(sum6[18]),.Cout(carry6[18]));
	FA fa6_19(.inp1(sum5[18]),.inp2(carry5[17]),.Cin(carry4[37]),.sum(sum6[19]),.Cout(carry6[19]));
	FA fa6_20(.inp1(sum5[19]),.inp2(carry5[18]),.Cin(carry4[38]),.sum(sum6[20]),.Cout(carry6[20]));
	FA fa6_21(.inp1(sum5[20]),.inp2(carry5[19]),.Cin(carry4[39]),.sum(sum6[21]),.Cout(carry6[21]));
	FA fa6_22(.inp1(sum5[21]),.inp2(carry5[20]),.Cin(carry4[40]),.sum(sum6[22]),.Cout(carry6[22]));
	FA fa6_23(.inp1(sum5[22]),.inp2(carry5[21]),.Cin(carry4[41]),.sum(sum6[23]),.Cout(carry6[23]));
	FA fa6_24(.inp1(sum5[23]),.inp2(carry5[22]),.Cin(carry4[42]),.sum(sum6[24]),.Cout(carry6[24]));
	FA fa6_25(.inp1(sum5[24]),.inp2(carry5[23]),.Cin(PP[12][14]),.sum(sum6[25]),.Cout(carry6[25]));
	FA fa6_26(.inp1(PP[14][13]),.inp2(carry5[24]),.Cin(PP[13][14]),.sum(sum6[26]),.Cout(carry6[26]));

	//Final addition
	HA ha17_1(.inp1(PP[1][0]),.inp2(PP[0][1]),.sum(sum7[1]),.Cout(carry7[1]));
	FA fa7_2(.inp1(sum6[1]),.inp2(PP[0][2]),.Cin(carry7[1]),.sum(sum7[2]),.Cout(carry7[2]));
	FA fa7_3(.inp1(sum6[2]),.inp2(carry6[1]),.Cin(carry7[2]),.sum(sum7[3]),.Cout(carry7[3]));
	BrentKung16 bk1(.inp1(sum6[18:3]),.inp2(carry6[17:2]),.Cin(carry7[3]),.sum(sum7[19:4]),.Cout(carry7[4]));
	BrentKung8 bk2(.inp1(sum6[26:19]),.inp2(carry6[25:18]),.Cin(carry7[4]),.sum(sum7[27:20]),.Cout(carry7[5]));
	FA fa7_4(.inp1(PP[14][14]),.inp2(carry6[26]),.Cin(carry7[5]),.sum(sum7[28]),.Cout(carry7[6]));

	assign sum7[0]=PP[0][0];
	assign P[29]=carry7[6];
	assign P[28:0]=sum7[28:0];
	assign P[30]=a[15]^b[15];
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
	//Module 16 bit BrentKung adder//
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
	module sum_calculation16(a_i,b_i,c_i,Sum);
	input [15:0] a_i;
	input [15:0] b_i;
	input [15:0] c_i;
	output [15:0] Sum;
	assign Sum=a_i ^ b_i ^ c_i;
endmodule
/*******************Brent Kung *************************/
module BrentKung16(inp1,inp2,Cin,sum,Cout);
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
	sum_calculation16 S (inp1,inp2,c,sum);
endmodule

	//Module 8 bit BrentKung adder//

/******************* sum calculation *************************/
module sum_calculation8(a_i,b_i,c_i,Sum);
	input [7:0] a_i;
	input [7:0] b_i;
	input [7:0] c_i;
	output [7:0] Sum;
	assign Sum=a_i ^ b_i ^ c_i;
endmodule
/*******************Brent Kung *************************/
module BrentKung8(inp1,inp2,Cin,sum,Cout);
	input[7:0] inp1,inp2;
	input Cin;
	output[7:0] sum;
	output Cout;
	wire[7:0] G1,P1,c;
	wire[3:0] G2,P2;
	wire[1:0] G3,P3;
	wire G4,P4;
	genvar j;
	generate 
		for(j=0;j<8;j=j+1) begin : x0
			assign G1[j]=inp1[j] & inp2[j];
			assign P1[j]=inp1[j] ^ inp2[j];
		end
	endgenerate
	/*******************G and P calculation *************************/
	genvar i;
	generate 
	for(i=0;i<4;i=i+1) begin : x1
	P_G GP1 (G1[2*i+1],G1[2*i],P1[2*i+1],P1[2*i],G2[i],P2[i]);
	end
	for(i=0;i<2;i=i+1)begin :x2
	P_G GP2 (G2[2*i+1],G2[2*i],P2[2*i+1],P2[2*i],G3[i],P3[i]);
	end
	endgenerate
	P_G GP4 (G3[1],G3[0],P3[1],P3[0],G4,P4);

	/*******************Carry calculation *************************/
	assign c[0]=Cin;
	assign c[1]=G1[0]|P1[0] & c[0];
	assign c[2]=G2[0]|P2[0] & c[0];
	assign c[4]=G3[0]|P3[0] & c[0];
	assign Cout=G4|P4 & c[0];
	//assign Cout=G5|P5 & c[0];
	//C_odd C3,C5,C7
	generate 
	for(i=1;i<4;i=i+1) begin :x4
		carry_out C_odd(G1[2*i],P1[2*i],c[2*i],c[2*i+1]);
	end
	endgenerate
	//C6
	generate 
	for(i=1;i<2;i=i+1) begin :x5
		carry_out C_6_10_14(G2[2*i],P2[2*i],c[4*i],c[4*i+2]);
	end
	endgenerate

	sum_calculation8 S (inp1,inp2,c,sum);
endmodule

//**************************************************************************************************************//
//**************************************************ADDER**************************************************//
//**************************************************************************************************************//
module adder31(a,b,s);
	input [30:0] a,b;
	output [30:0] s;
	
	reg [29:0]adder_inp1,adder_inp2;
	reg adder_Cin,Twos_adder_Cin;
	wire cout;
	wire Twos_cout;
	
	wire [31:0] adder_inp1_32,adder_inp2_32;
	wire [31:0] sum_32,Twos_sum_32;
	
	reg [29:0] Twos_inp1;
	reg [30:0] reg_s;
	reg [31:0] Twos_inp2_32;
	wire [31:0] Twos_inp1_32;
	
	
	
	always @ (*)
	begin
		if (a[30]==b[30]) begin
			adder_inp1<=a[29:0];
			adder_inp2<=b[29:0];
			adder_Cin <= 1'b0;
		end
		else begin
			if (a[30]==0 && b[30]==1) begin
				adder_inp1<=a[29:0];
				adder_inp2<=~b[29:0];
				adder_Cin <= 1'b1;
			end
			else begin
				adder_inp1<=~a[29:0];
				adder_inp2<=b[29:0];
				adder_Cin <= 1'b1;
		   end
	   end
	    Twos_inp1 <=~sum_32[29:0];
		Twos_inp2_32 <=32'd0;
		Twos_adder_Cin <=1'b1;
	   if(a[30]==b[30]) begin
			reg_s [30] <= a[30];
			reg_s [29:0] <=sum_32[29:0];
		end
		else begin
			
			if(sum_32[30]==1) begin
				reg_s [30] <= 1'b0;
				reg_s [29:0] <=sum_32[29:0];
			end
			else begin
				reg_s [30] <= 1'b1;
				reg_s [29:0] <=Twos_sum_32[29:0];
			end
		end
	end
	
	
	
	
	assign s=reg_s;
	assign adder_inp1_32={2'b00,adder_inp1};
	assign adder_inp2_32={2'b00,adder_inp2};
	
	assign Twos_inp1_32={2'b00,Twos_inp1};
    BrentKung32 bk10(.inp1(adder_inp1_32),.inp2(adder_inp1_32),.Cin(adder_Cin),.sum(sum_32),.Cout(cout));	
	BrentKung32 bk11(.inp1(Twos_inp1_32),.inp2(Twos_inp2_32),.Cin(Twos_adder_Cin),.sum(Twos_sum_32),.Cout(Twos_cout));	
	
endmodule	
	
	
	/******************* sum calculation *************************/
module sum_calculation32(a_i,b_i,c_i,Sum);
	input [31:0] a_i;
	input [31:0] b_i;
	input [31:0] c_i;
	output [31:0] Sum;
	assign Sum=a_i ^ b_i ^ c_i;
endmodule
	/*******************Brent Kung *************************/
module BrentKung32(inp1,inp2,Cin,sum,Cout);
	input[31:0] inp1,inp2;
	input Cin;
	output[31:0] sum;
	output Cout;
	wire[31:0] G1,P1,c;
	wire[15:0] G2,P2;
	wire[7:0] G3,P3;
	wire[4:0] G4,P4;
	wire[1:0]G5,P5;
	wire     G6,P6;
	genvar j;
	generate 
		for(j=0;j<32;j=j+1) begin : x0
			assign G1[j]=inp1[j] & inp2[j];
			assign P1[j]=inp1[j] ^ inp2[j];
		end
	endgenerate
	/*******************G and P calculation *************************/
	genvar i;
	generate 
	for(i=0;i<16;i=i+1) begin : x1
	P_G GP1 (G1[2*i+1],G1[2*i],P1[2*i+1],P1[2*i],G2[i],P2[i]);
	end
	for(i=0;i<8;i=i+1)begin :x2
	P_G GP2 (G2[2*i+1],G2[2*i],P2[2*i+1],P2[2*i],G3[i],P3[i]);
	end
	for(i=0;i<4;i=i+1) begin :x3
	P_G GP3 (G3[2*i+1],G3[2*i],P3[2*i+1],P3[2*i],G4[i],P4[i]);
	end
	for(i=0;i<2;i=i+1) begin :x4
	P_G GP4 (G4[2*i+1],G4[2*i],P4[2*i+1],P4[2*i],G5[i],P5[i]);
	end
	endgenerate
	P_G GP5 (G5[1],G5[0],P5[1],P5[0],G6,P6);

	/*******************Carry calculation *************************/
	assign c[0]=Cin;
	assign c[1]=G1[0]|P1[0] & c[0];
	assign c[2]=G2[0]|P2[0] & c[0];
	assign c[4]=G3[0]|P3[0] & c[0];
	assign c[8]=G4[0]|P4[0] & c[0];
	assign c[16]=G5[0]|P5[0] & c[0];
	assign Cout=G6|P6 & c[0];
	//C_odd C3,C5,C7,C9,C11,C13,C15,C17,C19,C21,C23,C25,C27,C29,C31
	generate 
	for(i=1;i<16;i=i+1) begin :x10
		carry_out C_odd(G1[2*i],P1[2*i],c[2*i],c[2*i+1]);
	end
	endgenerate
	//C6,C10,C14,C18,C22,C26,C30
	generate 
	for(i=1;i<8;i=i+1) begin :x5
		carry_out C_1(G2[2*i],P2[2*i],c[4*i],c[4*i+2]);
	end
	endgenerate
	//C12,C20,C28
	generate 
	for(i=1;i<4;i=i+1) begin :x6
		carry_out C_2(G3[2*i],P3[2*i],c[8*i],c[8*i+4]);
	end
	endgenerate
	//C24
	carry_out C_3(G4[2],P4[2],c[16],c[24]);
	sum_calculation32 S (inp1,inp2,c,sum);
endmodule



