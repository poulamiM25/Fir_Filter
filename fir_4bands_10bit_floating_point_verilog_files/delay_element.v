`timescale 1 us/ 1 ns
module delay_element (
  input wire clk, clr,LdD, //clr in always?
  input wire [9:0] delay_in,
  output wire [9:0] delay_out
//  output wire out_avl
);
	reg [9:0] reg_delay_out;
	reg reg_out_avl;
	
	always @(posedge clk, negedge clr) begin
		if (clr==0)
			reg_delay_out <= 0;
		else if (LdD)
			reg_delay_out <= delay_in;
//			reg_out_avl <= 1'b1;
	end

	assign delay_out = reg_delay_out;
//	assign out_avl = reg_out_avl;
endmodule