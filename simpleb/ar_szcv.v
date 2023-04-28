module ar_szcv(
    input [15:0] ar,
	output s,z,c,v );
assign z = (ar == 16'h0)? 1:0;

// overflow
assign v = 0;
assign c = 0;
						
assign s = ar[15];

endmodule
 