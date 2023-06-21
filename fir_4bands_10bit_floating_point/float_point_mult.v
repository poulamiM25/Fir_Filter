`timescale 1 us/ 1 ns
module float_point_mult(
		  en,
        input_a,
        input_b,
        clk,
        rst,
        output_z,
		  out_avl
        );
	 
	 input     en;
    input     [9:0] input_a, input_b;
	 input     clk,rst;
    output    [9:0] output_z;
	 output 	  out_avl;
    
    reg       [3:0] state, next_state;
	 reg       reg_out_avl;
    
    parameter   wait_for_inputs = 4'd0,
					 get_inputs    = 4'd1,
					 unbias_exponent_a = 4'd2,
					 unbias_exponent_b = 4'd3,
                special_cases = 4'd4,
                normalise_a   = 4'd5,
                normalise_b   = 4'd6,
                multiply      = 4'd7,
                normalise_1   = 4'd8,
                normalise_2   = 4'd9,
                pack          = 4'd10;

    reg [9:0] z;
    reg [4:0] a_m, b_m, z_m, m_0_a_m, m_0_b_m;
    reg [4:0] a_e, b_e, z_e, a_0_a_e, a_0_b_e;
    reg [4:0] a_bias_exp, b_bias_exp;
	 reg a_s, b_s, z_s;
    reg a_0_cin;
    reg [9:0] product; //each mantissa is 5 bit
	 
	 wire [9:0] w_prod;
	 wire [4:0] w_add;

	 
    always @(*)
    begin
        case(state)
				
				default : next_state <= wait_for_inputs;
		  
				wait_for_inputs:
				begin
//				reg_out_avl <= 1'b0;
				if (en) begin
					z <= 10'd0;
					a_s <= 1'b0;
               b_s <= 1'b0;
					z_s <= 1'b0;
					a_0_cin <= 1'b0;
               a_e <= 5'd0;
               b_e <= 5'd0;
					z_e <= 5'd0;
					a_0_a_e <= 5'd0;
					a_0_b_e <= 5'd0;
               a_m <= 5'd0;
               b_m <= 5'd0;
					z_m <= 5'd0;
					m_0_a_m <= 5'd0;
					m_0_b_m <= 5'd0;
               a_bias_exp <= 5'd0;
               b_bias_exp <= 5'd0;
					product <= 10'd0;
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
					 
//					 a_e <= input_a[8:4] - 5'd15;
//                b_e <= input_b[8:4] - 5'd15;
					 
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
                if ((a_bias_exp == 5'd31 && a_m != 0) || (b_bias_exp == 5'd31 && b_m != 0)) begin
                    z[9] <= 1;
                    z[8:4] <= 31;
                    z[3] <= 1;
                    z[2:0] <= 0;
                    next_state <= get_inputs;
						  reg_out_avl <= 1'b1;
                end 
                //if a is inf return inf
                else if (a_bias_exp == 5'd31) begin
                    z[9] <= a_s ^ b_s;
                    z[8:4] <= 31;
                    z[3:0] <= 0;
                    //if b is zero return NaN
                    if ((b_bias_exp == 0) && (b_m == 0)) begin
                        z[9] <= 1;
                        z[8:4] <= 31;
                        z[3] <= 1;
                        z[2:0] <= 0;
                    end
                    next_state <= get_inputs;
						  reg_out_avl <= 1'b1;
                end 
                //if b is inf return inf
                else if (b_bias_exp == 5'd31) begin
                    z[9] <= a_s ^ b_s;
                    z[8:4] <= 31;
                    z[3:0] <= 0;
                    //if a is zero return NaN
                    if ((a_bias_exp == 0) && (a_m == 0)) begin
                        z[9] <= 1;
                        z[8:4] <= 31;
                        z[3] <= 1;
                        z[2:0] <= 0;
                    end
                    next_state <= get_inputs;
						  reg_out_avl <= 1'b1;
                end 
                //if a is zero return zero
                else if ((a_bias_exp == 0) && (a_m == 0)) begin
                    z[9] <= a_s ^ b_s;
                    z[8:4] <= 0;
                    z[3:0] <= 0;
                    next_state <= get_inputs;
						  reg_out_avl <= 1'b1;
                end 
                //if b is zero return zero
                else if ((b_bias_exp == 0) && (b_m == 0)) begin
                    z[9] <= a_s ^ b_s;
                    z[8:4] <= 0;
                    z[3:0] <= 0;
                    next_state <= get_inputs;
						  reg_out_avl <= 1'b1;
                end 
                else begin
                    //Denormalised Number
                    if (a_bias_exp == 0) begin
                        a_e <= -5'd14;
                    end 
                    else begin
                        a_m[4] <= 1;
                    end
                    //Denormalised Number
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
                    next_state <= multiply;
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
						next_state <= multiply;
            end

            multiply:
            begin
                z_s <= a_s ^ b_s;
                //after multiplication 2bits to left of decpt are converted to 1 bit to left of decpt using left shift, so add 1 to exp
                //z_e <= a_e + b_e + 7'd1; 
                a_0_a_e <= a_e;
                a_0_b_e <= b_e;
                a_0_cin <= 1'b1;
                //product <= a_m * b_m;
                m_0_a_m <= a_m;
                m_0_b_m <= b_m;
                // outputs
					 z_e <= w_add;
                z_m <= w_prod[9:5];
                next_state <= normalise_1;
            end

            normalise_1:
            begin
                if (z_m[4] == 0) begin
						  z_m <= z_m << 1;
						  //z_e <= z_e - 5'd1;
						  a_0_a_e = z_e;
						  a_0_b_e = 5'b11111; //2's complement of 1
						  a_0_cin = 1'b0;
						  z_e = w_add;
						  
                end 
                else begin
                    next_state <= normalise_2;
                end
            end

            normalise_2:
            begin
                if ($signed(z_e) < -14) begin
                    z_m <= z_m >> 1;
						  //z_e <= z_e + 5'd1;
                    a_0_a_e = z_e;
						  a_0_b_e = 5'b00001; //1
						  a_0_cin = 1'b0;
						  z_e = w_add;
                end 
                else begin
                    next_state <= pack;
                end
            end

            pack:
            begin
                z[9] <= z_s;
                //z[8:4] <= z_e[4:0] + 5'd15;
					 a_0_a_e = z_e;
					 a_0_b_e <= 5'b01111; //15
					 a_0_cin <= 1'b0;
					 z[8:4] <= w_add;
                z[3:0] <= z_m[3:0];
                if ($signed(z_e) == -14 && z_m[4] == 0) begin //denormalised, so exponent will be 0
                    z[8:4] <= 0;
                end
                //if overflow occurs, return inf
                if ($signed(z_e) > 15) begin
                    z[9] <= z_s;
                    z[8:4] <= 31;
                    z[3:0] <= 0;    
                end
                next_state <= wait_for_inputs;
					 reg_out_avl <= 1'b1;
            end


			endcase


    end
	 
	assign output_z = z;
	assign out_avl = reg_out_avl;
	 
	flptmult_fixed_point_mult fxmul  (.inp1(m_0_a_m), .inp2(m_0_b_m), .product(w_prod));
	 
	flptmult_fixed_point_adder fxadd (.a(a_0_a_e), .b(a_0_b_e), .cin(a_0_cin), .z(w_add));

	always @(posedge clk) begin
		if (rst) 
			state <= wait_for_inputs;
		else
			state <= next_state;
	end	 
	 
endmodule
