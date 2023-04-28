module ar_mdr_szcv(
    input [15:0] ar,
	input [15:0] mdr, 
	input ar_mdr, 
	output s,z,c,v );
    wire [15:0] which_ar_mdr;
    assign which_ar_mdr =(ar_mdr==1'b0)?ar:mdr;
assign z = (which_ar_mdr == 16'b0)? 1:0;

// overflow
assign v = 0;
assign c = 0;
						
assign s = which_ar_mdr[15];

endmodule
 