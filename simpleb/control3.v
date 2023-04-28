module control3(input clock,reset,ce,//changeEnable
                input memRead,ar_ir,outputEnable,alu_shif,alu_shif_ar,memWren,data_input,regDstB_A,dr_mdr,regWren,
                input [3:0] opcode,
                output reg p3_memRead,p3_ar_ir,p3_outputEnable,p3_alu_shif,p3_alu_shif_ar,p3_4_memWren,p4_data_input,p5_regDstB_A,p5_dr_mdr,p5_regWren,
                output reg [3:0] p3_opcode);
    always @(posedge clock) begin 
		if(reset == 1'b 1)begin
		p3_memRead <= 1'b0;//nop
        p3_opcode <= 4'b0000;
        p3_ar_ir <= 1'b0;
        p3_outputEnable <= 1'b0;
        p3_alu_shif <= 1'b0;
        p3_alu_shif_ar <= 1'b0;
        p3_4_memWren <= 1'b0;
        p4_data_input <= 1'b0;
        p5_regDstB_A <= 1'b0;
        p5_dr_mdr <= 1'b0;
        p5_regWren <= 1'b0;
		end else begin
			if(ce == 1'b1)begin
				p3_memRead <= memRead;
                p3_opcode <= opcode;
                p3_ar_ir <= ar_ir;
                p3_outputEnable <= outputEnable;
                p3_alu_shif <= alu_shif;
                p3_alu_shif_ar <= alu_shif_ar;
                p3_4_memWren <= memWren;
                p4_data_input <= data_input;
                p5_regDstB_A <= regDstB_A;
                p5_dr_mdr <= dr_mdr;
                p5_regWren <= regWren;
			end
		end
	end
endmodule