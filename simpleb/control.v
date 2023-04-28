module control(input clock,reset,exec,s,z,c,v,
				input [15:4] inst,
				output reg branchFlag,ar_ir,alu_shif,data_input,dr_mdr,regWren,memWren,memRead,outputEnable,systemStopped,alu_shif_ar,regDstB_A,
				// output reg br_pc,pc_dr,
				output reg [3:0] opcode);
	wire [1:0] op1 = inst[15:14];
	wire [2:0] op2 = inst[13:11];
	wire [3:0] op3 = inst[7:4];
	wire [2:0] cond = inst[10:8];
	//Exec chattering removal
	reg [15:0] count;
	reg exec_pre;
	reg inCount;
	always @(posedge clock) begin
		if(reset == 1'b1)begin
			count <= 0;
			systemStopped <= 1'b1;
			exec_pre <= exec;
		end else begin
			//INはp3の縛りを入れないと、再開後も止まってしまう。パイプライン化後はp2の時のみsystemStoppedが1になる（勝手にp2の縛りが入る）
			//p4で止める
			// if(((p3 == 1'b1)&(op1 == 2'b11)&(op3 == 4'b1100)&(systemStopped == 1'b0))|((op1 == 2'b11)&(op3 == 4'b1111)&(systemStopped == 1'b0)))begin//IN or HLT
			if((op1 == 2'b11)&(op3 == 4'b1100)&(systemStopped == 1'b0))begin//IN
				if(inCount == 1'b0)begin
					inCount <= 1'b1;
				end	
			end	if(inCount == 1'b1)begin//IN
					systemStopped <= 1'b1;
					inCount <= 1'b0;
			end	if((op1 == 2'b11)&(op3 == 4'b1111)&(systemStopped == 1'b0))begin//HLT
				systemStopped <=1'b1;
			end else begin
				exec_pre <= exec;
				if(count == 0)begin
					if(exec_pre !=  exec)begin
						count <= 1;
					end
				end else if(count == 7)begin
					count <= 0;
					if(exec_pre & exec)begin
						systemStopped <= ~systemStopped;
					end
				end else begin
					if(exec_pre == exec)begin
						count <= count + 1;
					end else begin
						count <= 0;
					end
				end
			end
		end
	end
	always @(*) begin
		if(reset == 1'b 1) begin
			branchFlag <= 1'b 0;
			ar_ir  <= 1'b 0;
			alu_shif  <= 1'b 0;
			alu_shif_ar <=1'b0;
			data_input <= 1'b 0;
			dr_mdr <= 1'b 0;
			regDstB_A <= 1'b 0;
			regWren <= 1'b 0;
			memWren <= 1'b 0;
			memRead <= 1'b 0;
			opcode <= 4'b 1110;//nop
			outputEnable <= 1'b 0;
		end else begin
			branchFlag <= 1'b 0;
			ar_ir  <= 1'b 0;
			alu_shif  <= 1'b 0;
			alu_shif_ar <= 1'b0;
			data_input <= 1'b 0;
			dr_mdr <= 1'b 0;
			regDstB_A <= 1'b 0;
			regWren <= 1'b 0;
			memWren <= 1'b 0;
			memRead <= 1'b 0;
			opcode <= 4'b 1110;//nop
			outputEnable <= 1'b 0;
			case(op1)
				2'b10:begin
					case(op2)
						3'b000:begin//LI
							regWren <= 1'b 1;//p5
							opcode <= 4'b0110;//MOV//p3
							ar_ir  <= 1'b 1;//p3
						end	
						3'b001:begin//ADDI
							regWren <= 1'b 1;//p5
							opcode <= 4'b0000;//ADD//p3
							ar_ir  <= 1'b 1;//p3
						end	
						3'b100:begin//Bd
							branchFlag <= 1'b 1;//branch instruction//p5だけど、コントロールから直に入れる。
						end
						3'b111:begin//BE,BLT,BLE,BNE
							case(cond)
								3'b000:begin
									if(z == 1'b 1) begin//BE
										branchFlag <= 1'b 1;//p5だけど、コントロールから直に入れる。
									end
								end
								3'b001:begin
									if(s^v == 1'b 1) begin
										branchFlag <= 1'b 1;//p5だけど、コントロールから直に入れる。
									end
								end
								3'b010:begin//BLE
									if(z == 1'b 1 || s^v == 1'b 1) begin
										branchFlag <= 1'b 1;//p5だけど、コントロールから直に入れる。
									end
								end
								3'b011:begin
									if(z == 1'b 0)begin
										branchFlag <= 1'b 1;//p5だけど、コントロールから直に入れる。
									end
								end
								3'b100:begin
									if(c == 1'b 0)begin
										branchFlag <= 1'b 1;//p5だけど、コントロールから直に入れる。
									end
								end
								default:begin
								end
							endcase
						end
						default:begin
						end
					endcase
				end
				2'b11:begin
					opcode <= op3;//p3
					if(op3[3:2] == 2'b10)begin//shift命令
						alu_shif  <= 1'b 1;//p3//コントロールから直も
						regWren <= 1'b 1;//p5//シフト演算は全て演算結果レジスタ書き込み
					end if(op3 == 4'b1100)begin//IN命令レジスタ書き込み
						dr_mdr <= 1'b 1;//p5
						regWren <= 1'b 1;//p5
						data_input <= 1'b 1;//p4(data_input)
					end if(op3 == 4'b1101)begin//OUT
						alu_shif_ar <=1'b1;//コントロールから直
						outputEnable <= 1'b 1;//p3
						opcode <=4'b0110;//MOV//p3
					end if(op3[3] == 1'b0)begin//ALUを用いた演算
						if(op3[2:0] != 3'b101)begin//CMP以外のALUを用いた演算でレジスタ書き込み
							regWren <= 1'b 1;//p5
						end
					end
				end
				2'b00:begin//LD
					memRead <= 1'b 1;//p3(この命令はロードの時だけ)
					dr_mdr <= 1'b 1;//p5(dr_mdr,regDstB_A,regWren)
					regDstB_A <= 1'b 1;//p5
					regWren <= 1'b 1;//p5
					opcode <= 4'b0000;//ADD//p3
					ar_ir <= 1;//p3
				end
				2'b01:begin//ST
					alu_shif_ar <=1'b1;//コントロールから直
					opcode <=4'b0000;//ADD//p3(memRead,opcode,ar_ir,outputEnable,alu_shif)
					ar_ir <=1;//p3
					memWren <= 1'b 1;//p3_4(memWren)
				end
				default:begin
				end
			endcase
		end 
	end
endmodule
