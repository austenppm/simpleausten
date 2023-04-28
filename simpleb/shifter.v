module shifter(
	input [3:0] opcode,d,
    input [15:0] in,
    output [15:0] out,
    output s,z,c,v
    );

wire shiftc;

function [16:0] calculate; 
input [3:0] opcode;
input [15:0] in; // r[Rd]
input [3:0] d;
begin 
	case (opcode)
	 8:  calculate = in << d; // shift left logical (sll)
	 9:  calculate = slr(in, d); // shift left rotate
	 10: calculate = in >> d; // shift right logical (srl)
	 11: calculate = sra(in, d); // shift right arithmetic
     default: calculate = 17'b0;
	 endcase
end 
endfunction
wire [31:0] shifted_double_in;
assign shifted_double_in = {in, in} << d;
function [16:0] slr; // shift left rotate(modified by Moeka)
input [0:15] in;
input [0:3] d;
	slr = shifted_double_in[31:16];
endfunction

function [16:0] sra; // shift right arithmetic
input [15:0] in;
input [0:3] d;
case (d)
	1: sra = {in[15], in[15:1]};
	2: sra = {{2{in[15]}}, in[15:2]};
	3: sra = {{3{in[15]}}, in[15:3]};
	4: sra = {{4{in[15]}}, in[15:4]};
	5: sra = {{5{in[15]}}, in[15:5]};
	6: sra = {{6{in[15]}}, in[15:6]};
	7: sra = {{7{in[15]}}, in[15:7]};
	default: sra = in;
endcase
endfunction

function shiftout;
input [3:0] opcode, d;
input [15:0] in;
case(opcode)
	8:case (d)
		1: shiftout = in[15];
		2: shiftout = in[14];
		3: shiftout = in[13];
		4: shiftout = in[12];
		5: shiftout = in[11];
		6: shiftout = in[10];
		7: shiftout = in[9];
		default: shiftout = 0;
	  endcase
	 9: shiftout = 0;
	10, 11:case (d)
		1: shiftout = in[0];
		2: shiftout = in[1];
		3: shiftout = in[2];
		4: shiftout = in[3];
		5: shiftout = in[4];
		6: shiftout = in[5];
		7: shiftout = in[6];
		default: shiftout = 0;
	endcase
endcase 
endfunction

assign out = calculate(opcode , in , d);

assign z = (out == 16'b0)? 1:0;

// overflow
assign v = 0;

assign c = shiftout(opcode, in, d);
						
assign s = out[15];
endmodule
