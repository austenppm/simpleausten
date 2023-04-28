module simpleb(input init_clock,Reset,Exec,
// module simpleb(input clock,Reset,Exec,
                input [15:0] in,
                output [7:0] LED0,LED1,LED2,LED3,
                output [7:0] count_LEDA,count_LEDB,
                output [3:0] cycle_selectorA,cycle_selectorB,
		output Clk,selector,systemStopped0,DR_MDR5,REGwren5,MEMread3,PCw,BF);
                // output [3:0] op3,
                // output [2:0] WRa,Rd3,Rd4,
                // output [1:0] fwdA,fwdB,
                // output [15:0] inst0,ins3,PC,AR,AR_4,BR,ARSource,MEMQ,ALUAR,ALUBR,ALUARS,DR,MDR,WRd,Ja);
        wire reset,exec;
        wire s,z,c,v;
        wire pcWren,irWren,irFlush,p3_RegFlush;
        wire [1:0] FwdA,FwdB,FwdA3,FwdB3;
        wire memRead,p3_memRead,p4_memRead,ar_ir,p3_ar_ir,outputEnable,p3_outputEnable,alu_shif,p3_alu_shif;
        wire memWren,p3_4_memWren,p3_4_memWren_3;
        wire data_input,p4_data_input,p4_data_input_3;
        wire regWren,p5_regWren_3,p5_regWren_4,p5_regWren,regDstB_A,p5_regDstB_A_3,p5_regDstB_A_4,p5_regDstB_A,dr_mdr,p5_dr_mdr_3,p5_dr_mdr_4,p5_dr_mdr;
        wire branchFlag,systemStopped,alu_shif_ar,p3_alu_shif_ar;
        wire [2:0] wraddr;
        wire [15:0] aluSourceAR_src;
        wire [15:0] pc,pcPlusOne,pcPlusOne2,jumpAddr,ir,ir3,ir4,ir5,ar,ar4,br,dr,dr5,mdr;
        wire [15:0] q,memQ,aluResult,shifterResult,irSource,aluSourceAR,aluSourceBR,arSource,brSource,drSource,mdr_dataSource,mdr_inputSource,mdrSource,wrdata;
        wire [3:0] szcv,opcode,p3_opcode;
        reg reset0,reset1,exec0,exec1;

        assign inst0 = ir;
        assign ins3=ir3;
        assign systemStopped0 = systemStopped;
        assign PC = pc;
        assign AR=ar;
        assign AR_4=ar4;
        assign BR=br;
        assign ARSource=arSource;
        assign MEMQ=memQ;
        assign ALUAR=aluSourceAR;
        assign ALUBR=aluSourceBR;
        assign ALUARS=aluSourceAR_src;
        assign DR=dr;
        assign MDR=mdr;
        // assign fwdA=FwdA;
        // assign fwdB=FwdB;
        assign WRd=wrdata;
        assign WRa=wraddr;
        assign DR_MDR5=p5_dr_mdr;
        assign REGwren5=p5_regWren;
        assign MEMread3=p3_memRead;
        assign Rd3=p3_RegRd;
        assign Rd4=p4_RegRd;
        // assign op3=p3_opcode;
        assign Ja=jumpAddr;
        assign PCw=pcWren;
        assign BF=branchFlag;
	assign Clk=clock;

        PLL PLL0(.inclk0(init_clock),
                .c0(clock));

        always @(posedge clock)begin
                reset0 <= Reset;
                reset1 <= reset0;
                exec0 <= Exec;
                exec1 <= exec0;
        end
        
        assign reset = ~reset1;
        assign exec = ~exec1;

        cycleCount cycleCount0(.clock(clock),.reset(reset),.ce(~systemStopped),
                                .LEDA(count_LEDA),.LEDB(count_LEDB),.cycle_selectorA(cycle_selectorA),.cycle_selectorB(cycle_selectorB));
        
        pc pc0(.clock(clock),.reset(reset),.branchFlag(branchFlag),.dr(jumpAddr),.ce(~systemStopped&pcWren),
                .pc(pc),.pcPlusOne(pcPlusOne));
        instructionMemory instructionMemory0(.address(pc[11:0]),.clock(~clock),
                                                .q(q));
        ir ir0(.clock(clock),.reset(reset|irFlush),.value(q),.ce(~systemStopped&irWren),
                .ir(ir));
        REG pc2(.clock(clock),.reset(reset|irFlush),.value(pcPlusOne),.ce(~systemStopped),
                .register(pcPlusOne2));
        control control0(.clock(clock),.reset(reset),.exec(exec),.s(szcv[3]),.z(szcv[2]),.c(szcv[1]),.v(szcv[0]),.inst(ir[15:4]),
                        .branchFlag(branchFlag),.ar_ir(ar_ir),.alu_shif(alu_shif),.data_input(data_input),.dr_mdr(dr_mdr),.regWren(regWren),.memWren(memWren),.memRead(memRead),.opcode(opcode),.outputEnable(outputEnable),.systemStopped(systemStopped),.alu_shif_ar(alu_shif_ar),.regDstB_A(regDstB_A));
        wire [15:0] sign_ext_d;
        assign sign_ext_d ={{8{ir[7]}},ir[7:0]};
        adder16 jumpAddressCalucurator(.pc2(pcPlusOne2),.sign_ext_d(sign_ext_d),
                                        .jumpAddr(jumpAddr));
        HazardDetectionUnit HazardDetectionUnit0(.RegRs(ir[13:11]),.RegRt(ir[10:8]),.p3_RegRa(ir3[13:11]),.p3_RegRd(ir3[10:8]),.p3_memRead(p3_memRead),.p4_data_input_3(p4_data_input_3),.branchFlag(branchFlag),//ir3[13:11]はロード先//ロードかIN命令で
                                                .pcWren(pcWren),.irWren(irWren),.irFlush(irFlush),.p3_RegFlush(p3_RegFlush));
        wire [2:0] p3_RegRd,p4_RegRd;
        assign p3_RegRd = (p3_memRead == 1'b0) ? ir3[10:8]:ir3[13:11];//ロード命令以外ならir3[10:8]、ロード命令ならir3[13:11]
        assign p4_RegRd = (p4_memRead == 1'b0) ? ir4[10:8]:ir4[13:11];
        ForwardingUnit ForwardingUnit0(.RegRs(ir[13:11]),.RegRt(ir[10:8]),.p3_RegRd(p3_RegRd),.p4_RegRd(p4_RegRd),.p3_RegWren(p5_regWren_3),.p4_RegWren(p5_regWren_4),
                                        .FwdA(FwdA),.FwdB(FwdB));
        registerFile registerFile0(.clock(clock),.reset(reset),.regWren(p5_regWren),.wraddr(wraddr),.addrA(ir[13:11]),.addrB(ir[10:8]),.wrdata(wrdata),
                                .ar(arSource),.br(brSource));
        control3 control3(.clock(clock),.reset(reset|p3_RegFlush),.ce(~systemStopped),.memRead(memRead),.opcode(opcode),.ar_ir(ar_ir),.outputEnable(outputEnable),.alu_shif(alu_shif),.alu_shif_ar(alu_shif_ar),.memWren(memWren),.data_input(data_input),.regDstB_A(regDstB_A),.dr_mdr(dr_mdr),.regWren(regWren),
                        .p3_memRead(p3_memRead),.p3_opcode(p3_opcode),.p3_ar_ir(p3_ar_ir),.p3_outputEnable(p3_outputEnable),.p3_alu_shif(p3_alu_shif),.p3_alu_shif_ar(p3_alu_shif_ar),.p3_4_memWren(p3_4_memWren_3),.p4_data_input(p4_data_input_3),.p5_regDstB_A(p5_regDstB_A_3),.p5_dr_mdr(p5_dr_mdr_3),.p5_regWren(p5_regWren_3));
        control3 control3_4(.clock(~clock),.reset(reset),.ce(~systemStopped),.memWren(p3_4_memWren_3),
                        .p3_4_memWren(p3_4_memWren));
        REG ar0(.clock(clock),.reset(reset|p3_RegFlush),.value(arSource),.ce(~systemStopped),
                .register(ar));
        REG br0(.clock(clock),.reset(reset|p3_RegFlush),.value(brSource),.ce(~systemStopped),
                .register(br));
        // externalOut externalOut0(.ar(ar),.clock(clock),.reset(reset),.ce(~systemStopped),.outputEnable(p3_outputEnable),
        //                         .LED0_res(LED0),.LED1_res(LED1),.LED2_res(LED2),.LED3_res(LED3),.LED4(LED4),.LED5(LED5),.LED6(LED6),.LED7(LED7),.cycle_selector(cycle_selector),.selector(selector));
        externalOut externalOut0(.ar(ar),.clock(clock),.outputEnable(p3_outputEnable),
                                .LED0(LED0),.LED1(LED1),.LED2(LED2),.LED3(LED3),.selector(selector));
        Fwd FWD_A3(.clock(clock),.reset(reset|p3_RegFlush),.value(FwdA),.ce(~systemStopped),
                .register(FwdA3));
        Fwd FWD_B3(.clock(clock),.reset(reset|p3_RegFlush),.value(FwdB),.ce(~systemStopped),
                .register(FwdB3));        
        // multiplexer br_pc0(.a(br),.b(pcPlusOne),.signal(br_pc),
        //                 .result(aluSourceBR));
        assign aluSourceBR = (FwdB3==2'b00)?br:
                                (FwdB3==2'b10)?dr:wrdata;
        wire [15:0] sign_ext_d3;
        ir IR3(.clock(clock),.reset(reset|p3_RegFlush),.value(ir),.ce(~systemStopped),
                .ir(ir3));
        assign aluSourceAR_src = (FwdA3==2'b00)?ar:
                                (FwdA3==2'b10)?dr:wrdata;
        assign sign_ext_d3 ={{8{ir3[7]}},ir3[7:0]};
        multiplexer ar_ir0(.a(aluSourceAR_src),.b(sign_ext_d3),.signal(p3_ar_ir),
                        .result(aluSourceAR));
        wire alu_s,alu_z,alu_c,alu_v;
        wire shif_s,shif_z,shif_c,shif_v;
        alu alu0(.opcode(p3_opcode),.ina(aluSourceAR),.inb(aluSourceBR),
                .out(aluResult),.s(alu_s),.z(alu_z),.c(alu_c),.v(alu_v));
        shifter shifter0(.opcode(p3_opcode),.d(ir3[3:0]),.in(aluSourceBR),
                .out(shifterResult),.s(shif_s),.z(shif_z),.c(shif_c),.v(shif_v));
        wire alu_shif_s,alu_shif_z,alu_shif_c,alu_shif_v;
        assign alu_shif_s = (p3_alu_shif == 1'b0) ? alu_s : shif_s ;
        assign alu_shif_z = (p3_alu_shif == 1'b0) ? alu_z : shif_z ;
        assign alu_shif_c = (p3_alu_shif == 1'b0) ? alu_c : shif_c ;
        assign alu_shif_v = (p3_alu_shif == 1'b0) ? alu_v : shif_v ;
        ar_szcv ar_szcv0(.ar(aluSourceAR_src),
                        .s(ar_s),.z(ar_z),.c(ar_c),.v(ar_v));
        assign szcv[3] = (p3_alu_shif_ar == 1'b0) ? alu_shif_s : ar_s ;
        assign szcv[2] = (p3_alu_shif_ar == 1'b0) ? alu_shif_z : ar_z ;
        assign szcv[1] = (p3_alu_shif_ar == 1'b0) ? alu_shif_c : ar_c ;
        assign szcv[0] = (p3_alu_shif_ar == 1'b0) ? alu_shif_v : ar_v ;
        // szcv szcv0(.clock(clock),.reset(reset),.s(s),.z(z),.c(c),.v(v),.ce(ce_p1),
        //         .szcv(szcv));
        multiplexer alu_shif0(.a(aluResult),.b(shifterResult),.signal(p3_alu_shif),
                                .result(drSource));
        REG dr0(.clock(clock),.reset(reset),.value(drSource),.ce(~systemStopped),
                .register(dr));
        REG AR4(.clock(clock),.reset(reset),.value(aluSourceAR_src),.ce(~systemStopped),
                .register(ar4));
        ir IR4(.clock(clock),.reset(reset),.value(ir3),.ce(~systemStopped),
                .ir(ir4));
        control3 control4(.clock(clock),.reset(reset),.ce(~systemStopped),.memRead(p3_memRead),.data_input(p4_data_input_3),.regDstB_A(p5_regDstB_A_3),.dr_mdr(p5_dr_mdr_3),.regWren(p5_regWren_3),
                        .p3_memRead(p4_memRead),.p4_data_input(p4_data_input),.p5_regDstB_A(p5_regDstB_A_4),.p5_dr_mdr(p5_dr_mdr_4),.p5_regWren(p5_regWren_4));
        ram ram0(.address(dr[11:0]),.clock(~clock),.data(ar4),.wren(p3_4_memWren),
                .q(memQ));
        multiplexer data_input0(.a(memQ),.b(in),.signal(p4_data_input),
                                .result(mdrSource));
        REG DR5(.clock(clock),.reset(reset),.value(dr),.ce(~systemStopped),
                .register(dr5));
        ir IR5(.clock(clock),.reset(reset),.value(ir4),.ce(~systemStopped),
                .ir(ir5));
        control3 control5(.clock(clock),.reset(reset),.ce(~systemStopped),.regDstB_A(p5_regDstB_A_4),.dr_mdr(p5_dr_mdr_4),.regWren(p5_regWren_4),
                        .p5_regDstB_A(p5_regDstB_A),.p5_dr_mdr(p5_dr_mdr),.p5_regWren(p5_regWren));
        assign wraddr=(p5_regDstB_A== 1'b0) ? ir5[10:8]:ir5[13:11];
        REG mdr0(.clock(clock),.reset(reset),.value(mdrSource),.ce(~systemStopped),
                .register(mdr));
        multiplexer dr_mdr0(.a(dr5),.b(mdr),.signal(p5_dr_mdr),
                        .result(wrdata));

endmodule