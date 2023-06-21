//module flptmult_fixed_point_adder (a, b, cin, z);
//
//input [4:0] a; 
//input [4:0] b;
//input cin; 
//output [4:0] z;
//
//	assign z = a+b+cin;
//
//endmodule



module flptmult_fixed_point_adder (a, b, cin, z);

input [4:0] a; 
input [4:0] b;
input cin; 
output [4:0] z;

wire [3:0] carry;
wire cout;


full_adder fa1 (a[0],b[0],cin,     z[0],carry[0]);
full_adder fa2 (a[1],b[1],carry[0],z[1],carry[1]);
full_adder fa3 (a[2],b[2],carry[1],z[2],carry[2]);
full_adder fa4 (a[3],b[3],carry[2],z[3],carry[3]);
full_adder fa5 (a[4],b[4],carry[3],z[4],cout);

endmodule


module half_adder(x,y,s,c);
   input x,y;
   output s,c;
   assign s=x^y;
   assign c=x&y;
endmodule

module full_adder(x,y,c_in,s,c_out);
   input x,y,c_in;
   output s,c_out;
 assign s = (x^y) ^ c_in;
 assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule
