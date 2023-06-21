module Fx_16bit_FIR_delta(
//  input wire clk_slow,rst,en,
input wire clk_slow,rst,
  input wire [15:0] fir_in,
  output wire [15:0] fir_out
);
	parameter ORDER = 30;
	wire [15:0] multi_delay;
	wire [15:0] multi_add [0:ORDER-2];
	wire [15:0] delay_add [0:ORDER-2];
	wire [15:0] add_delay [0:ORDER-3];
  
//	wire [15:0] w_fir_out;
	wire [15:0] coefficients [0:ORDER-1];
//   reg [9:0] reg_fir_in;
//   wire [9:0] wire_fir_in;

    assign coefficients[0] = 16'b0000000000000000;
    assign coefficients[1] = 16'b0000000000000000;
    assign coefficients[2] = 16'b0000000000000000;
    assign coefficients[3] = 16'b0000000001000000;
    assign coefficients[4] = 16'b0000000010000000;
    assign coefficients[5] = 16'b1000000001000000;
    assign coefficients[6] = 16'b1000000011000000;
    assign coefficients[7] = 16'b0000000000000000;
    assign coefficients[8] = 16'b0000000111000000;
    assign coefficients[9] = 16'b0000000111000000;
    assign coefficients[10] = 16'b1000000111000000;
    assign coefficients[11] = 16'b1000010011000000;
    assign coefficients[12] = 16'b0000000000000000;
    assign coefficients[13] = 16'b0000110010000000;
    assign coefficients[14] = 16'b0001011111000000;
    assign coefficients[15] = 16'b0001011111000000;
    assign coefficients[16] = 16'b0000110010000000;
    assign coefficients[17] = 16'b0000000000000000;
    assign coefficients[18] = 16'b1000010011000000;
    assign coefficients[19] = 16'b1000000111000000;
    assign coefficients[20] = 16'b0000000111000000;
    assign coefficients[21] = 16'b0000000111000000;
    assign coefficients[22] = 16'b0000000000000000;
    assign coefficients[23] = 16'b1000000011000000;
    assign coefficients[24] = 16'b1000000001000000;
    assign coefficients[25] = 16'b0000000010000000;
    assign coefficients[26] = 16'b0000000001000000;
    assign coefficients[27] = 16'b0000000000000000;
    assign coefficients[28] = 16'b0000000000000000;
    assign coefficients[29] = 16'b0000000000000000;


	
	
//	assign fir_out[15:0] = w_fir_out[30:15];
	
	// multiply blocks
	genvar i;
	generate
		for (i=0; i<=ORDER-1; i=i+1) begin : mult_gen
			if (i==ORDER-1)
				Fx_16_MAC last_mult(.a(coefficients[i]),.b(fir_in),.P(multi_delay));
			else
				Fx_16_MAC inter_mult(.a(coefficients[i]),.b(fir_in),.P(multi_add[i]));
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
			   adder16 adder0(.a(multi_add[k]),.b(delay_add[k]),.s(fir_out));
			else
				adder16 inter_add(.a(multi_add[k]),.b(delay_add[k]),.s(add_delay[k-1]));
		end
	endgenerate

endmodule
