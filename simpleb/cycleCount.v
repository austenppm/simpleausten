module cycleCount(input clock,reset,ce,
                    output reg [7:0] LEDA,LEDB,
					output reg [3:0] cycle_selectorA,cycle_selectorB);
	reg [31:0] count;
	wire [7:0] LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7;
	sevenSeg a0(.data(count[31:28]),
			.LED(LED0));
	sevenSeg a1(.data(count[27:24]),
			.LED(LED1));
	sevenSeg a2(.data(count[23:20]),
			.LED(LED2));
	sevenSeg a3(.data(count[19:16]),
			.LED(LED3));
	sevenSeg a4(.data(count[15:12]),
			.LED(LED4));
	sevenSeg a5(.data(count[11:8]),
			.LED(LED5));
	sevenSeg a6(.data(count[7:4]),
			.LED(LED6));
	sevenSeg a7(.data(count[3:0]),
			.LED(LED7));
	reg [31:0] selectCount;
	always @(posedge clock)begin
		if(reset == 1'b1) begin
		count <= 32'h00000000;
		cycle_selectorA[0] <= 1'b0;
		cycle_selectorB[0] <= 1'b0;
		end else begin
			if(ce == 1'b1) begin
                count <= count + 1;
            end if(selectCount != 32'h00ffffff) begin
				selectCount <= selectCount+1;
			end else begin
				selectCount <= 32'h00000000;
				if(cycle_selectorA[0] == 1'b0)begin
				cycle_selectorA <= 4'b1101;
				LEDA <= LED1;
				end if(cycle_selectorA[1] == 1'b0)begin
				cycle_selectorA <= 4'b1011;
				LEDA <= LED2;
				end if(cycle_selectorA[2] == 1'b0)begin
				cycle_selectorA <= 4'b0111;
				LEDA <= LED3;
				end if(cycle_selectorA[3] == 1'b0)begin
				cycle_selectorA <= 4'b1110;
				LEDA <= LED0;
				end if(cycle_selectorB[0] == 1'b0)begin
				cycle_selectorB <= 4'b1101;
				LEDB <= LED5;
				end if(cycle_selectorB[1] == 1'b0)begin
				cycle_selectorB <= 4'b1011;
				LEDB <= LED6;
				end if(cycle_selectorB[2] == 1'b0)begin
				cycle_selectorB <= 4'b0111;
				LEDB <= LED7;
				end if(cycle_selectorB[3] == 1'b0)begin
				cycle_selectorB <= 4'b1110;
				LEDB <= LED4;
				end
			end
		end
	end
endmodule
