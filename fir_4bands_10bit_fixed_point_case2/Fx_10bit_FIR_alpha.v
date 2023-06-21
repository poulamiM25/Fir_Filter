module Fx_10bit_FIR_alpha(
//  input wire clk_slow,rst,en,
input wire clk_slow,rst,
  input wire [9:0] fir_in,
  output wire [9:0] fir_out
);
	parameter ORDER = 30;
	wire [9:0] multi_delay;
	wire [9:0] multi_add [0:ORDER-2];
	wire [9:0] delay_add [0:ORDER-2];
	wire [9:0] add_delay [0:ORDER-3];
  
//	wire [9:0] w_fir_out;
	wire [9:0] coefficients [0:ORDER-1];
//   reg [9:0] reg_fir_in;
//   wire [9:0] wire_fir_in;

    assign coefficients[0] = 10'b0000000000;
    assign coefficients[1] = 10'b0000000001;
    assign coefficients[2] = 10'b0000000000;
    assign coefficients[3] = 10'b1000000010;
    assign coefficients[4] = 10'b0000000000;
    assign coefficients[5] = 10'b0000000011;
    assign coefficients[6] = 10'b0000000000;
    assign coefficients[7] = 10'b0000000010;
    assign coefficients[8] = 10'b1000000001;
    assign coefficients[9] = 10'b1000010000;
    assign coefficients[10] = 10'b0000001100;
    assign coefficients[11] = 10'b0000100010;
    assign coefficients[12] = 10'b1000011100;
    assign coefficients[13] = 10'b1000101110;
    assign coefficients[14] = 10'b0000101011;
    assign coefficients[15] = 10'b0000101011;
    assign coefficients[16] = 10'b1000101110;
    assign coefficients[17] = 10'b1000011100;
    assign coefficients[18] = 10'b0000100010;
    assign coefficients[19] = 10'b0000001100;
    assign coefficients[20] = 10'b1000010000;
    assign coefficients[21] = 10'b1000000001;
    assign coefficients[22] = 10'b0000000010;
    assign coefficients[23] = 10'b0000000000;
    assign coefficients[24] = 10'b0000000011;
    assign coefficients[25] = 10'b0000000000;
    assign coefficients[26] = 10'b1000000010;
    assign coefficients[27] = 10'b0000000000;
    assign coefficients[28] = 10'b0000000001;
    assign coefficients[29] = 10'b0000000000;


	
	
//	assign fir_out[9:0] = w_fir_out[18:9];
	
	// multiply blocks
	genvar i;
	generate
		for (i=0; i<=ORDER-1; i=i+1) begin : mult_gen
			if (i==ORDER-1)
				Fx_10bit_Multiplier last_mult(.input1(coefficients[i]),.input2(fir_in),.Product(multi_delay));
			else
				Fx_10bit_Multiplier inter_mult(.input1(coefficients[i]),.input2(fir_in),.Product(multi_add[i]));
	end
	endgenerate
	
	
	// delay generation blocks
	genvar j;
	generate
		for (j=0; j<=ORDER-2; j=j+1) begin : delay_gen
			if (j==ORDER-2)
				delay_element last_delay (.clk(clk_slow), .clr(rst), .delay_in(multi_delay), .delay_out(delay_add[j]));
			else
				delay_element inter_delay (.clk(clk_slow), .clr(rst), .delay_in(add_delay[j]), .delay_out(delay_add[j]));
		end
	endgenerate
	
	// adder blocks
	genvar k;
	generate
		for (k=0; k<=ORDER-2; k=k+1) begin : adder_gen
			if (k==0)
			   Fx_10bit_adder adder0(.a(multi_add[k]),.b(delay_add[k]),.s(fir_out));
			else
				Fx_10bit_adder inter_add(.a(multi_add[k]),.b(delay_add[k]),.s(add_delay[k-1]));
		end
	endgenerate

endmodule
