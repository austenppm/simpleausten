module ForwardingUnit(input [2:0] RegRs,RegRt,p3_RegRd,p4_RegRd,
                    input p3_RegWren,p4_RegWren,
				    output [1:0] FwdA,FwdB);
//組み合わせ回路で
//FwdA,FwdBはともにデフォルトの値が2'b00
//p3_RegWren&&p3_RegRd==RegRsならば、FwdAを2'b10
//p4_RegWren&&p4_RegRd==RegRsならば、FwdAを2'b01
//p3_RegWren&&p3_RegRd==RegRtならば、FwdBを2'b10
//p4_RegWren&&p4_RegRd==RegRtならば、FwdBを2'b01
assign FwdA[1] = p3_RegWren&(p3_RegRd==RegRs);
assign FwdA[0] = p4_RegWren&(p4_RegRd==RegRs);
assign FwdB[1] = p3_RegWren&(p3_RegRd==RegRt);
//二回以上連続で一個前にフォワーディングするときに、FwdB=2'b11になってしまう。
assign FwdB[0] = ~FwdB[1]&p4_RegWren&(p4_RegRd==RegRt);
endmodule