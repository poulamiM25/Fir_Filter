module delay_element (
  input wire clk, clr, 
  input wire [30:0] delay_in,
  output wire [30:0] delay_out
);
	reg [30:0] reg_delay_out;
	always @(posedge clk) begin
		if (clr==1)
			reg_delay_out <= 0;
		else
			reg_delay_out <= delay_in;
	end

	assign delay_out = reg_delay_out;
endmodule