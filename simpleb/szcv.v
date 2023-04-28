module szcv(input clock,reset,s,z,c,v,ce,
			output reg [3:0] szcv);//szcv[3]=s,szcv[2]=z,szcv[1]=c,szcv[0]=v
	always @(posedge clock)begin
		if(reset == 1'b 1)begin
			szcv <= 4'h0;
		end else begin
			if(ce == 1'b 1)begin
			szcv[3] <= s;
			szcv[2] <= z;
			szcv[1] <= c;
			szcv[0] <= v;
			end
		end
	end
endmodule
