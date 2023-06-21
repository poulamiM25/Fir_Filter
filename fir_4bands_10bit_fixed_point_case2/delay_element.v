module delay_element (
  input wire clk, clr, //clr in always?
  input wire [9:0] delay_in,
  output wire [9:0] delay_out
);
	reg [9:0] reg_delay_out;
	always @(posedge clk) begin
		if (clr==1)
			reg_delay_out <= 0;
		else
			reg_delay_out <= delay_in;
	end

	assign delay_out = reg_delay_out;
endmodule