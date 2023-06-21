module flptadder_add_sub_mantissas( 
						signed_m1, signed_m2,
						signed_mantissa_sum);

input [5:0] signed_m1, signed_m2;
output [6:0] signed_mantissa_sum; //1 bit sign, 6 bit result mantissa

reg [6:0] reg_signed_mantissa_sum;
reg [4:0] adder_inp1, adder_inp2;
reg adder_cin;
reg [4:0] reg_adder_out_twos_compl;
reg [5:0] adder_out;

reg [4:0] a2_inp1, a2_inp2;
reg a2_cin;


wire [5:0] w_adder_out;
wire [5:0] w_a2_adder_out;

always @(*)
begin
    if (signed_m1[5] == signed_m2[5]) begin
        adder_inp1 <= signed_m1[4:0];
        adder_inp2 <= signed_m2[4:0];
        adder_cin <= 1'b0;
    end
    else begin
        if(signed_m1[5]==0 && signed_m2[5]==1) begin
            adder_inp1 <= signed_m1[4:0];
            adder_inp2 <= ~signed_m2[4:0];
            adder_cin <= 1'b1; 
        end
        if(signed_m1[5]==1 && signed_m2[5]==0) begin
            adder_inp1 <= signed_m2[4:0];
            adder_inp2 <= ~signed_m1[4:0];
            adder_cin <= 1'b1;
        end
    end
    

        adder_out = w_adder_out;
        if (signed_m1[5] == signed_m2[5]) begin 
            reg_signed_mantissa_sum[6] <= signed_m1[5];
            reg_signed_mantissa_sum[5:0] <= adder_out[5:0];
        end
        else begin //signed_m1[5] != signed_m2[5]
            if (adder_out[5]) begin // EAC is 1
                reg_signed_mantissa_sum[6] <= 1'b0; //final result is +ve
                reg_signed_mantissa_sum[5:0] <= {1'b0,adder_out[4:0]};
            end
            else begin // EAC is 0
                reg_signed_mantissa_sum[6] <= 1'b1; //final result is -ve
//                reg_adder_out_twos_compl <= ~adder_out[4:0] + 1'b1;
					 a2_inp1 <= 5'd0;
					 a2_inp2 <= ~adder_out[4:0];
					 a2_cin  <= 1'b1;
					 reg_adder_out_twos_compl = w_a2_adder_out[4:0];
                reg_signed_mantissa_sum[5:0] <= {1'b0,reg_adder_out_twos_compl};
            end
        end
end

assign signed_mantissa_sum = reg_signed_mantissa_sum;
// simple adder, inputs adder_inp1,2 (5bit) and cin, output 6bit
flptadder_asm_fixed_point_adder a1 ( .a(adder_inp1), .b(adder_inp2), .cin(adder_cin), .z(w_adder_out));
flptadder_asm_fixed_point_adder a2 ( .a(a2_inp1), .b(a2_inp2), .cin(a2_cin), .z(w_a2_adder_out));

endmodule
