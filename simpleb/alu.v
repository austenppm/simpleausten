module alu(
	input [15:0] ina,
	input [15:0] inb,
	input [3:0] opcode,

	output [15:0] out, 
	output s,z,c,v ); // s = sign, z = zero, c = cancel, v = overflow
	
wire [16:0] calcAns;

//main function
function [16:0] calculate; 
input [3:0] opcode;
input [15:0] ina; // r[Rd]
input [15:0] inb; // r[Rs]

begin 
	case (opcode)
	 0:  calculate = ina + inb; // arithmetic add
         1:  calculate = inb - ina; // arithmetic subtract(modified by Moeka)
         2:  calculate = ina & inb; // logic AND
         3:  calculate = ina | inb; // logic OR
	 4:  calculate = ina ^ inb; // logic XOR
	 5:  calculate = inb - ina; // compared? not write to register
	 6:  calculate = ina; // move operation 

	 default: calculate = 17'b0;
	 endcase
end 
endfunction

assign calcAns = calculate(opcode, ina, inb);

assign out = calcAns[15:0];

assign z = (out == 16'b0)? 1:0;

// overflow
assign v = (((opcode == 4'b0000) && ((~ina[15] & ~inb[15] & out[15]) || (ina[15] & inb[15] & ~out[15]))) 
					  || (((opcode == 4'b0001)||(opcode == 4'b0101)) && ((ina[15] & ~inb[15] & out[15]) || (~ina[15] & inb[15] & ~out[15]))));

assign c = (calcAns[16] && (opcode == 0 || opcode == 1 || opcode == 5));
						
assign s = out[15];

endmodule
