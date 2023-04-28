module demultiplexer(input [15:0] in,
                    input signal,//If the signal is 0, choose a, if 1, choose b.
                    output reg [15:0] a,b);
    always @(*) begin
        if(signal == 1'b0)begin
            a <= in;
            b <= 0;
        end else begin
            a <= 0;
            b <= in;
        end 
    end
endmodule