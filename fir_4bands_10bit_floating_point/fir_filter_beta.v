`timescale 1 us/ 1 ns
module fir_filter_beta (
  input wire clk_fast, rst, en, clr,
  input wire [9:0] fir_in,
  output wire [9:0] fir_out,
  output wire fir_out_avl
);
	parameter ORDER = 30;
	wire [9:0] multi_delay;
	wire [9:0] multi_add [0:ORDER-2];
	wire [9:0] delay_add [0:ORDER-2];
	wire [9:0] add_delay [0:ORDER-3];
	
	reg [2:0] state, next_state = 3'd5;
  
	wire [9:0] adder0_out;
	wire [9:0] coefficients [0:ORDER-1]; 
	wire [0:ORDER-1] mult_out_avl; 
	wire [0:ORDER-2] add_out_avl;
	
	reg LdM, LdD, LdA;
	reg [9:0] reg_fir_out;
	
	parameter   START = 3'd0,
					WAIT_FOR_MULT = 3'd1,
               DELAY = 3'd2,
               ACTIVATE_ADD = 3'd3,
               WAIT_FOR_ADD = 3'd4,
               DONE = 3'd5;
	
//	always @(posedge clk_slow) begin
//		next_state <= START;
//	end	

	always @(posedge clk_fast) begin
		state <= next_state;
	end
	
	always @(*) begin
		case(state)
			default : 
			begin	
				next_state <= DONE;
				LdM <= 1'b0; 
				LdD <= 1'b0; 
				LdA <= 1'b0;
			end
			
			START :
			begin
				LdM <= 1'b0;
				next_state <= WAIT_FOR_MULT;
			end
			
			WAIT_FOR_MULT:
			begin
				if (& mult_out_avl) begin
					next_state <= DELAY;
					LdD <= 1'b1; 
				end
				else
					next_state <= WAIT_FOR_MULT;
			end
			
			DELAY:
			begin
				LdD <= 1'b0;
				LdA <= 1'b1;
				next_state <= ACTIVATE_ADD;
			end
			
			ACTIVATE_ADD:
			begin
				LdA <= 1'b0;
				next_state <= WAIT_FOR_ADD;
			end
			
			WAIT_FOR_ADD:
			begin
				if (& add_out_avl)
					next_state <= DONE;
				else
					next_state <= WAIT_FOR_ADD;
			end
			
			DONE:
			begin
				if (en) begin
					next_state <= START;
					LdM <= 1'b1;
				end
				else begin
					next_state <= DONE;
					LdM <= 1'b0; 
					LdD <= 1'b0; 
					LdA <= 1'b0;
				end
			end
			
		endcase
	end
	
    assign coefficients[0] = 10'b1001000111;
    assign coefficients[1] = 10'b1001010011;
    assign coefficients[2] = 10'b1001101100;
    assign coefficients[3] = 10'b0010000000;
    assign coefficients[4] = 10'b0001110001;
    assign coefficients[5] = 10'b1001010011;
    assign coefficients[6] = 10'b0001101111;
    assign coefficients[7] = 10'b1010100101;
    assign coefficients[8] = 10'b0001010010;
    assign coefficients[9] = 10'b0010100101;
    assign coefficients[10] = 10'b0001101111;
    assign coefficients[11] = 10'b0010111011;
    assign coefficients[12] = 10'b1010111100;
    assign coefficients[13] = 10'b1011010010;
    assign coefficients[14] = 10'b0011010001;
    assign coefficients[15] = 10'b0011010001;
    assign coefficients[16] = 10'b1011010010;
    assign coefficients[17] = 10'b1010111100;
    assign coefficients[18] = 10'b0010111011;
    assign coefficients[19] = 10'b0001101111;
    assign coefficients[20] = 10'b0010100101;
    assign coefficients[21] = 10'b0001010010;
    assign coefficients[22] = 10'b1010100101;
    assign coefficients[23] = 10'b0001101111;
    assign coefficients[24] = 10'b1001010011;
    assign coefficients[25] = 10'b0001110001;
    assign coefficients[26] = 10'b0010000000;
    assign coefficients[27] = 10'b1001101100;
    assign coefficients[28] = 10'b1001010011;
    assign coefficients[29] = 10'b1001000111;


	
	
	
	
	// multiply blocks
	genvar i;
	generate
		for (i=0; i<=ORDER-1; i=i+1) begin : mult_gen
			if (i==ORDER-1)
				float_point_mult last_mult (.en(LdM),.input_a(coefficients[i]), .input_b(fir_in), .clk(clk_fast), .rst(rst), .output_z(multi_delay), .out_avl(mult_out_avl[i]));
			else
				float_point_mult inter_mult (.en(LdM),.input_a(coefficients[i]), .input_b(fir_in), .clk(clk_fast), .rst(rst), .output_z(multi_add[i]), .out_avl(mult_out_avl[i]));
		end
	endgenerate
	
	
	// delay generation blocks
	genvar j;
	generate
		for (j=0; j<=ORDER-2; j=j+1) begin : delay_gen
			if (j==ORDER-2)
				delay_element last_delay (.clk(clk_fast), .clr(clr),.LdD(LdD), .delay_in(multi_delay), .delay_out(delay_add[j]));
			else
				delay_element inter_delay (.clk(clk_fast), .clr(clr),.LdD(LdD), .delay_in(add_delay[j]), .delay_out(delay_add[j]));
		end
	endgenerate
	
	// adder blocks
	genvar k;
	generate
		for (k=0; k<=ORDER-2; k=k+1) begin : adder_gen
			if (k==0)
				float_point_adder adder0 (.en(LdA), .input_a(multi_add[k]), .input_b(delay_add[k]), .clk(clk_fast), .rst(rst), .output_sum(adder0_out),.out_avl(add_out_avl[k]));
			else
				float_point_adder inter_add (.en(LdA), .input_a(multi_add[k]), .input_b(delay_add[k]), .clk(clk_fast), .rst(rst), .output_sum(add_delay[k-1]),.out_avl(add_out_avl[k]));
		end
	endgenerate

  assign fir_out_avl = add_out_avl[0];
  
  always @ (posedge fir_out_avl) begin
      reg_fir_out <= adder0_out;
  end
	
  assign fir_out = reg_fir_out;
  
endmodule