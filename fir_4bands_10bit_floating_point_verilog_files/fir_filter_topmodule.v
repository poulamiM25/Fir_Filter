`timescale 1 us/ 1 ns
module fir_filter_topmodule (
						input wire [9:0] signal_in,  
						input wire clk_slow, clk_fast, rst, en, clr,
						output wire [9:0] signal_out_delta, signal_out_theta, signal_out_alpha, signal_out_beta,
						output wire delta_out_avl, theta_out_avl, alpha_out_avl, beta_out_avl
						);

	fir_filter_delta fir_delta (.clk_fast(clk_fast), .rst(rst) , .en(en), .clr(clr), .fir_in(signal_in), .fir_out(signal_out_delta), .fir_out_avl(delta_out_avl));
	
	fir_filter_theta fir_theta (.clk_fast(clk_fast), .rst(rst) , .en(en), .clr(clr), .fir_in(signal_in), .fir_out(signal_out_theta), .fir_out_avl(theta_out_avl));
	
	fir_filter_alpha fir_alpha (.clk_fast(clk_fast), .rst(rst) , .en(en), .clr(clr), .fir_in(signal_in), .fir_out(signal_out_alpha), .fir_out_avl(alpha_out_avl));
	
	fir_filter_beta fir_beta (.clk_fast(clk_fast), .rst(rst) , .en(en), .clr(clr), .fir_in(signal_in), .fir_out(signal_out_beta), .fir_out_avl(beta_out_avl));
	
	

						
						
endmodule
						