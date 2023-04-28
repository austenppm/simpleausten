module HazardDetectionUnit(input [2:0] RegRs,RegRt,p3_RegRa,p3_RegRd,p4_data_input_3,//p3_RegRa=ar_addr
                    input p3_memRead,branchFlag,
				    output reg pcWren,irWren,irFlush,p3_RegFlush);//p3_Reg=ar,br,control3,ir3
    always @(*) begin
        pcWren <= 1'b1;
        irWren <= 1'b1;
        irFlush <= 1'b0;
        p3_RegFlush <= 1'b0;
        if((p3_memRead == 1'b1) & ((p3_RegRa == RegRs) | (p3_RegRa == RegRt)) ) begin//LD→ADD,p3_memRead == 1'b1(ロード命令ならば)
            pcWren <= 1'b0;
            irWren <= 1'b0;
            p3_RegFlush <= 1'b1;
        end if((p4_data_input_3 == 1'b1) & ((p3_RegRd == RegRs) | (p3_RegRd == RegRt)) ) begin//IN命令ならばp3レジスタをフラッシュさせずに残す。
            pcWren <= 1'b0;
            irWren <= 1'b0;
            p3_RegFlush <= 1'b1;
        end if(branchFlag == 1'b1) begin//分岐ハザード
            irFlush <= 1'b1;
        end
    end
endmodule