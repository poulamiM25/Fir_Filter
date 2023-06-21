`timescale 1 us/ 1 ns
module fir_filter_fx10_bit_topmodule (
						input wire [9:0] signal_in,  
						input wire clk_slow, rst,
						output wire [9:0] signal_out_delta, signal_out_theta, signal_out_alpha, signal_out_beta
						);

	Fx_10bit_FIR_delta fir_delta (.clk_slow(clk_slow), .rst(rst), .fir_in(signal_in), .fir_out(signal_out_delta));
	
	Fx_10bit_FIR_theta fir_theta (.clk_slow(clk_slow), .rst(rst), .fir_in(signal_in), .fir_out(signal_out_theta));
	
	Fx_10bit_FIR_alpha fir_alpha (.clk_slow(clk_slow), .rst(rst), .fir_in(signal_in), .fir_out(signal_out_alpha));
	
	Fx_10bit_FIR_beta fir_beta (.clk_slow(clk_slow), .rst(rst), .fir_in(signal_in), .fir_out(signal_out_beta));
											
endmodule
						