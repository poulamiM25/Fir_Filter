module flptadder_compare_and_shift( 
						m1, m2,
						e1, e2,
						shifted_m1, shifted_m2,
						new_e);
input [4:0] m1, m2;
input [4:0] e1, e2;
output [4:0] shifted_m1, shifted_m2;
output [4:0] new_e;

reg [4:0] reg_shifted_m1, reg_shifted_m2;
reg [4:0] reg_new_e;
reg[4:0] diff;

always @(*)
begin
		if (e1==e2)
		begin 
			reg_shifted_m1 <= m1;
			reg_shifted_m2 <= m2;
//			reg_new_e <= e1 + 1'b1; //for normalization
			reg_new_e <= e1;
		end
		
		else if (e1>e2)
		begin 
			diff = e1-e2;
			reg_shifted_m1 <= m1;
			reg_shifted_m2 <= (m2>>diff);
//			reg_new_e <= e1 + 1'b1; //for normalization
			reg_new_e <= e1;
		end

		else if (e2>e1)
		begin 
			diff = e2-e1;
			reg_shifted_m1 <= (m1>>diff);
			reg_shifted_m2 <= m2;
//			reg_new_e <= e2 + 1'b1; //for normalization
			reg_new_e <= e2;
		end
end
	assign shifted_m1 = reg_shifted_m1;
	assign shifted_m2 = reg_shifted_m2;
	assign new_e = reg_new_e;
endmodule
	
	
	
	