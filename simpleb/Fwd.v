module Fwd(input clock,reset,ce,//changeEnable
			input [1:0] value,
			output reg [1:0] register);
	always @(posedge clock) begin 
		if(reset == 1'b 1)begin
		register <= 2'b00;
		end else begin
			if(ce == 1'b1)begin
				register <= value;
			end
		end
	end
endmodule