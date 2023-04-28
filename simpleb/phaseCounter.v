module phaseCounter(input clock,reset,ce,//changeEnable
					output reg p1,p2,p3,p3_4,p4,p5);
	reg p1_master,p2_master,p3_master,p5_master;

	always @(posedge clock) begin
		if(reset == 1'b1)begin
				p1_master <= 1;
				p2_master <= 0;
				p3_master <= 0;
				p3_4 <= 0;
				p5_master <= 0;
		end else begin
			if(ce == 1'b1)begin
			p1_master <= p5;
			p2_master <= p1;
			p3_master <= p2;
			p3_4 <= p3;
			p5_master <= p4;
			end
		end
	end
	always @(negedge clock) begin
		p1 <=p1_master;
		p2 <=p2_master;
		p3 <=p3_master;
		p4 <=p3_4;
		p5 <=p5_master;
	end
endmodule
