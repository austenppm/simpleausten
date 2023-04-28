module multiplexer(input [15:0] a,b,
                    input signal,//If the signal is 0, choose a, if 1, choose b.
                    output [15:0] result);
    assign result = (signal == 1'b0) ? a : b ;
endmodule