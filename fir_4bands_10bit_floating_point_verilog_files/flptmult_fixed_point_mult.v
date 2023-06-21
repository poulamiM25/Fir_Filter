//module flptmult_fixed_point_mult (a, b, z);
//
//input [4:0] a; 
//input [4:0] b; 
//output [9:0] z;
//
//	assign z = a*b;
//
//endmodule


//5 bit Dadda multiplier
module flptmult_fixed_point_mult (inp1,inp2,product);

input [4:0] inp1; 
input [4:0] inp2; 
output [9:0] product;

wire PP [0:4][4:0];
wire [0:1] sum1,carry1;
wire [0:3] sum2,carry2;
wire [0:5] sum3,carry3;
wire [0:9] carry4;

genvar i;
genvar j;
generate 
    for(i=0;i<5;i=i+1) begin :x
        for (j=0;j<5;j=j+1)begin:y
            assign PP[i][j]=inp1[j] & inp2[i];
        end
    end
endgenerate
//Reduction 4,3,2
//Reduction from 5 wires to 4
HA H1(.inp1(PP[4][0]),.inp2(PP[3][1]),.sum(sum1[0]),.Cout(carry1[0]));
HA H2(.inp1(PP[4][1]),.inp2(PP[3][2]),.sum(sum1[1]),.Cout(carry1[1]));

//Reduction from 4 wires to 3
HA H3(.inp1(PP[3][0]),.inp2(PP[2][1]),.sum(sum2[0]),.Cout(carry2[0]));
FA F1(.inp1(sum1[0]),.inp2(PP[2][2]),.Cin(PP[1][3]),.sum(sum2[1]),.Cout(carry2[1]));
FA F2(.inp1(sum1[1]),.inp2(carry1[0]),.Cin(PP[2][3]),.sum(sum2[2]),.Cout(carry2[2]));
FA F3(.inp1(PP[4][2]),.inp2(carry1[1]),.Cin(PP[3][3]),.sum(sum2[3]),.Cout(carry2[3]));

//Reduction from 3 wires to 2
HA H4(.inp1(PP[2][0]),.inp2(PP[1][1]),.sum(sum3[0]),.Cout(carry3[0]));
FA F4(.inp1(sum2[0]),.inp2(PP[1][2]),.Cin(PP[0][3]),.sum(sum3[1]),.Cout(carry3[1]));
FA F5(.inp1(sum2[1]),.inp2(carry2[0]),.Cin(PP[0][4]),.sum(sum3[2]),.Cout(carry3[2]));
FA F6(.inp1(sum2[2]),.inp2(carry2[1]),.Cin(PP[1][4]),.sum(sum3[3]),.Cout(carry3[3]));
FA F7(.inp1(sum2[3]),.inp2(carry2[2]),.Cin(PP[2][4]),.sum(sum3[4]),.Cout(carry3[4]));
FA F8(.inp1(PP[4][3]),.inp2(carry2[3]),.Cin(PP[3][4]),.sum(sum3[5]),.Cout(carry3[5]));
//Final addition
HA H5(.inp1(PP[1][0]),.inp2(PP[0][1]),.sum(product[1]),.Cout(carry4[0]));
FA F9(.inp1(sum3[0]),.inp2(carry4[0]),.Cin(PP[0][2]),.sum(product[2]),.Cout(carry4[1]));
FA F10(.inp1(sum3[1]),.inp2(carry3[0]),.Cin(carry4[1]),.sum(product[3]),.Cout(carry4[2]));
FA F11(.inp1(sum3[2]),.inp2(carry3[1]),.Cin(carry4[2]),.sum(product[4]),.Cout(carry4[3]));
FA F12(.inp1(sum3[3]),.inp2(carry3[2]),.Cin(carry4[3]),.sum(product[5]),.Cout(carry4[4]));
FA F13(.inp1(sum3[4]),.inp2(carry3[3]),.Cin(carry4[4]),.sum(product[6]),.Cout(carry4[5]));
FA F14(.inp1(sum3[5]),.inp2(carry3[4]),.Cin(carry4[5]),.sum(product[7]),.Cout(carry4[6]));
FA F15(.inp1(PP[4][4]),.inp2(carry3[5]),.Cin(carry4[6]),.sum(product[8]),.Cout(carry4[7]));

assign product[0]=PP[0][0];
assign product[9]=carry4[7];

endmodule

///////////////////////////////////////////////////////
module FA(inp1,inp2,Cin,sum,Cout);
input inp1,inp2,Cin;
output sum,Cout;

assign sum=inp1^inp2^Cin;
assign Cout=(inp1&inp2)|(inp1&Cin)|(inp2&Cin);

endmodule
///////////////////////////////////////////////////////

module HA(inp1,inp2,sum,Cout);
input inp1,inp2;
output sum,Cout;

assign sum=inp1^inp2;
assign Cout=inp1&inp2;

endmodule


