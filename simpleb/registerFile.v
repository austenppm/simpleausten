module registerFile(input clock,reset,regWren,
							input [2:0] addrA,addrB,wraddr,
							input [15:0] wrdata,
							output reg [15:0] ar,br);
	reg [15:0] r[7:0];	
	//Writing to the register file(LD)	
	always @(negedge clock) begin
		if(reset == 1'b 1)begin
			r[0] <=16'h0000;
			r[1] <=16'h0000;
			r[2] <=16'h0000;
			r[3] <=16'h0000;
			r[4] <=16'h0000;
			r[5] <=16'h0000;
			r[6] <=16'h0000;
			r[7] <=16'h0000;
		end else begin
			if(regWren == 1'b 1)begin
					r[wraddr] <= wrdata;
			end
		end
	end
	//Reading the register file(ST)
	always @(*) begin
			ar <= r[addrA];
			br <= r[addrB];
	end
endmodule
