module top_module (
    input a, 
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        out = (a & ~c) | (~a & b) | (c & ~d) | (~c & d);
    end

endmodule