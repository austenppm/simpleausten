module adder16(input [15:0] pc2,sign_ext_d,
                output [15:0] jumpAddr);
//組み合わせ回路で
//jumpAddr=PC2+sign_ext_d
assign jumpAddr = pc2 + sign_ext_d;
endmodule