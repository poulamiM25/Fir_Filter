`timescale 1 us/ 1 ns
module float_point_adder(
        en,
		  input_a,
        input_b,
        clk,
        rst,
        output_sum,
		  out_avl
        );
	
	 input     en;
    input     [9:0] input_a, input_b;
	 input     clk,rst;
    output    [9:0] output_sum;
	 output    out_avl;

    reg       [3:0] state, next_state;
	 reg reg_out_avl;

    parameter   wait_for_inputs = 4'd0,
					 get_inputs    = 4'd1,
					 unbias_exponent_a = 4'd2,
					 unbias_exponent_b = 4'd3,
                special_cases = 4'd4,
                normalise_a   = 4'd5,
                normalise_b   = 4'd6,
                compare_and_shift = 4'd7,
                add_sub_mantissas = 4'd8,
                normalise_mantissa = 4'd9,
                normalise_1 = 4'd10,
                normalise_2 = 4'd11,
                pack = 4'd12; 
	
		

    reg [9:0] sum;
    reg [4:0] a_m, b_m, sum_m;
    reg [4:0] a_e, b_e, sum_e, a_0_a_e, a_0_b_e;
	 reg a_0_cin;
	 reg [4:0] a_bias_exp, b_bias_exp;
    reg a_s, b_s, sum_s;
    reg [5:0] asm_signed_m1, asm_signed_m2;
    reg [4:0] cas_shifted_m1, cas_shifted_m2, cas_new_e;
    reg [6:0] asm_signed_mantissa_sum;
	 
    wire [4:0] w_cas_shifted_m1, w_cas_shifted_m2, w_cas_new_e;
    wire [6:0] w_asm_signed_mantissa_sum;
	 wire [4:0] w_add;


    always @(*)
    begin
        case(state)
		      
				default : next_state <= wait_for_inputs;
				
				wait_for_inputs:
				begin
//				reg_out_avl <= 1'b0;
				if (en) begin
					sum <= 10'd0;
					a_m <= 5'd0;
               b_m <= 5'd0;
					sum_m <= 5'd0;
					a_e <= 5'd0;
               b_e <= 5'd0;
					sum_e <= 5'd0;
					a_bias_exp <= 5'd0;
               b_bias_exp <= 5'd0;
					a_s <= 1'b0;
               b_s <= 1'b0;
					sum_s <= 1'b0;
					asm_signed_m1 <= 6'd0;
					asm_signed_m2 <= 6'd0;
					cas_shifted_m1 <= 5'd0;
					cas_shifted_m2 <= 5'd0;
					cas_new_e <= 5'd0;
					asm_signed_mantissa_sum <= 7'd0;
					next_state <= get_inputs;
				end
				else
					next_state <= wait_for_inputs;
				end

            get_inputs:
            begin
				    reg_out_avl <= 1'b0;
                a_s <= input_a[9];
                b_s <= input_b[9];
            
                a_m <= input_a[3:0];
                b_m <= input_b[3:0];
                
					 a_bias_exp <= input_a[8:4];
                b_bias_exp <= input_b[8:4];
                
					 //a_e <= input_a[8:4] - 5'd15;
                //b_e <= input_b[8:4] - 5'd15;
					 
					 next_state <= unbias_exponent_a;
            end
				
				unbias_exponent_a:
				begin
//					a_e <= input_a[8:4] - 5'd15;
					a_0_a_e <= input_a[8:4];
               a_0_b_e <= 5'b10001; //2's complement of 15
               a_0_cin <= 1'b0;
					a_e <= w_add;
					next_state <= unbias_exponent_b;
				end
				
				unbias_exponent_b:
				begin
//             b_e <= input_b[8:4] - 5'd15;
					a_0_a_e <= input_b[8:4];
               a_0_b_e <= 5'b10001; //2's complement of 15
               a_0_cin <= 1'b0;
					b_e <= w_add;
					next_state <= special_cases;
				end

            special_cases:
            begin
                //if a is NaN or b is NaN return NaN 
                if ((a_e == 16 && a_m != 0) || (b_e == 16 && b_m != 0)) begin
                    sum[9] <= 1;
                    sum[8:4] <= 31;
                    sum[3] <= 1;
                    sum[2:0] <= 0;
                    next_state <= wait_for_inputs;
						  reg_out_avl <= 1'b1;
                end
                //if a is inf or b is inf return +inf
                else if ((a_e == 16 && a_m == 0) || (b_e == 16 && b_m == 0)) begin
                    sum[9] <= 0;
                    sum[8:4] <= 31;
                    sum[3:0] <= 0;
                    next_state <= wait_for_inputs;
						  reg_out_avl <= 1'b1;
                end
                //if a is zero return b
                else if ((a_bias_exp == 0) && (a_m == 0)) begin
                    sum <= input_b;
                    next_state <= wait_for_inputs;
						  reg_out_avl <= 1'b1;
                end 
                //if b is zero return a
                else if ((b_bias_exp == 0) && (a_m == 0)) begin
                    sum <= input_a;
                    next_state <= wait_for_inputs;
						  reg_out_avl <= 1'b1;
                end
                else begin
                    //Denormalised Number a
                    if (a_bias_exp == 0) begin
                        a_e <= -5'd14;
                    end 
                    else begin
                        a_m[4] <= 1;
                    end
                    //Denormalised Number b
                    if (b_bias_exp == 0) begin
                        b_e <= -5'd14;
                    end 
                    else begin
                        b_m[4] <= 1;
                    end
                    next_state <= normalise_a;
                end
            end

            normalise_a:
            begin
                if (a_m[4]) begin
                    next_state <= normalise_b;
                end 
                else if (a_m[3:0] != 4'b0000) begin
                    a_m <= {a_m[3:0],1'b0};
//                    a_e <= a_e - 5'd1; to do this
						  a_0_a_e = a_e;
						  a_0_b_e = 5'b11111; //2's complement of 1
                    a_0_cin = 1'b0;
					     a_e = w_add;
                end
					 else
						next_state <= normalise_b;
            end


            normalise_b:
            begin
                if (b_m[4]) begin
                    next_state <= compare_and_shift;
                end 
                else if (b_m[3:0] != 4'b0000) begin
                    b_m <= {b_m[3:0],1'b0};
//                    b_e <= b_e - 5'd1;
						  a_0_a_e = b_e;
						  a_0_b_e = 5'b11111; //2's complement of 1
						  a_0_cin = 1'b0;
						  b_e = w_add;
                end
					 else
						next_state <= compare_and_shift;
            end

            compare_and_shift:
            begin 
					  cas_shifted_m1 <= w_cas_shifted_m1;
					  cas_shifted_m2 <= w_cas_shifted_m2;
					  cas_new_e <= w_cas_new_e; 
					  next_state <= add_sub_mantissas;
            end

            add_sub_mantissas:
            begin 
                asm_signed_m1 <= {a_s,cas_shifted_m1};
                asm_signed_m2 <= {b_s,cas_shifted_m2};
                asm_signed_mantissa_sum <= w_asm_signed_mantissa_sum; 
                next_state <= normalise_mantissa;
            end

            normalise_mantissa:
            begin 
                sum_s <= asm_signed_mantissa_sum[6];
                if (asm_signed_mantissa_sum[5]) begin //if carry(6th bit) is present
                    sum_m <= asm_signed_mantissa_sum[5:1]; //right shift mantissa
                    sum_e <= cas_new_e + 5'b1; //add 1 to exponent
                end
                else begin //if carry(6th bit) is 0
                    sum_m <= asm_signed_mantissa_sum[4:0];
                    sum_e <= cas_new_e;
                end 
                next_state <= normalise_1;
            end
            
            normalise_1:
            begin 
                if (sum_m[4] == 0) begin
                    sum_m <= sum_m << 1;
						  //sum_e <= sum_e - 5'd1;
						  a_0_a_e = sum_e;
						  a_0_b_e = 5'b11111; //2's complement of 1
						  a_0_cin = 1'b0;
						  sum_e = w_add;
                end 
                else begin
                    next_state <= normalise_2;
                end 
            end

            normalise_2:
            begin 
                if (sum_e < 0) begin
                    sum_m <= sum_m >> 1;
						  //sum_e <= sum_e + 5'd1;
						  a_0_a_e = sum_e;
						  a_0_b_e = 5'b00001; //1
						  a_0_cin = 1'b0;
						  sum_e = w_add;
                end 
                else begin
                    next_state <= pack;
                end 
            end

            pack:
            begin 
                sum[9] <= sum_s;
                sum[8:4] <= sum_e;
                sum[3:0] <= sum_m[3:0];
                if (sum_e == 0 && sum_m[4] == 0) begin //denormalised, so exponent will be 0
                    sum[8:4] <= 0;
                end
                //if overflow occurs, return inf
                if ($signed(sum_e) > 15) begin
                    sum[9] <= sum_s;
                    sum[8:4] <= 31;
                    sum[3:0] <= 0;    
                end
                next_state <= wait_for_inputs; 
					 reg_out_avl <= 1'b1; 
//					 sum <= input_a + input_b;
//					 next_state <= wait_for_inputs;
            end
        endcase
    end //always block

    assign output_sum = sum;
	 assign out_avl = reg_out_avl;
	 
	 always @(posedge clk) begin
		if (rst) 
			state <= wait_for_inputs;
		else
			state <= next_state;
	end

    flptadder_compare_and_shift cas (.m1(a_m), .m2(b_m), .e1(a_bias_exp), .e2(b_bias_exp),
						   .shifted_m1(w_cas_shifted_m1), .shifted_m2(w_cas_shifted_m2),
						   .new_e(w_cas_new_e));

    flptadder_add_sub_mantissas asm (.signed_m1(asm_signed_m1), .signed_m2(asm_signed_m2),
						   .signed_mantissa_sum(w_asm_signed_mantissa_sum));
							
	 flptmult_fixed_point_adder fxadd1 (.a(a_0_a_e), .b(a_0_b_e), .cin(a_0_cin), .z(w_add));


endmodule



/*
reg [9:0] reg_output_sum;
reg reg_out_avl;

always @ (posedge clk) begin
	if (en) begin
		reg_output_sum <= input_a + input_b;
		reg_out_avl <= 1'b1;
	end
	else begin
		reg_output_sum <= 10'd0;
		reg_out_avl <= 1'b0;
	end
end

assign out_avl = reg_out_avl;
assign output_sum = reg_output_sum;

endmodule
*/