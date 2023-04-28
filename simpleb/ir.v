module ir(input clock,reset,ce,//changeEnable
			input [15:0] value,
			output reg [15:0] ir);
	always @(posedge clock) begin 
		if(reset == 1'b 1)begin
		ir <= 16'b1100_0000_1110_0000;//nop
		end else begin
			if(ce == 1'b1)begin
				ir <= value;
			end
		end
	end
endmodule
