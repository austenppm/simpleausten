module REG(input clock,reset,ce,//changeEnable
			input [15:0] value,
			output reg [15:0] register);
	always @(posedge clock) begin 
		if(reset == 1'b 1)begin
		register <= 0;
		end else begin
			if(ce == 1'b1)begin
				register <= value;
			end
		end
	end
endmodule
