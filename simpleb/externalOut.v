// module externalOut(input [15:0] ar,reset,
// 					input clock,outputEnable,ce,
// 					output [7:0] LED0_res,LED1_res,LED2_res,LED3_res,
// 					output reg [7:0] LED4,LED5,LED6,LED7,
// 					output selector,cycle_selector);
// 	reg [15:0] out;
// 	always @(posedge clock)begin
// 		if(outputEnable == 1'b1)
// 		out <= ar;
// 	end
// 	reg[7:0] LED0_pos,LED1_pos,LED2_pos,LED3_pos;
// 	sevenSeg a0(.data(out[15:12]),
// 			.LED(LED0_pos));
// 	sevenSeg a1(.data(out[11:8]),
// 			.LED(LED1_pos));
// 	sevenSeg a2(.data(out[7:4]),
// 			.LED(LED2_pos));
// 	sevenSeg a3(.data(out[3:0]),
// 			.LED(LED3_pos));
// 		assign selector = ~clock;
// 	reg [31:0] count;
// 	always @(posedge clock)begin
// 		if(reset == 1'b1)
// 		count <= 32'h00000000;
//         else begin
//             if(ce == 1'b1) begin
//                 count <= count + 1;
//             end
//         end
//     end
// 	assign cycle_selector = clock;
// 	reg[7:0] LED0_neg,LED1_neg,LED2_neg,LED3_neg;
// 	sevenSeg b0(.data(count[31:28]),
// 			.LED(LED0_neg));
// 	sevenSeg b1(.data(count[27:24]),
// 			.LED(LED1_neg));
// 	sevenSeg b2(.data(count[23:20]),
// 			.LED(LED2_neg));
// 	sevenSeg b3(.data(count[19:16]),
// 			.LED(LED3_neg));
// 	assign LED0_res=(clock==1'b1) ? LED0_pos:LED0_neg;
// 	assign LED1_res=(clock==1'b1) ? LED1_pos:LED1_neg;
// 	assign LED2_res=(clock==1'b1) ? LED2_pos:LED2_neg;
// 	assign LED3_res=(clock==1'b1) ? LED3_pos:LED3_neg;
// 	sevenSeg b4(.data(count[15:12]),
// 			.LED(LED4));
// 	sevenSeg b5(.data(count[11:8]),
// 			.LED(LED5));
// 	sevenSeg b6(.data(count[7:4]),
// 			.LED(LED6));
// 	sevenSeg b7(.data(count[3:0]),
// 			.LED(LED7));
// endmodule
module externalOut(input [15:0] ar,
					input clock,outputEnable,
					output reg [7:0] LED0,LED1,LED2,LED3,
					output selector);
	reg [15:0] out;
	always @(posedge clock)begin
		if(outputEnable == 1'b1)
		out <= ar;
	end
	sevenSeg a0(.data(out[15:12]),
			.LED(LED0));
	sevenSeg a1(.data(out[11:8]),
			.LED(LED1));
	sevenSeg a2(.data(out[7:4]),
			.LED(LED2));
	sevenSeg a3(.data(out[3:0]),
			.LED(LED3));
		assign selector = 1'b1;
// 		assign selector = ~clock;
endmodule