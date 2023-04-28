module sevenSeg (
	input [3:0] data,
	output [7:0] LED,
	output selector);
	
	function [7:0] dec;
	input [3:0] din;
	begin
		case (din)
			0:dec = 8'b 11111100;
			1:dec = 8'b 01100000;
			2:dec = 8'b 11011010;
			3:dec = 8'b 11110010;
			4:dec = 8'b 01100110;
			5:dec = 8'b 10110110;
			6:dec = 8'b 10111110;
			7:dec = 8'b 11100000;
			8:dec = 8'b 11111110;
			9:dec = 8'b 11110110;
			10:dec = 8'b 11101110;
			11:dec = 8'b 00111110;
			12:dec = 8'b 00011010;
			13:dec = 8'b 01111010;
			14:dec = 8'b 10011110;
			15:dec = 8'b 10001110;
			default : dec = 8'b 11111111;
		endcase
	end
	endfunction
	
	assign LED = dec(data);
	assign selector = 1'b0;
endmodule
